# YOBU — Contexte projet

> Ce fichier est lu automatiquement par Claude Code à chaque session.
> Il est la source de vérité. Si une instruction ici contredit une demande ponctuelle, signale-le.

## Le produit en une phrase

YOBU met en relation des particuliers qui font le trajet domicile→travail en voiture le matin (et travail→domicile le soir) avec des personnes non-véhiculées qui font le même trajet, à Dakar.

**Ce n'est pas** du covoiturage longue distance. Le trajet est court, **récurrent**, à heure fixe, entre les mêmes deux points, avec les mêmes gens. Toute décision produit ou technique découle de ça.

## Le contexte que tu dois avoir en tête

Le covoiturage domicile-travail **existe déjà** à Dakar, autour de **points de rencontre** informels où les conducteurs paient ~500 F par trajet pour prendre 4 clients. YOBU ne crée pas un comportement.

**Zone de lancement : Keur Massar → Plateau.** Toutes les données de test, tous les exemples, tous les seeders utilisent ce corridor et de vraies coordonnées de cette zone. Pas de Paris-Lyon, pas de lorem ipsum géographique.

> **Le gâchis qu'il supprime :** un conducteur et un passager quittent le même quartier et font chacun 1 à 3 km pour se retrouver au point. Ils étaient à 400 m l'un de l'autre.

**Conséquence directe sur le code :** le matching (`ST_DWithin(route, passager, 1500 m)`) *est* le produit. Il teste la seule hypothèse du projet — que la densité naturelle d'un quartier suffit, sans point de convergence. Tout le reste est du CRUD autour.

## Les trois vérités du produit

1. **La récurrence est le produit.** Un utilisateur configure son trajet une fois, pas tous les matins. L'app doit être quasi-invisible en régime établi.
2. **La confiance avant le prix.** Monter dans la voiture d'un inconnu se fait déjà, mais via un point qui sert de tiers de confiance. Sans ce point, c'est l'app qui doit répondre à « qui est cette personne ? » sur chaque écran.
3. **Le matching est le cœur technique.** Tout le reste est du CRUD.

## Stack

**Monorepo. Deux codebases, un seul contexte.**

```
yobu/
├── CLAUDE.md          ← tu es ici
├── docs/              ← la source de vérité, lis-la avant de coder
├── api/               ← Laravel 12, PHP 8.3
└── app/               ← Flutter 3, Dart 3
```

- **API** : Laravel 12 · **PostgreSQL 16 + PostGIS** · Sanctum (JWT). *(Laravel 11 prévu à l'origine : refusé par Composer le 18/07 — fin du support sécurité en mars 2026, avis de sécurité non corrigés sur toutes les 11.x. Laravel 12 = mêmes conventions.)*
  - **Dev local** : `docker compose up -d` → image `postgis/postgis:16-3.4`. C'est là que je passe mes journées.
  - **Prod** : VPS (Europe). Le squelette y est déployé depuis le J1 — si le déploiement casse, on le sait tout de suite, pas au J19.
  - **O2switch a été envisagé et écarté** (PostgreSQL 9.6 en fin de vie, PostGIS impossible sans superuser, mutualisé inadapté à une API mobile). Ne me le represente pas. `docs/02-technique.md §8`
- **Mobile** : Flutter, Riverpod, go_router. **Android d'abord** (parc dakarois). iOS quand un utilisateur le demandera.
- **Firebase, réduit à deux usages, et deux seulement :**
  - **Auth téléphone (OTP)** — côté client uniquement. L'app récupère un ID token, l'API le vérifie.
  - **Cloud Messaging (FCM)** — les push. Il n'y a pas d'alternative sérieuse.
  - **Pas de Firestore. Pas de Cloud Functions. Pas de Firebase Storage.** Si tu me proposes l'un des trois, c'est que tu as mal lu.
- **Cartes** : Google Maps SDK (`google_maps_flutter`), Places Autocomplete **avec session tokens** (sinon chaque frappe est facturée), **Routes API** pour les itinéraires — pas Directions API, qui est legacy.
- **Paiement** : **aucun en V1 — cash, en main propre.** L'app affiche le prix, c'est tout. **Zéro ligne de code de paiement avant la semaine 7** (S5-S6 = recrutement terrain, pas de dev). Le prestataire (Wave direct vs agrégateur) n'est **pas tranché** — voir `docs/02-technique.md §7`. Si je te demande de coder du paiement avant ça, rappelle-moi ce paragraphe.
- **Chat** : **il n'y en a pas.** Un deep link WhatsApp. Voir `docs/01-produit.md §2`.

## La frontière API / app — la règle qui structure tout

> **L'app Flutter ne contient aucune logique métier. Zéro.**
> Elle affiche ce que l'API renvoie et poste ce que l'utilisateur saisit. Le matching, le calcul des notes, les places disponibles, les prix : **tout est dans Laravel**.

Pourquoi : le téléphone de l'utilisateur ne mérite pas confiance. Si le calcul de la note vivait dans l'app, quelqu'un se mettrait 5 étoiles. Et : une règle métier écrite à deux endroits est une règle métier fausse à un endroit.

**Concrètement :**
- Aucun `if` sur un prix, une distance ou une place disponible côté Flutter.
- L'app ne calcule jamais une durée, un score, une compatibilité.
- Si un écran a besoin d'une donnée dérivée, l'API la renvoie **déjà calculée**. On ajoute un champ à la réponse, on ne calcule pas dans le widget.

## Conventions — API (`api/`)

```
app/
  Models/               # User, Trip, Booking, Rating
  Http/
    Controllers/Api/    # un contrôleur par ressource, fin
    Requests/           # TOUTE validation ici, jamais dans le contrôleur
    Resources/          # TOUTE sérialisation ici, jamais de Model->toArray()
  Services/             # la logique métier : TripMatchingService, RatingService
  Policies/             # les autorisations
database/migrations/
tests/Feature/          # tests des endpoints
```

**Règles :**
- **Contrôleurs fins.** Ils valident (via FormRequest), appellent un Service, renvoient une Resource. Pas de logique.
- **Toute la logique métier dans `Services/`.** Le matching vit dans `TripMatchingService`, nulle part ailleurs.
- **Jamais de requête N+1.** `with()` systématique. Active `Model::preventLazyLoading()` en local.
- **Les autorisations passent par des Policies**, pas par des `if ($user->id === $trip->driver_id)` disséminés.
- Migrations pour tout changement de schéma. Jamais de SQL à la main en prod.
- Anglais pour le code, français pour les messages destinés à l'utilisateur.

## Conventions — App (`app/`) : Clean Architecture pragmatique

**Clean Architecture, mais 3 couches, pas 4.** On garde la séparation des responsabilités (le vrai bénéfice) sans le boilerplate dogmatique (le coût qui tue une deadline solo). Décidé le 17/07 — la version stricte est explicitement écartée, voir `docs/02-technique.md §10`.

```
lib/
  main.dart
  app/               # routing (go_router), thème, init, DI (Riverpod global)
  core/              # utils, extensions, erreurs (Failure), Result<T>
  shared/            # design system (theme/tokens.dart), widgets réutilisables
  features/
    trip/            # une feature = ces 3 couches, JAMAIS plus
      domain/
        trip.dart              # l'entité (freezed). C'EST le modèle, pas de doublon.
        trip_repository.dart   # l'INTERFACE abstraite (contrat)
      data/
        trip_repository_impl.dart  # implémente l'interface, orchestre l'API
        trip_api.dart              # les appels dio bruts, rien d'autre
      presentation/
        trip_controller.dart   # Riverpod (= le use case, sans la cérémonie)
        screens/  widgets/     # l'UI
    auth/  profile/  booking/  rating/   # même structure
```

**Le sens des dépendances — la règle qui porte tout :**
> `presentation → domain ← data`
>
> La couche `presentation` ne connaît **que l'interface** `domain/xxx_repository.dart`. Elle ne sait pas qu'il y a une API derrière. Le jour où on ajoute un cache ou on change de backend, on ne touche que `data/`.

**Règles :**
- **`presentation` ne dépend jamais de `data`.** Un controller injecte l'*interface* du repository (via Riverpod), jamais l'implémentation. C'est LE test de la clean archi — si un `screen` importe `trip_api.dart`, c'est cassé.
- **Aucun appel HTTP hors de `data/`.**
- **L'entité freezed EST le modèle.** Pas de mapper entité↔modèle : tant qu'il n'y a qu'une source (l'API), le doublon ne sert à rien. `fromJson`/`toJson` sur l'entité suffisent.
- **Pas de use case un-par-action.** Le controller Riverpod joue ce rôle. `CreateTripUseCase` pour un seul appel est du cérémonial — on ne le fait pas.
- Tous les modèles en `freezed`. Pas de `Map<String, dynamic>` dans l'UI.
- Pas de `setState` dans une feature — Riverpod partout.
- **Aucune valeur en dur** : couleurs, espacements, typos viennent de `shared/theme/tokens.dart`. Si un token manque, demande-le, ne l'invente pas.
- Chaque widget > 80 lignes se découpe.
- Pas de secrets dans le repo. `--dart-define`.

> **Quand on ajoutera vraiment des use cases :** si une action orchestre *plusieurs* repositories ou porte une vraie règle métier (pas juste « appelle l'API »), là un use case dans `domain/usecases/` se justifie. Pas avant. On part sans, on en ajoute un le jour où le besoin est réel — jamais par principe.

## Comment travailler avec moi (Claude Code)

**Avant de coder quoi que ce soit :**
1. Lis `docs/JOURNAL.md` — les 3 dernières entrées. C'est là qu'est l'état réel du projet, pas dans le code.
2. Lis `PLANNING.md` pour savoir où on en est, puis **le fichier du jour dans `jours/`** — il contient l'objectif, le prompt et le critère de fin.
3. Lis `docs/01-produit.md` (le scope V1 est **gelé** — si une demande sort du scope, dis-le au lieu de coder).
4. Lis `docs/02-technique.md` (le schéma de base de données fait autorité — ne l'invente pas, ne le modifie pas sans le dire).

**Pendant :**
- Une session = **une tâche de la roadmap**, pas plus.
- **Une tâche touche l'API *ou* l'app, rarement les deux.** Si elle touche les deux : l'API d'abord, testée, *puis* l'app. Jamais en même temps — c'est comme ça qu'on debug deux bugs qui se cachent l'un l'autre.
- Propose un plan avant d'écrire du code sur toute tâche > 1 fichier. J'approuve, puis tu codes.
- Si tu as besoin d'une décision produit que le doc ne tranche pas : **demande, ne devine pas**.

**Definition of Done — une tâche n'est finie que si :**
- [ ] API : `php artisan test` passe · le endpoint répond dans Postman/curl
- [ ] App : `flutter analyze` sans warning · ça tourne sur un émulateur Android
- [ ] Les Policies couvrent les nouvelles routes
- [ ] Pas de TODO orphelin ; si tu laisses une dette, tu l'écris dans `docs/DETTE.md`
- [ ] **Tu me proposes l'entrée de `docs/JOURNAL.md` du jour** (modèle en haut du fichier), pré-remplie avec ce qu'on a fait, coupé, et appris. Je la relis et je valide.
- [ ] Tu me rappelles de mettre **OK** dans `PLANNING.md`.

## Anti-patterns — ce que je ne veux jamais voir

- **De la logique métier dans Flutter.** Le péché capital de ce projet.
- Réécrire une feature qui marche « pour mieux faire ». On sort en 1 mois.
- Ajouter un package pour un besoin résolvable en 20 lignes.
- Des abstractions préventives (« au cas où on ferait du longue distance plus tard »). **Non.**
- Un contrôleur qui fait plus que valider → appeler un service → renvoyer une resource.
- Du code mort commenté.
- Des écrans hors de la liste dans `docs/01-produit.md`.

## Contexte solo dev

Je code seul, en un mois. Laravel et Flutter sont tous les deux mon terrain — ne m'explique pas les bases. Ça veut dire :
- Ma contrainte rare, c'est **mon attention**, pas le temps machine. Fais les choses en une passe propre.
- Un bug non reproductible ne se debug pas pendant 2h : on le note dans `docs/DETTE.md` et on avance.
- Si tu vois que je dérive du scope, **dis-le-moi**.
