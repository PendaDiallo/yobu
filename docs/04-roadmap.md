# YOBU — Roadmap 4 semaines (vue d'ensemble)

**Départ : lundi 20 juillet 2026. Beta en main des utilisateurs : vendredi 14 août 2026.**
20 jours ouvrés. Un jour = une tâche. Pas deux.

> **⚠️ Ce doc n'est pas ton outil quotidien.** Au quotidien, tu ouvres **[`PLANNING.md`](../PLANNING.md)** et le fichier du jour dans **`jours/`** — c'est là que sont les prompts à coller.
>
> Celui-ci est la vue d'ensemble : la logique des 4 semaines, les règles du mois, ce qui se coupe et ce qui ne se coupe jamais. **Tu l'ouvres une fois par semaine**, quand tu veux prendre du recul ou décider quoi sacrifier.

## Comment lire ce doc

Chaque jour a : un **objectif**, un **prompt Claude Code** prêt à coller, et un **critère de fin** binaire.
Si le critère n'est pas atteint le soir, tu ne passes pas au jour suivant — **tu coupes du scope**. Tu ne rattrapes jamais en travaillant le week-end : les week-ends sont ta marge, et tu vas en avoir besoin.

**La forme d'une journée type :**
```
30-45 min  design de l'écran du jour (docs/03-design-brief.md §5)
puis       une session Claude Code, le prompt ci-dessous
le soir    2 min : entrée dans docs/JOURNAL.md (Claude Code te la propose)
           critère de fin atteint ? → commit → jour suivant
                                non → coupe, ne rattrape pas
```

## Le principe d'ordonnancement : l'API précède toujours l'app

Tu as deux codebases. La tentation, c'est de faire une feature « de bout en bout » dans la journée. **Ne le fais pas.**

> **Règle : l'endpoint d'abord, testé au curl. L'écran ensuite.**
>
> Un bug d'API et un bug d'UI qui se cachent l'un l'autre, c'est 3h de debug pour 20 minutes de travail. Quand l'API répond juste au curl, tu *sais* que le bug suivant est côté Flutter. C'est ce qui te fait tenir 20 jours.

En pratique, la plupart des jours sont soit « API », soit « app ». Les deux se croisent rarement dans la même session.

---

## Semaine 1 — Fondations (20-24 juillet)

> À la fin : l'API tourne en ligne, tu te connectes depuis l'app avec ton vrai numéro, ton profil existe, et c'est beau.

**J1 (lun 20) — Le squelette + admin**
- Monorepo, Laravel 11, Postgres 16 + PostGIS, VPS, déploiement, Flutter.
- **Hors code, 30 min, à faire AVANT tout :** lancer la demande de compte marchand Wave Business + inscription PayDunya. Appeler Wave pour trancher « API marchande directe : oui/non ? ». Ça tourne en fond 6 semaines.
```
Initialise le monorepo YOBU selon l'arborescence de CLAUDE.md : api/ (Laravel 11,
PHP 8.3) et app/ (Flutter 3).
API : Postgres 16 + PostGIS (extension activée), Sanctum, kreait/laravel-firebase,
Model::preventLazyLoading() en local. Un endpoint /api/health.
App : Riverpod, go_router avec les 16 routes de docs/01-produit.md (écrans vides),
freezed, dio avec l'intercepteur Bearer.
Firebase : Auth téléphone + FCM UNIQUEMENT. Pas de Firestore, pas de Functions.
```
✅ **Fin :** `/api/health` répond depuis le VPS. `flutter run` affiche un écran. C'est sur GitHub. **Backups Postgres quotidiens activés** — pas « plus tard », aujourd'hui.

**J2 — Design system + `TripCard`**
```
Implémente app/lib/shared/theme/tokens.dart exactement comme spécifié dans
docs/03-design-brief.md §2, puis les 9 widgets du SOCLE (§3, premier tableau).
Pas les 4 autres — ils viendront avec leur feature (J7, J11, J14).
StarRating fait partie du socle : UserCard affiche une note dès le J5.
Pour chacun : tous les variants et états listés. Crée une route /debug qui affiche
tous les composants dans tous leurs états.
```
Consacre la demi-journée à `TripCard` — le seul composant qui mérite d'être designé hors urgence (`03-design-brief.md §5`).
✅ **Fin :** `/debug` montre les 9 composants du socle. Tu les regardes sur ton téléphone, **dehors, en plein soleil**.

**J3 — Le schéma + les modèles**
```
API : les 4 migrations de docs/02-technique.md §3 (users, trips, bookings, ratings)
avec TOUS les index, y compris les GIST. Les modèles Eloquent, les relations,
les factories, les seeders.
ATTENTION, les 3 pièges, lis-les avant de coder :
- trips.departure_time est un TIME, pas un timestamp.
- trips.seats_total ne se décrémente JAMAIS (places par date, cf §5).
- bookings n'a PAS de champ recurring.
Utilise geography(Point/LineString, 4326), pas geometry — les distances en mètres.
Écris un test qui vérifie le premier point.
```
✅ **Fin :** `php artisan migrate:fresh --seed` passe. `php artisan test` est vert.

**J4 — Auth de bout en bout**
```
API : POST /api/auth/firebase — le flux complet de docs/02-technique.md §2.
Vérification de l'ID token via kreait, User::firstOrCreate sur firebase_uid,
renvoi d'un token Sanctum. GET /api/me. Tests Feature.
App : phone_auth et otp_verify. Firebase Auth téléphone, +221 pré-rempli et
verrouillé. Gère : mauvais code, renvoi après 60s, numéro invalide, pas de réseau.
Stocke le token Sanctum dans flutter_secure_storage.
DEV : utilise les numéros de test de la console Firebase — chaque vrai SMS coûte
0,06 $, échecs compris.
```
✅ **Fin :** tu te connectes avec ton vrai numéro, une ligne apparaît dans `users`. **Teste avec 2 autres numéros réels aujourd'hui** — c'est le jour où les surprises opérateur sortent, pas le J19.

**J5 — Profil**
```
API : PATCH /api/me, POST /api/me/photo (upload + compression 800px/80%),
POST /api/me/fcm-token. UserResource. Les champs rating, rating_count,
trips_completed ne sont JAMAIS modifiables par le client — $fillable strict.
App : profile_setup, profile_view, profile_edit.
```
✅ **Fin :** profil complet avec photo. **Puis tu t'arrêtes.** Tu ne prends pas d'avance sur la semaine 2 — l'avance prise en S1 se paie toujours en S3.

---

## Semaine 2 — Le cœur (27-31 juillet)

> À la fin : un conducteur publie, un passager trouve. **C'est la semaine qui décide du projet.**

**J6 — Publier un trajet (API)**
```
API : POST /api/trips, GET /api/trips/mine, PATCH, DELETE + TripPolicy.
À la création : appel ROUTES API (pas Directions, legacy) UNE SEULE FOIS →
décode la polyline en LineString PostGIS, stocke route ET duration_minutes.
GET /api/trips/price-hint : la fourchette suggérée, calculée SANS appel Google —
ST_Distance à vol d'oiseau × 1,3, cf docs/02-technique.md §4bis. C'est une parade
réglementaire, pas du confort (01-produit.md §3bis).
Tests Feature.
```
✅ **Fin :** un trajet en base avec une `route` valide. `SELECT ST_AsText(route)` te montre une vraie ligne.

**J7 — Publier un trajet (app)**
```
App : le composant PlaceField (docs/03-design-brief.md §3), puis trip_create
et trip_my_list.
PlaceField : Places Autocomplete restreint à country:sn, AVEC session tokens
(sinon chaque frappe est facturée). DayPicker. showTimePicker natif — ne le
redessine pas. Le prix affiche la fourchette de GET /api/trips/price-hint,
avec un avertissement hors fourchette.
trip_my_list : toggle actif/inactif, suppression avec confirmation.
Analytics : trip_published.
```
✅ **Fin :** parcours conducteur complet. **Chronomètre-toi** : ouverture → trajet publié en moins de 3 min ? Sinon tu coupes des champs.

**J8 — LE MATCHING** ⚠️ *le jour le plus important du mois*
```
API : TripMatchingService + POST /api/trips/search.
La requête PostGIS de docs/02-technique.md §4, telle quelle. Le score en PHP sur
les lignes qui sortent.
Écris les tests AVANT le service. Cas : passager exactement sur le trajet · à 1,4 km ·
à 1,6 km (exclu) · horaire à +19 min · à +21 min (exclu) · trajet complet ce jour-là ·
aucun résultat.
N'appelle JAMAIS la Routes API ici — la route est déjà en base.
```
✅ **Fin :** tu seedes 5 trajets sur Keur Massar→Plateau, tu cherches depuis un point intermédiaire **au curl**, et les bons remontent en tête. Si le classement paraît absurde, tu ajustes les poids — pas le pipeline.

**J9 — La recherche (app)**
```
App : search + search_results, branchés sur POST /api/trips/search.
États : chargement, résultats, vide.
Chaque TripCard affiche les places libres POUR LA DATE cherchée — l'API les
renvoie déjà calculées, ne les calcule pas côté Flutter.
Analytics : search_performed avec results_count — c'est de là que sort le taux
de match, ta métrique n°1.
```
✅ **Fin :** tu cherches depuis l'app et tu vois des conducteurs.

**J10 — Tampon.** Le matching aura débordé. C'est normal, c'est prévu. **N'y mets rien.**

---

## Semaine 3 — La boucle (3-7 août)

> À la fin : deux personnes peuvent réellement faire un trajet ensemble.

**J11 — Réservation (API + app)**
```
API : POST /api/bookings (pending), GET /api/bookings, GET /api/bookings/received,
PATCH /api/bookings/{booking}.
L'acceptation suit EXACTEMENT le pseudo-code de docs/02-technique.md §5 :
transaction + lockForUpdate + comptage des accepted pour (trip_id, date).
Ne décrémente PAS seats_total. BookingPolicy : le conducteur seul accepte.
App : les composants WhatsAppButton (wa.me/221..., visible seulement une fois la
réservation acceptée) et RouteMap, puis trip_detail + trip_requests.
Analytics : booking_requested, booking_accepted.
```
✅ **Fin :** demande → acceptation → les places du jour se calculent juste. **Teste la course :** accepte deux demandes pour la dernière place quasi simultanément (deux onglets curl) — la seconde doit échouer proprement.

**J12 — Notifications push**
```
API : envoi FCM sur demande reçue, demande acceptée, demande refusée.
Job en queue (database driver, pas Redis — tu n'en as pas besoin).
App : réception FCM, deep link vers le bon écran au tap.
Android uniquement, pas iOS.
```
✅ **Fin :** notif reçue sur un vrai téléphone, app fermée.

**J13 — Bookings + home + le cron**
```
App : bookings (à venir / passées) et home (prochain trajet, actions rapides).
API : commande artisan dailyReminders, planifiée à 5h30 Africa/Dakar — notif aux
gens qui ont un trajet ce matin. Passage auto en 'completed' 2h après le départ.
Vérifie que le scheduler tourne bien sur le VPS (crontab).
```
✅ **Fin :** tu reçois un rappel à 5h30. (Oui, tu vas te lever pour vérifier.)

**J14 — Notation**
```
API : POST /api/ratings + RatingService. Recalcul de users.rating en transaction.
Les badges sont DÉRIVÉS dans UserResource, pas stockés (docs/02-technique.md §4ter) :
phone_verified toujours vrai, regular à 10 trajets. N'ajoute pas de colonne badges.
La contrainte UNIQUE (booking_id, from_user_id) fait le travail : les DEUX
participants notent, chacun une fois. RatingPolicy : booking completed + participant.
App : le composant TagChip, puis l'écran rating.
StarRating existe depuis le J2 (socle) — active son mode saisie, ne le réécris pas.
UserCard affiche déjà la note en lecture depuis le J5.
Analytics : trip_completed.
```
✅ **Fin :** noter met à jour la note. Conducteur ET passager peuvent noter le même trajet. Aucun des deux ne peut noter deux fois.

**J15 — Tampon n°2.** La semaine 3 déborde toujours. Elle absorbe aussi le coût net de la bascule Laravel. **N'y planifie rien.** Si contre toute attente elle n'a pas débordé, tu peux attaquer le J16 — c'est le seul endroit du mois où prendre de l'avance est permis.

---

## Semaine 4 — Rendre ça réel (10-14 août)

> À la fin : c'est entre les mains de vrais gens.

**J16 — Onboarding + états vides**
```
App : splash, welcome (3 slides), et TOUS les EmptyState.
Le message d'un écran vide est une décision produit, pas une décoration :
"Aucun conducteur sur ce trajet pour l'instant — on te prévient dès qu'il y en
a un" + capture de l'intention.
```
✅ **Fin :** aucun écran ne montre jamais du blanc.

**J17 — Finition + vérification des métriques**
```
App : tous les états de chargement, tous les cas d'erreur réseau, tous les
messages en français correct. Pas de nouvelle feature.
Puis vérifie dans Firebase Analytics que les 5 événements remontent :
trip_published, search_performed (avec results_count), booking_requested,
booking_accepted, trip_completed. Les 4 métriques de docs/05-strategie.md §5
doivent être calculables à partir d'eux — vérifie-le explicitement.
```
✅ **Fin :** téléphone en mode avion sur chaque écran, rien ne casse. Et tu lis ton taux de match dans la console.

**J18 — Le durcissement** ⚠️ *ne se coupe jamais*
```
Audit des Policies, endpoint par endpoint. Essaie, avec le token d'un autre user :
- PATCH un trip qui n'est pas le tien
- accepter un booking dont tu n'es pas le conducteur
- noter un booking auquel tu n'as pas participé
- écrire users.rating via PATCH /api/me
Chaque tentative doit renvoyer 403. Tests Feature pour chacune.
Puis : rate limiting sur /api/auth/firebase et /api/trips/search. Sentry.
Vérifie qu'aucun secret n'est dans le repo (le .json Firebase surtout).
HTTPS forcé. Backups Postgres testés — restaure-en un pour de vrai.
```
✅ **Fin :** les 4 attaques renvoient 403. Un backup a été restauré avec succès. **Une base ouverte, c'est le genre de chose qui tue un projet en une nuit.**

**J19 — Build + store**
```
Build release Android signé, pointant sur l'API de prod.
Fiche Play Store : description FR, captures, politique de confidentialité
(obligatoire). Publication en test interne.
```
✅ **Fin :** un APK installable, envoyé à 5 personnes.

**J20 — Le vrai test**
Pas de code. **Tu vas au point de rencontre, à 6h.** Tu fais installer l'app devant les gens, tu les regardes s'en servir, **tu ne les aides pas**. Tu notes tout.

Et tu comptes, parce que c'est là qu'est ton marché (`05-strategie.md §4`) : combien de conducteurs, combien de passagers, **combien de km chacun a marché pour venir jusqu'ici**, le prix exact payé au point.

✅ **Fin :** 5 personnes ont installé. Tu sais où ça bloque. Et tu connais ton marché par les chiffres, plus par intuition.

---

## Les règles du mois

1. **Un jour = une tâche = une session Claude Code.** Ne jamais empiler.
2. **L'API avant l'app, toujours.** Testée au curl avant qu'un widget existe.
3. **J10 et J15 sont tes tampons.** Ils vont servir. N'y mets rien.
4. **Le week-end n'est pas du temps de dev.** C'est ta marge et ton sommeil. C'est la règle que tu vas vouloir casser en premier, et celle qui coûte le plus cher.
5. **Si un jour déborde : tu coupes, tu ne rattrapes pas.** Ordre de sacrifice : badges · profile_edit · welcome slides · trip_my_list (toggle seulement).
6. **Ce qui ne se coupe jamais :** le matching (J8) et le durcissement (J18).
7. **Le J20 est le plus important du mois.** Ne le transforme pas en journée de code.

> **Sur le réalisme de ce planning, honnêtement :** la bascule vers Laravel coûte **~7 jours bruts** (une API à construire au lieu d'un backend clé en main) ; la coupe du chat en rend 3-4. **Net : +3 à 4 jours**, absorbés par les tampons J10 et J15. On tient — mais l'équilibre, c'est **deux jours de tampon pour 20 jours de travail**. C'est peu.
>
> Le J20 arrive, tu regardes où tu en es. Si tu es à 80 %, tu **sors quand même** avec les 80 % et tu coupes le reste. Une app incomplète entre les mains de 5 personnes t'apprend infiniment plus qu'une app complète dans ton émulateur. **La date est plus importante que le périmètre.** C'est le seul arbitrage qui compte.

## Après (pour mémoire)

- **S5-S6 : tu ne codes pas.** Tu es **au point de rencontre, à 6h**, avec une équipe payée à la commission (`05-strategie.md §4`). La liquidité y est déjà réunie — inutile de recruter à froid. Contre-intuitif après un mois de dev intensif, et c'est le bon choix : coder pour une app que personne n'utilise, c'est optimiser du vide.
- **S7-S8** : V1.1 — paiement Wave/OM (compte marchand actif depuis 6 semaines), vérification d'identité. À mi-temps, en parallèle du recrutement passagers.
- **Le chat intégré** : seulement si les utilisateurs le réclament. Reverb = 3 jours. Il y a de bonnes chances que WhatsApp suffise pour toujours.
- **iOS** : quand un utilisateur te le demandera. Pas avant.
- **La suite** : selon ce que le J20 et le terrain t'auront appris. Pas selon ce doc.
