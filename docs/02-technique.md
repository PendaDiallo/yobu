# YOBU — Technique

## 1. Architecture

```
┌─────────────────────────────┐
│  Flutter (Riverpod)         │   aucune logique métier
│                             │
│  Firebase Auth ─── OTP SMS  │   côté client uniquement
│       │ ID token            │
└───────┼─────────────────────┘
        │ Bearer <token Sanctum>
        ▼
┌─────────────────────────────┐
│  API Laravel 11 (VPS)       │
│    Controllers → Services   │   TOUTE la logique est ici
│         │                   │
│    PostgreSQL 16 + PostGIS  │
└───────┬─────────────────────┘
        │
        ▼  FCM (push)
```

**Pourquoi ce découpage.** Firebase ne garde que ce qu'il fait mieux que tout le monde : recevoir un SMS d'OTP sur un téléphone, et envoyer une notification push. Tout le reste — des données relationnelles avec de la géométrie — revient à Postgres, qui est fait pour ça.

## 2. Le flux d'authentification

Le seul endroit où Firebase et Laravel se parlent. Fais-le une fois, proprement, et n'y touche plus.

```
1. Flutter → Firebase Auth : "envoie un OTP au +221 77 XXX XX XX"
2. Firebase → SMS → l'utilisateur saisit le code
3. Firebase → Flutter : ID token (JWT signé par Google)
4. Flutter → POST /api/auth/firebase  { id_token }
5. Laravel : vérifie la signature du token via le Firebase Admin SDK (kreait/laravel-firebase)
             → extrait firebase_uid + phone_number
             → User::firstOrCreate(['firebase_uid' => ...])
             → renvoie un token Sanctum
6. Flutter : stocke le token Sanctum (flutter_secure_storage), l'envoie en Bearer
             sur TOUS les appels suivants
```

> **Le token Firebase ne sert qu'une fois, à l'étape 4.** Ensuite, c'est du Sanctum classique. Ne le renvoie pas à chaque requête — tu paierais une vérification Google à chaque appel pour rien.

Package : `kreait/laravel-firebase`. Un `.json` de service account, hors du repo.

## 3. Le schéma — la source de vérité

```sql
CREATE EXTENSION postgis;

-- users
id                bigserial PK
firebase_uid      varchar UNIQUE NOT NULL
phone             varchar UNIQUE NOT NULL       -- +221...
first_name        varchar NOT NULL
last_name         varchar NOT NULL
photo_url         varchar NULL
role              varchar CHECK (role IN ('driver','rider','both'))
rating            numeric(2,1) DEFAULT 0        -- écrit par RatingService UNIQUEMENT
rating_count      int DEFAULT 0
trips_completed   int DEFAULT 0
fcm_token         varchar NULL
created_at, updated_at

-- trips : le trajet RÉCURRENT du conducteur
id                bigserial PK
driver_id         bigint FK → users
origin_label      varchar NOT NULL
origin_point      geography(Point, 4326) NOT NULL
dest_label        varchar NOT NULL
dest_point        geography(Point, 4326) NOT NULL
route             geography(LineString, 4326) NOT NULL  -- polyline Routes API, décodée
departure_time    time NOT NULL                 -- "06:45" — PAS un timestamp
duration_minutes  int NOT NULL                  -- renvoyé par Routes API à la création
days_of_week      smallint[] NOT NULL           -- {1,2,3,4,5}, lundi=1
seats_total       smallint NOT NULL             -- par occurrence. JAMAIS décrémenté.
price_per_seat    int NOT NULL                  -- FCFA
active            boolean DEFAULT true
created_at, updated_at

-- bookings : une occurrence, un jour donné
id                bigserial PK
trip_id           bigint FK → trips
rider_id          bigint FK → users
date              date NOT NULL                 -- LE jour concerné
status            varchar CHECK (status IN ('pending','accepted','rejected','cancelled','completed'))
seats             smallint DEFAULT 1
price_paid        int NOT NULL
created_at, updated_at
UNIQUE (trip_id, rider_id, date)                -- pas deux demandes le même jour

-- ratings
id                bigserial PK
booking_id        bigint FK → bookings
from_user_id      bigint FK → users
to_user_id        bigint FK → users
score             smallint CHECK (score BETWEEN 1 AND 5)
tags              varchar[]                     -- {ponctuel,sympa,conduite_sure,voiture_propre}
comment           text NULL
created_at
UNIQUE (booking_id, from_user_id)               -- chacun note l'autre, une seule fois
```

**Index :**
```sql
CREATE INDEX trips_route_gix       ON trips USING GIST (route);
CREATE INDEX trips_dest_gix        ON trips USING GIST (dest_point);
CREATE INDEX trips_active_days_idx ON trips (active) INCLUDE (days_of_week);
CREATE INDEX bookings_trip_date    ON bookings (trip_id, date, status);
CREATE INDEX bookings_rider_date   ON bookings (rider_id, date DESC);
```

**Les trois pièges du modèle :**

> ⚠️ **`departure_time` est une `time`, pas un `timestamp`.** Un trajet récurrent n'a pas de date. C'est l'erreur n°1 — elle contamine tout le modèle si on la laisse passer.

> ⚠️ **`seats_total` ne se décrémente jamais.** Un trajet récurrent n'a pas « des places restantes » : il a 3 places *le mardi* et 3 places *le mercredi*. Les places libres se calculent par date (§5).

> ⚠️ **Pas de champ `recurring` sur `bookings`.** Le *trajet* est récurrent — c'est ça le produit. La *réservation* est ponctuelle, une par jour. Le renouvellement auto est une commodité, il est en V1.1.

## 4. Le matching — et voilà pourquoi on a changé de stack

**`TripMatchingService::search(origin, destination, arrivalBefore, date)`**

Un passager n'a pas le même point de départ que le conducteur. On cherche les trajets **dont l'itinéraire passe près de lui**. En PostGIS, c'est une requête.

```sql
SELECT
  t.*,
  ST_Distance(t.route, :rider_origin)     AS pickup_distance_m,
  ST_Distance(t.dest_point, :rider_dest)  AS dropoff_distance_m,
  u.rating,
  (SELECT COUNT(*) FROM bookings b
     WHERE b.trip_id = t.id AND b.date = :date AND b.status = 'accepted') AS seats_taken
FROM trips t
JOIN users u ON u.id = t.driver_id
WHERE t.active
  AND :day_of_week = ANY(t.days_of_week)
  -- le passager est à moins de 1,5 km de l'itinéraire
  AND ST_DWithin(t.route, :rider_origin, 1500)
  -- sa destination est à moins de 3 km de celle du trajet
  AND ST_DWithin(t.dest_point, :rider_dest, 3000)
  -- il arrive à l'heure (± 20 min de tolérance)
  AND (t.departure_time + (t.duration_minutes || ' minutes')::interval)
      <= (:arrival_before::time + interval '20 minutes')
  -- il reste de la place ce jour-là
  AND (SELECT COUNT(*) FROM bookings b
         WHERE b.trip_id = t.id AND b.date = :date AND b.status = 'accepted') < t.seats_total
ORDER BY pickup_distance_m ASC
LIMIT 50;
```

> **Le SQL sort 50 candidats bruts, triés par proximité. Il ne trie pas par score** — le score n'existe pas en base, il dépend d'une normalisation du prix sur l'ensemble des résultats. Si tu vois `ORDER BY score` dans une requête, c'est faux.

**Le score, puis le top 10, en PHP** sur les ≤ 50 lignes :
```
score = 0.4 × (1 - pickup_distance_m / 1500)
      + 0.3 × (1 - |Δminutes| / 20)
      + 0.2 × (rating / 5)
      + 0.1 × prix normalisé sur les résultats (inversé)

→ usort par score DESC → take(10)
```
Les poids somment à 1,0. Le `LIMIT 50` est là pour borner le travail de PHP, pas pour sélectionner : à ton volume, les filtres géo et horaire auront déjà tout écrémé bien avant 50.

> **Compare avec ce qu'il aurait fallu faire en Firestore :** filtre par préfixe de geohash, puis re-filtrage en mémoire, puis décodage manuel de chaque polyline, puis calcul point-segment à la main, puis re-filtrage. Quatre étapes, ~200 lignes, et un index géographique approximatif.
>
> Ici : `ST_DWithin(route, point, 1500)` sur un index GIST. **C'est le cœur technique de YOBU et il tient en une requête.** C'est ça qui justifie la bascule, bien plus que ton confort en PHP.

**Écris les tests de `TripMatchingService` avant l'UI de recherche.** C'est le seul endroit du projet qui mérite vraiment des tests : un matching qui « marche presque » est invisible à l'œil et fatal au produit. Cas à couvrir : passager exactement sur le trajet · à 1,4 km · à 1,6 km (exclu) · horaire à +19 min · à +21 min (exclu) · trajet complet ce jour-là · aucun résultat.

## 4bis. La fourchette de prix — sans appeler Google

`GET /api/trips/price-hint?origin=lat,lng&destination=lat,lng` → `{ min, suggested, max }`

Le piège : la fourchette s'affiche **pendant que le conducteur saisit**, avant que le trajet existe. Or `duration_minutes` et `route` ne sont calculés qu'à la création. D'où sort la distance ?

**Réponse : de Postgres, pas de Google.**
```sql
SELECT ST_Distance(
  ST_MakePoint(:o_lng, :o_lat)::geography,
  ST_MakePoint(:d_lng, :d_lat)::geography
) AS straight_m;
```
Distance à vol d'oiseau × **1,3** (le facteur de sinuosité urbain classique) → distance routière approchée. Puis :
```
suggested = round(km × 50, -2)        -- ~50 F/km, arrondi à la centaine
min       = max(400,  suggested × 0.7)
max       = min(2000, suggested × 1.4)
```

> **Zéro appel API.** Une suggestion de prix n'a pas besoin d'être exacte au mètre — elle a besoin d'être *plausible* et *instantanée*. Appeler la Routes API à chaque frappe pendant la saisie, ce serait payer Google pour afficher un ordre de grandeur.

Pas de colonne `distance_m` sur `trips` : personne n'en a besoin après coup.

## 4ter. Les badges — dérivés, pas stockés

`users` n'a **pas** de colonne `badges`. Ils se calculent dans `UserResource` :

```php
'badges' => array_filter([
    'phone_verified',                                  // toujours vrai : l'auth EST un OTP
    $user->trips_completed >= 10 ? 'regular' : null,
]),
```

**Ce sont les deux seuls badges de la V1.** Pas de `punctual` (il faudrait mesurer la ponctualité, donc du GPS, qu'on n'a pas). Si tu vois quelqu'un ajouter une colonne `badges`, c'est qu'il a raté ce paragraphe : une donnée dérivable n'est jamais stockée, sinon elle se désynchronise.

## 5. Les places disponibles — par date, jamais par trajet

Les places libres d'un trajet le 4 août = `seats_total` − (bookings `accepted` pour ce `trip_id` à cette `date`). Rien à décrémenter, aucune table d'occurrences.

**L'acceptation d'une réservation — dans une transaction, avec un verrou :**
```php
DB::transaction(function () use ($booking) {
    $trip = Trip::where('id', $booking->trip_id)->lockForUpdate()->first();

    $taken = Booking::where('trip_id', $trip->id)
        ->where('date', $booking->date)
        ->where('status', 'accepted')
        ->count();

    if ($taken >= $trip->seats_total) {
        throw new TripFullException();
    }

    $booking->update(['status' => 'accepted']);
});
```

> **Le `lockForUpdate()` n'est pas optionnel.** Deux passagers acceptés pour la dernière place à la même seconde, c'est le bug classique : les deux passent, quelqu'un reste sur le trottoir à 6h30. C'est le seul endroit de la V1 où une race condition a une conséquence physique.

## 6. Les endpoints

Tout est sous `auth:sanctum` sauf le premier.

```
POST   /api/auth/firebase          { id_token } → { token, user }

GET    /api/me
PATCH  /api/me                      profil
POST   /api/me/photo                upload
POST   /api/me/fcm-token

GET    /api/trips/price-hint        { origin, destination } → { min, suggested, max }
POST   /api/trips                   publier un trajet récurrent
GET    /api/trips/mine
PATCH  /api/trips/{trip}            activer/désactiver
DELETE /api/trips/{trip}

POST   /api/trips/search            { origin, destination, arrival_before, date } → top 10
GET    /api/trips/{trip}            fiche + places libres pour une date

POST   /api/bookings                { trip_id, date } → pending
GET    /api/bookings                mes réservations (à venir / passées)
GET    /api/bookings/received       demandes reçues (conducteur)
PATCH  /api/bookings/{booking}      { status: accepted|rejected|cancelled }

POST   /api/ratings                 { booking_id, score, tags, comment }
```

**Les autorisations passent par des Policies**, pas par des `if` dans les contrôleurs :
- `TripPolicy::update/delete` → seulement `driver_id`
- `BookingPolicy::view` → `rider_id` ou `driver_id` du trajet
- `BookingPolicy::respond` → **le conducteur seul** peut accepter/refuser
- `RatingPolicy::create` → le booking est `completed` ET l'auteur en est participant

## 7. Ce qui n'est PAS là, et pourquoi

**Le chat.** Il n'y en a pas. Un bouton « Écrire sur WhatsApp » qui ouvre `https://wa.me/221XXXXXXXXX`. Trois jours de WebSockets économisés (Reverb + une infra à maintenir), et tes utilisateurs sont déjà sur WhatsApp toute la journée. **C'est ce troc qui finance la bascule vers Laravel** et fait tenir la date du 14 août. Si tu le regrettes, le retour de Reverb coûte 3 jours en V1.1 — pas plus.

**Le paiement.** Rien en V1, cash en main propre.

Ce que j'ai trouvé (juillet 2026), **à vérifier toi-même avant de coder** :
- **Wave Business API** : ~10 endpoints sur `api.wave.com/v1`, auth Bearer, webhooks signés, sandbox. **1 % par transaction, plafonné à 5 000 F.** Compte marchand : **activation 5-10 jours ouvrables**. ⚠️ Certaines sources affirment qu'il n'existe pas d'API marchande publique directe et qu'il faut passer par un agrégateur — **c'est la question à trancher en premier**, elle change la décision.
- **Orange Money** : API SDP, validation marchand 3-6 semaines. À écarter en direct.
- **Agrégateurs** (PayDunya sénégalais, CinetPay, PayTech) : une API pour Wave + Orange + Free + cartes. **2 % à 3,5 %**.

**Le calendrier :**
1. **J1, 30 min** : tu lances la demande de compte marchand Wave Business **et** l'inscription PayDunya. Ça tourne en fond 6 semaines.
2. **Semaine 1** : tu appelles Wave, tu tranches « API directe : oui ou non ? ». Tu ne codes rien.
3. **V1 (S1-S4)** : cash. `price_paid` existe déjà, l'app affiche « 1 000 F à régler au conducteur ».
4. **V1.1 (S7-S8)** : tu branches. Pas avant — S5-S6 sont au recrutement terrain (`05-strategie.md §3`). Tu ajoutes `bookings.payment_status` et `payment_ref`, rien d'autre ne bouge.

> **Ne prends pas de commission en V1.** Si tu encaisses, tu deviens responsable des litiges et tu tombes dans une zone réglementaire (agrégation de paiement) que tu ne veux pas gérer seul. En V1.1 : le passager paie le conducteur via l'app, **YOBU ne prend rien**. La commission vient avec le volume et un statut clair.

## 8. Hébergement

### La décision (17/07) : VPS, pas de mutualisé

**O2switch a été envisagé et écarté.** Ce qu'on a trouvé :
- PostgreSQL y existe, mais en **9.6** — fin de vie depuis novembre 2021 — et **O2switch envisage d'arrêter de le proposer**.
- **PostGIS demande les droits superuser** pour `CREATE EXTENSION`. Sur du mutualisé cPanel, tu ne les as pas.
- Pas de supervisor pour les queues (contournable par cron, mais symptomatique).
- Le vrai problème n'est pas le spatial, c'est le **mutualisé pour une API mobile** : limites CPU en fair-use, aucun contrôle, aucun diagnostic possible.

> **Le repli MariaDB existait et était viable** — `ST_Distance` point→linestring, `SPATIAL INDEX`, et une projection équirectangulaire centrée sur Dakar (14°N, erreur < 0,1 % — la géographie du Sénégal nous sauvait). **Il a été écarté au profit de PostGIS.** Si tu relis ça dans 6 mois en te demandant pourquoi on n'a pas économisé 5 €/mois : parce que la bascule MariaDB→PostGIS coûte 2-3 jours, et qu'on a choisi une fois plutôt que deux.

### La prod

- **Un VPS suffit largement.** 2 vCPU / 4 Go. Hetzner, DigitalOcean, OVH. **~5-10 €/mois.**
- **Localise-le en Europe (Paris/Francfort).** ~50 ms de latence depuis Dakar — imperceptible pour du REST.
- Laravel Forge (12 $/mois) si tu veux zéro friction, ou déploiement manuel + Caddy. **Tu sais faire — ne me laisse pas te réexpliquer.**
- **Backups Postgres quotidiens dès le J1.** Automatiques, et **restaurés pour de vrai au J18**. Un backup jamais testé n'est pas un backup.
- Sentry pour les erreurs API (gratuit à ton volume).

### Le dev local — c'est là que tu passes tes journées

```yaml
# docker-compose.yml
services:
  db:
    image: postgis/postgis:16-3.4     # PostGIS inclus, l'extension est créée à l'init
    environment:
      POSTGRES_DB: yobu
      POSTGRES_USER: yobu
      POSTGRES_PASSWORD: secret
    ports: ["5432:5432"]
    volumes: ["dbdata:/var/lib/postgresql/data"]
volumes:
  dbdata:
```
`.env` : `DB_CONNECTION=pgsql`, `DB_HOST=127.0.0.1`, `DB_PORT=5432`.

**Tu développes en local, tu déploies quand tu veux.** Zéro latence, `migrate:fresh` autant de fois que tu veux.

### 🎯 Le principe qui compte : déploie le squelette au J1

> **Si tu attends le J19 pour déployer, tu découvriras tes problèmes de déploiement au J19** — avec 5 personnes qui attendent l'APK et zéro jour de marge.

Déploie quand `/api/health` renvoie juste `{"ok":true}`. À ce moment-là, une extension `pgsql` manquante ou un souci de permissions se règle en 20 minutes, parce que rien d'autre ne peut casser. Le même problème au J19 te coûte ta date.

**Et le VPS devient obligatoire au J13** de toute façon : le rappel de 5h30 ne se teste pas sur une machine qui se met en veille.

### Les 2 pièges du dev local

| Piège | Parade |
|---|---|
| **L'émulateur Android ne voit pas ton `localhost`** | Pour lui, ta machine c'est **`10.0.2.2`**. `API_URL=http://10.0.2.2:8000`. Tu perdras 30 min au J4 si tu l'ignores. |
| **`php artisan serve` n'écoute que `127.0.0.1`** | Pour tester sur ton vrai téléphone en Wi-Fi : `php artisan serve --host=0.0.0.0`, puis `http://192.168.x.x:8000` depuis le tel. |

## 9. Ce qui va te ralentir — anticipé

| Piège | Parade |
|---|---|
| Auth téléphone + numéros sénégalais | Tester avec de vrais +221 dès le J4. **Mais développer avec les numéros de test de la console** — chaque vrai SMS coûte 0,06 $, échecs compris. |
| Décoder la polyline Routes API → LineString PostGIS | Fais-le **dans l'API à la création du trajet**, une fois. Une lib PHP de décodage de polyline + `ST_GeomFromText`. Ne le fais jamais à la recherche. |
| `departure_time` en timestamp | Voir §3. Si tu vois un `Carbon` complet sur un trip, c'est déjà cassé. |
| Fuseau horaire | Dakar = UTC+0, pas de DST. Tu as de la chance. **Ne surtout pas over-engineer.** |
| Facturation Google Maps | Places Autocomplete facture **chaque frappe** sans *session tokens*. Restreindre à `country:sn`. **Routes API**, pas Directions (legacy). |
| PostGIS sur `geography` vs `geometry` | Utilise `geography` : les distances sont en mètres, pas en degrés. C'est ce qui t'évite les conversions foireuses. |
| Le matching qui « marche presque » | Tests unitaires du service **avant** l'UI. Voir §4. |
| iOS | Compte Apple Developer 99 $/an + certificats. **Android d'abord.** |
| **Sur-ingénierie de la clean archi** | Voir §10. Si tu écris un mapper ou un use case trivial, tu as dépassé la ligne. |

## 10. Clean Architecture côté Flutter — la version qu'on fait, et celle qu'on ne fait pas

**Décision du 17/07.** On veut la *séparation des responsabilités*, pas les *4 couches dogmatiques*. Un solo dev en 20 jours n'a pas le budget du boilerplate d'Uncle Bob, et la clean archi protège contre un changement qui, en V1, n'arrivera pas.

### Les 3 couches, sur l'exemple « publier un trajet »

```
lib/features/trip/
├── domain/                          ← le QUOI, sans dépendance technique
│   ├── trip.dart                    ← entité freezed, avec fromJson/toJson
│   └── trip_repository.dart         ← abstract class : le CONTRAT
├── data/                            ← le COMMENT, tourné vers l'extérieur
│   ├── trip_api.dart                ← dio brut : POST /api/trips
│   └── trip_repository_impl.dart    ← implémente le contrat, appelle trip_api
└── presentation/                    ← le VISIBLE
    ├── trip_controller.dart         ← Riverpod : orchestre, expose l'état
    └── screens/trip_create_screen.dart
```

```dart
// domain/trip_repository.dart — le contrat. La présentation ne connaît QUE ça.
abstract class TripRepository {
  Future<Trip> create(Trip trip);
  Future<List<Trip>> mine();
}

// data/trip_repository_impl.dart — l'implémentation. Injectée via Riverpod.
class TripRepositoryImpl implements TripRepository {
  TripRepositoryImpl(this._api);
  final TripApi _api;
  @override
  Future<Trip> create(Trip trip) async => Trip.fromJson(await _api.postTrip(trip.toJson()));
  // ...
}

// app/ (DI) — le seul endroit qui relie l'interface à l'implémentation
final tripRepositoryProvider = Provider<TripRepository>((ref) =>
    TripRepositoryImpl(ref.watch(tripApiProvider)));

// presentation/trip_controller.dart — dépend de l'INTERFACE, pas de l'impl
class TripController extends AsyncNotifier<...> {
  TripRepository get _repo => ref.read(tripRepositoryProvider);
  Future<void> publish(Trip t) => _repo.create(t);   // c'est ça, le « use case »
}
```

### Le test qui dit si c'est bon

> **Un fichier de `presentation/` importe-t-il quelque chose de `data/` ?**
> Oui → cassé. La présentation ne connaît que `domain/`. C'est toute la clean archi en une phrase.

### Ce qu'on NE fait PAS — et pourquoi

| Rejeté | Pourquoi |
|---|---|
| `usecases/create_trip.dart` (une classe par action) | Le controller Riverpod le fait déjà. Une classe pour un seul appel API = cérémonie pure. |
| Mapper `TripModel` ↔ `TripEntity` | Tant qu'il y a **une** source (l'API), le doublon ne protège de rien. L'entité freezed EST le modèle. |
| Une 4ᵉ couche `datasources/` séparée de `data/` | `trip_api.dart` suffit. On ajoutera un `datasources/` le jour où il y a un cache local **et** l'API — pas avant. |

### Quand on remontera en gamme (pas maintenant)

- **Un vrai use case** dans `domain/usecases/` se justifie le jour où une action orchestre **plusieurs** repositories ou porte une règle métier réelle. Exemple plausible en V1.1 : « réserver ET débiter un crédit » toucherait `BookingRepository` + `CreditRepository`.
- **Un mapper** se justifie le jour où le cache local a une forme différente de l'API.

On ajoute ces couches **quand le besoin est réel**, jamais par principe. La règle : le boilerplate se paie à l'usage, pas à l'avance.

---

**Sources (à vérifier avant de coder le paiement) :**
- [Wave Business API Sénégal : guide intégration 2026 — Kolonell](https://kolonell.com/fr/blog/wave-business-api-integration-site-2026)
- [Mobile money en backend : Wave, Orange Money, PayDunya, CinetPay — Sentur](https://sentur.net/mobile-money-backend-afrique-ouest/)
- [SOFTPAY — Documentation PayDunya](https://developers.paydunya.com/doc/FR/softpay)
- [PayTech — paiement en ligne Orange Money / Wave](https://paytech.sn/)
- [Intégrer Wave, Orange Money et Stripe : guide e-commerce sénégalais 2026 — Absitech](https://absitech.dev/blog/integrer-wave-orange-money-stripe-e-commerce-senegalais-2026)
