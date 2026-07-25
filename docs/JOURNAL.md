# Journal de bord

> **À quoi ça sert :** Claude n'a pas de mémoire entre les conversations. Toi non plus, dans 3 semaines.
> Ce fichier est la mémoire du projet. 2 minutes le soir, et n'importe quelle session future
> (la mienne ou la tienne) sait où on en est sans relire le code.
>
> **La règle :** une entrée par jour, le soir, même les jours ratés. **Surtout** les jours ratés.
> Un jour non écrit est un jour dont on ne tirera aucune leçon.

## Comment démarrer une session Claude Code

```
On est au J[N]. Lis CLAUDE.md, docs/JOURNAL.md (les 3 dernières entrées) et
jours/J[NN]-*.md. Fais le point sur ce qui est fait, puis attaque le jour.
```

---

## Modèle à copier

```markdown
### J[N] — [date] — [titre du jour]

**Fait :**
-

**Critère de fin atteint :** oui / non — [si non, pourquoi]

**Coupé / reporté :**
-

**Ce que j'ai appris :**
-

**Bloqué sur :**
-

**Demain :** J[N+1] — [titre]
```

---

## Entrées

### Note technique — 25/07 — Durcissement API anticipé (item du J18 fait en avance)

En testant le matching au curl, 500 « Route [login] not defined » : une requête `api/*`
non authentifiée tentait un redirect web au lieu de renvoyer du JSON.
**Corrigé dans `bootstrap/app.php`** : `shouldRenderJsonWhen(api/* || expectsJson)`.
Désormais un token manquant → `401` propre. **→ à cocher comme déjà fait au J18.**

### J0 — 16 juillet 2026 — Conception + bascule de stack

**Fait :**
- Structuration complète du projet (README + CLAUDE.md + 9 docs)
- Niche confirmée : pendulaires domicile-travail, Dakar
- **Stack changé en cours de route** — voir ci-dessous
- Scope V1 gelé à **16 écrans**

**LA décision du jour — Firebase → Laravel :**

Le plan initial était Flutter + Firebase (Firestore + Cloud Functions). Basculé sur **Laravel 11 + PostgreSQL/PostGIS**, Firebase réduit à l'auth SMS + les push.

*Pourquoi :*
1. Laravel est mon outil principal → la bascule coûte **~7 jours bruts** (+1,5 semaine), pas +3 comme si je l'apprenais. Et quand ça casse à 23h, je sais réparer.
2. **PostGIS.** Le matching passe de ~200 lignes (geohash + décodage polyline + point-segment à la main) à **une requête `ST_DWithin`**. C'est le cœur du produit — c'est la vraie raison, plus que mon confort en PHP.
3. Mes données sont relationnelles. Firestore me faisait faire des acrobaties pour compter des places par date.

*Le prix payé :* **le chat intégré est coupé** → bouton WhatsApp. Reverb aurait coûté 3-4 jours ; Firestore me donnait le temps réel gratuitement, Laravel non.

*Le compte net :* Laravel avec chat = ~13 j · Firebase avec chat = ~6 j · **Laravel sans chat = ~9-10 j**. Soit **+3 à 4 jours nets** sur le mois, absorbés par les tampons J10 et J15. **C'est ce troc qui fait tenir le 14 août.** La marge est mince : 2 jours de tampon pour 20 jours de travail.

*Ce qui reste chez Firebase :* Auth téléphone (0,06 $/SMS = prix du marché sénégalais, vérifié : Orange 0,04-0,08 $, Twilio 0,44 $) et FCM. Rien d'autre. **Plan Spark gratuit possible** — plus de carte exposée.

**Autres décisions :**
- Paiement **cash** en V1 — Wave en S7-S8 (ne teste pas l'hypothèse, coûte 1 semaine)
- **Un corridor**, pas Dakar entier
- Android d'abord, iOS quand un utilisateur le demandera
- S5-S6 = recrutement terrain, zéro dev

**Ce que j'ai appris :**
- `seats_total` ne se décrémente jamais : les places d'un trajet récurrent sont **par date**
- `departure_time` est un TIME, pas un timestamp. Un trajet récurrent n'a pas de date.
- Le vrai risque du projet n'est pas technique, c'est la densité sur le corridor
- Le budget infra tombe à ~10 €/mois (un VPS), fixe et prévisible

**Bloqué sur :**
- Corridor pas encore choisi ⚠️ à trancher avant le J20
- Question Wave non tranchée : API marchande directe ou agrégateur ?

**Demain :** J1 — Monorepo, VPS, Postgres+PostGIS, déploiement + ouverture du compte marchand Wave/PayDunya

---

### J0+1 — 17 juillet 2026 — La stratégie change de fond en comble

**Ce qui s'est passé :** j'ai expliqué à Claude la réalité du terrain, qu'il ne connaissait pas. Il raisonnait comme si YOBU créait un marché. **Faux : le marché existe déjà.**

**Le contexte réel :**
- Le covoiturage domicile-travail existe déjà à Dakar, autour de **points de rencontre** informels.
- Le conducteur **paie ~500 F par trajet** au groupe qui gère le point, et prend **4 clients** → **125 F par passager**.
- Ces points sont mal organisés, il y a des querelles.
- **Le gâchis :** un conducteur et un passager quittent le même quartier et font chacun 1 à 3 km pour se retrouver au point. Ils étaient à 400 m l'un de l'autre.
- J'ai été des deux côtés : conducteur et passager. C'est de là que vient l'idée.

**Ce que ça change :**
1. **Le comportement est prouvé.** L'ancienne V1 devait prouver « est-ce que deux inconnus covoiturent ». Ils le font déjà. Mauvaise hypothèse.
2. **La nouvelle hypothèse, la vraie :** le point marche *parce qu'il agrège*. YOBU parie que **la densité naturelle d'un quartier suffit sans convergence**. C'est le seul inconnu. Le taux de match > 70 % la teste.
3. **La monétisation est réglée.** La disposition à payer n'est pas une hypothèse : **125 F/passager, prix de marché observable**. La piste crédits à 50 F est 2,5× moins chère. Mon objection d'hier (« ne taxe pas le côté rare ») tombe : le côté rare paie déjà, à un tiers, pour un service médiocre.
4. **Le pitch :** *« Ton voisin va au Plateau ce matin. Tu marches 2 km pour ne pas le savoir. »* Pas « une app de covoiturage ».
5. **L'amorçage devient facile :** la liquidité est déjà réunie au point, à 6h. Inutile de recruter à froid.
6. **Le concurrent, c'est le point de rencontre.** Pas BlaBlaCar, pas Yango.

**Décisions prises :**
- **On contourne les points, on ne s'allie pas** — la mentalité rend l'alliance difficile. Mon appel. La porte reste entrouverte si ça se tend.
- **Équipe terrain à la commission** : 1 000 F par conducteur actif. 30 conducteurs ≈ 45 €. Dans le budget.
- **Pub : géociblée sur 5 km autour de la zone, et seulement après les 30 conducteurs.** La dispersion tue les marketplaces.
- **Points de rencontre nommés dans l'app : pas en V1**, mais c'est la vision long terme. Le matching PostGIS livre déjà le cœur (pas de détour).

**Repli identifié si l'hypothèse est fausse :** digitaliser le point (file d'attente, ordre de passage, fin des querelles) au lieu de le supprimer. Même app à 80 %.

**Ce que j'ai appris :**
- Le point de rencontre n'est pas un service, c'est une rustine : une solution au problème de coordination inventée sans technologie. Le prix, c'est 2 km à pied pour tout le monde.

**Design tranché : direction B — « Affirmé ».**
- Vert profond `#05301C`, coins à 22px, typo 800, **le prix écrase tout le reste**. La modernité vient de la hiérarchie, pas de la couleur.
- Neutres teintés vert, jamais gris pur.
- **Correction trouvée en écrivant les tokens :** le CTA de la maquette (blanc sur vert vif `#00B368`) était à **2,7:1** de contraste — échoue l'accessibilité, et échoue surtout au soleil dakarois. CTA passé au vert profond (14,5:1). Le vert vif reste, mais en accent seul : **jamais de texte blanc dessus**.

**Hébergement tranché : VPS, pas O2switch.**
- O2switch a PostgreSQL, mais en **9.6** (fin de vie depuis 2021) et **ils envisagent de l'arrêter**. PostGIS demande le superuser → impossible sur du mutualisé cPanel.
- Le repli **MariaDB était viable** : `ST_Distance` point→linestring + `SPATIAL INDEX` + une projection équirectangulaire centrée sur Dakar (14°N → erreur < 0,1 %, invisible sur un seuil de 1 500 m). La géographie du Sénégal nous sauvait. **Écarté** : la bascule MariaDB→PostGIS coûterait 2-3 jours plus tard, autant choisir une fois.
- Le vrai motif du refus n'est pas le spatial, c'est le **mutualisé pour une API mobile** : limites CPU en fair-use, aucun contrôle, aucun diagnostic possible.
- Vérifié aussi : **on ne peut pas faire le matching avec Google Maps.** 50 appels par recherche × 100 recherches/jour = 150 000 appels/mois = 75 à 750 $/mois, contre 5 € de VPS. **Principe retenu : on ne filtre jamais avec une API payante, on filtre en local et on affiche avec l'API.** Maps est appelé 1 fois par trajet publié, à la création. Jamais à la recherche.

**Dev local : Docker + image `postgis/postgis:16-3.4`.** Et le squelette est déployé sur le VPS **dès le J1** — si on attend le J19 pour déployer, on découvre les problèmes de déploiement au J19.

**🎯 Zone choisie : Keur Massar → Plateau.**
- **Vérifié : le BRT ne dessert pas Keur Massar.** La ligne B1 s'arrête à Guédiawaye (18,3 km, 45 min, un bus toutes les 6 min). C'est exactement pour ça que les points de rencontre existent chez moi et pas là-bas. Le CETUD décrit Keur Massar comme une zone où « la demande de mobilité est particulièrement forte ».
- **La fenêtre :** restructuration bus (14 lignes, 400 bus, **dépôt à Keur Massar**) visée **fin 2026** — ~6 mois. Une 2ᵉ ligne BRT vers Keur Massar est financée mais les études commencent à peine → plusieurs années.
- **Le retournement :** l'État qui investit à Keur Massar **confirme mon marché mieux que je ne pourrais le faire**. Slide 2 du deck : je ne vends pas un pari, une agence d'État a chiffré la demande avant moi.
- **Nouvelle question pour la phase 0 :** les gens vont-ils au Plateau *directement*, ou à Guédiawaye prendre le BRT ? Si c'est du rabattement, mon vrai produit est peut-être **Keur Massar → station BRT** — plus court, plus dense, plus facile à matcher. Et le BRT devient un allié, pas un concurrent.

**Bloqué sur :**
- Quel point de rencontre exactement ? À repérer physiquement.

**Demain :** J1 — Monorepo, PostGIS en local, squelette déployé + compte marchand Wave

---

### J0+2 — 17 juillet 2026 (suite) — Clean Architecture, calibrée

**Décision :** clean architecture côté Flutter, mais **version pragmatique 3 couches**, pas la stricte à 4.

- **3 couches par feature :** `domain/` (entité freezed + interface repository) · `data/` (impl + api dio) · `presentation/` (controller Riverpod + écrans).
- **La règle unique :** `presentation` ne connaît que l'interface `domain`, jamais `data`. Si un écran importe l'API, c'est cassé.
- **Ce qu'on NE fait pas, exprès :** pas de use case un-par-action (le controller Riverpod le fait), pas de mapper entité↔modèle (l'entité freezed EST le modèle tant qu'il n'y a qu'une source).
- **Pourquoi pas la stricte :** ~30-40 % de code en plus, en solo, sur 20 jours. La clean archi protège contre le changement ; en V1 je veux du changement rapide. On remonte en gamme le jour où le besoin est réel — jamais par principe.

Documenté dans `CLAUDE.md` (conventions app) et `docs/02-technique.md §10` (exemple complet « publier un trajet »).

> ~~⚠️ **À FAIRE : migrer l'échafaudage existant.**~~ ✅ **Fait le 18/07** — écrans déplacés vers `presentation/screens/`, client réseau vers `core/network/`, gabarits `domain/`/`data/` posés. Voir l'entrée du 18/07.

---

### J1-anticipé — 18 juillet 2026 — Setup local + migration Clean Architecture

**Fait :**
- Monorepo initialisé : `api/` (Laravel 12, Sanctum, kreait/laravel-firebase, preventLazyLoading) + `app/` (Flutter, Riverpod, go_router, dio, freezed).
- Docker + PostGIS en local (colima) : `SELECT PostGIS_Version()` → 3.4. Base `yobu_test` sur `template_postgis`, les tests tournent sur Postgres.
- `GET /api/health` → `{"ok":true,"postgis":"3.4"}`, testé.
- 16 routes go_router (écrans vides), intercepteur Bearer, API_URL par `--dart-define` (défaut `10.0.2.2:8000`). AVD `yobu_pixel` créé, l'app tourne dessus.
- Émulateur Firebase Auth opérationnel (`firebase emulators:start --project demo-yobu`, port 9099) — zéro SMS facturé en dev.
- **Migration Clean Architecture 3 couches** : écrans → `presentation/screens/`, client réseau → `core/network/`, gabarits `domain/`/`data/` posés.
- Poussé sur GitHub (`PendaDiallo/yobu`).

**Critère de fin atteint :** oui pour le local — la prod (VPS) reste le prompt 2/2 du J1.

**Coupé / reporté :**
- Projet Firebase réel + `flutterfire configure` + numéros de test console → J4 (DETTE.md).
- Déploiement VPS, backups, alerte budget → dès que le VPS est commandé.

**Ce que j'ai appris :**
- **Laravel 11 est EOL sécurité depuis mars 2026** — Composer refuse de l'installer. Passé en Laravel 12, CLAUDE.md mis à jour.
- PHP local en 8.5 : `composer config platform.php 8.3.0` fait résoudre les deps comme en prod.
- `sdkmanager`/`avdmanager` ont besoin du JDK d'Android Studio (JAVA_HOME vers le JBR).

**Bloqué sur :**
- VPS pas encore commandé → le déploiement attend.

---

### J2 — 18 juillet 2026 (anticipé) — Design system : tokens + les 9 du socle

**Fait :**
- `tokens.dart` direction B — couleurs/espacements/radius/typo du brief §2, Plus Jakarta Sans, tabular-nums partout.
- Les 9 widgets du socle, tous variants et états. TripCard : le prix écrase tout.
- Route `/debug` : galerie de tous les composants, vérifiée sur émulateur (6 captures, interactions testées).
- Contraste vérifié : jamais de blanc sur le vert vif ; jour actif du DayPicker = texte vert profond sur vif (5,3:1).

**Critère de fin atteint :** oui — `flutter analyze` sans warning, galerie visuelle validée.

**Coupé / reporté :**
- Les 4 composants de feature (PlaceField, WhatsAppButton, RouteMap, TagChip) → J7/J11/J14, comme prévu.
- La maquette 🎨 TripCard (Claude Design) n'a pas été faite en amont — à rattraper si besoin avant le J5.

**Ce que j'ai appris :**
- google_fonts télécharge la police au premier lancement → bundler les .ttf avant le build store (DETTE.md).

---

### J3 — 18 juillet 2026 (anticipé) — Schéma : 4 migrations, index GIST, modèles

**Fait :**
- Les 4 migrations conformes à `02-technique.md §3` : geography(4326) partout, `departure_time` en TIME, `days_of_week smallint[]`, tous les index dont les 2 GIST et le INCLUDE.
- Modèles + relations + cast `PgArray` (Eloquent ne parle pas smallint[] nativement).
- Factories sur le corridor réel Keur Massar → Plateau, seeder « un matin plausible » + conducteur stable pour Postman (+221770000001).
- Test qui verrouille `departure_time` en TIME (colonne ET modèle).
- Vérifié : `ST_DWithin`/`ST_Distance` renvoient des mètres sur les données seedées.

**Critère de fin atteint :** oui — `migrate:fresh --seed` passe, 5 tests verts.

**Ce que j'ai appris :**
- Le schema builder ne sait faire ni smallint[], ni INCLUDE, ni DESC dans un index → `DB::statement`, assumé dans les migrations.

**Demain :** J4 — auth téléphone de bout en bout (créer le vrai projet Firebase avant de commencer).

---

### J4 — 21 juillet 2026 — Auth téléphone de bout en bout

**Fait :**
- POST /api/auth/firebase (kreait → Sanctum) + GET /api/me, badges dérivés. 13 tests verts.
- Projet Firebase réel créé (`yobu-594f7`), `flutterfire configure`, service account sur l'API, SHA debug déclarées, région SMS SN activée. Un seul project id partout — l'émulateur aussi.
- Écrans phone_auth + otp_verify : +221 verrouillé, OTP 6 cases, renvoi 60 s, erreurs en français. Parcours complet vérifié sur émulateur jusqu'à profile_setup, et app installée sur un vrai Galaxy A55.
- Un vrai token signé yobu-594f7 vérifié par l'API contre les clés Google (e2e curl).
- Bug corrigé : même téléphone + nouvel uid Firebase → re-liaison du compte au lieu d'un 500 (test ajouté).

**Critère de fin atteint :** non sur un point — les 3 vrais numéros +221 attendent le plan Blaze (→ DETTE.md, à payer avant le J18).

**Coupé / reporté :**
- Test SMS réels : bloqué par BILLING_NOT_ENABLED. Sur vrai téléphone, les numéros de test console suffisent en attendant.

**Ce que j'ai appris :**
- **Le SMS phone-auth exige désormais le plan Blaze** (changement Firebase 2024) — l'hypothèse « Spark possible » du J0 est morte. Coût réel inchangé : ~0,06 $/SMS.
- La politique « régions SMS » d'un nouveau projet est une allowlist VIDE : rien ne part tant que le pays n'est pas activé (erreur 17006).
- Le plugin google-services auto-initialise Firebase [DEFAULT] : ne jamais ré-initialiser avec d'autres options ([core/duplicate-app]).
- kreait exige des credentials même face à l'émulateur → service account factice (clé RSA jetable), hors git.

**Demain :** J5 — profil complet avec photo.

---

### J5 — 21 juillet 2026 — Profil complet avec photo

**Fait :**
- PATCH /api/me, POST /api/me/photo (GD : 800px/JPEG 80, EXIF, remplacement), POST /api/me/fcm-token. 20 tests verts.
- Vérifié pour de vrai : PATCH avec rating=5 → ignoré. $fillable strict.
- Les 3 écrans profil (setup/view/edit), ProfileForm partagé, e2e émulateur jusqu'à la photo servie par l'API.

**Critère de fin atteint :** oui — profil + photo de bout en bout, rating inviolable.

**Bilan semaine 1 (tableau de bord) :**
- Endpoints finis : 5/17 · Composants : 9/13 · Écrans finis : 5/16
- J1 à J5 faits en 2 jours calendaires (18 et 21/07) — 3 jours d'avance.
- Reste ouvert : VPS (J1-déploiement), Blaze/SMS réels (dette, avant J18).

**Demain :** J6 — API publier un trajet + fourchette de prix. On ne prend PAS d'avance sur la S2 ce soir (règle de la fiche J5).

---

### J6 — 21 juillet 2026 — Publier un trajet (API)

**Fait :**
- POST/PATCH/DELETE /api/trips + /mine + TripPolicy. 29 tests verts.
- Routes API appelée UNE fois à la création, polyline décodée à la main → LineString PostGIS + duration_minutes.
- price-hint sans Google : ST_Distance × 1,3, 50 F/km, [400, 2000] — vérifié au curl : Keur Massar → Plateau = {840, 1200, 1680}.
- DELETE → 409 si réservations (l'historique ne s'efface pas).

**Critère de fin atteint :** oui — trajet en base, ST_AsText montre la ligne, price-hint répond sans Google.

**Coupé / reporté :**
- Sans clé Maps : repli ligne droite documenté (DETTE.md). La clé arrive avec la session facturation Google (avec Blaze), idéalement avant le J7.

**Ce que j'ai appris :**
- Deux tokens Sanctum dans un même test Feature : le guard cache le premier utilisateur → un scénario multi-acteurs = plusieurs tests.

**Demain :** J7 — l'écran publier un trajet (< 3 min chrono). Il lui faut la clé Places → session facturation Google avant si possible.

---

### J7 — 25 juillet 2026 — Publier un trajet (app)

**Fait :**
- PlaceField (design system) : suggestions + état sélectionné, source déléguée — liste de 15 lieux réels du corridor en attendant Places (DETTE facturation).
- trip_create : tout au-dessus du pli, fourchette API affichée + appliquée en un tap, avertissement hors fourchette, time picker natif.
- trip_my_list : toggle actif/inactif, suppression avec confirmation, EmptyState.
- Analytics trip_published câblé.
- e2e émulateur : publication → base → toggle → suppression, tout vérifié.

**Critère de fin atteint :** parcours complet oui ; chrono < 3 min à faire téléphone en main ; trip_published à voir en DebugView.

**Ce que j'ai appris :**
- Un PlacesRepository par interface rend la liste en dur du corridor interchangeable avec Places Autocomplete — zéro écran à retoucher.

---

### J8 — 25 juillet 2026 — LE MATCHING

**Fait :**
- TripMatchingService : la requête PostGIS du §4 telle quelle (GIST, 50 candidats par proximité), score + top 10 en PHP. POST /api/trips/search.
- Tests écrits AVANT le service, 14 cas dont les 7 exigés — verts du premier coup. 43 tests au total.
- Vérifié sur les données du corridor : un passager de Keur Massar trouve 10 conducteurs, le meilleur à 154 m. L'hypothèse est testable.

**Critère de fin atteint :** oui.

**Ce que j'ai appris :**
- La formule de score punit fort les arrivées très en avance (composante horaire négative) — voulu : elle privilégie l'arrivée PROCHE de l'heure demandée. À garder en tête en lisant les scores.
- Les places par date fonctionnent comme prévu : une résa le mardi ne touche pas le lundi.

**Demain :** J9 — écrans recherche + résultats (TripCard entre en scène).

### J9 — 25 juillet 2026 — Recherche + résultats (l'app parle enfin au matching)

**Fait :**
- Écrans `search` et `search_results` branchés sur POST /api/trips/search, via la feature `trip` en 3 couches (domain: match/place/price_hint/trip + interfaces · data: trip_api/impl/corridor_places · presentation: search_controller + écrans).
- `search_results` gère les 3 états : chargement / résultats / vide (EmptyState).
- `TripCard` affiche `seatsLeft` **reçu de l'API** — aucun calcul de places côté Flutter, la frontière tient.
- Analytics `search_performed` avec `results_count` : le taux de match est désormais mesurable.
- Vérifié au curl (après avoir corrigé une 500 d'auth — voir note du 25/07) : les trajets Keur Massar → Plateau remontent, triés par proximité. Ça marche de bout en bout, API → app.

**Critère de fin atteint :** oui — recherche fonctionnelle depuis l'app, 3 états OK, event analytics qui remonte.

**Ce que j'ai appris :**
- La 500 « Route [login] not defined » = requête API non authentifiée traitée comme du web. Durci dans bootstrap/app.php (item J18 fait en avance).
- Le piège du test curl : être déjà dans `api/` fait échouer `cd api &&` et vide le token silencieusement.

**Reste à faire :** commit du J9 (pas encore fait au moment d'écrire), cocher J9 dans PLANNING.md.

**Demain :** J10 — tampon. Rien à coder. Aller compter au point de rencontre de Keur Massar à 6h (stratégie §4).

---

### J9 — 25 juillet 2026 — Recherche + résultats (app)

**Fait :**
- Écrans search + search_results branchés sur POST /api/trips/search, 3 états (chargement, résultats, vide) vérifiés sur émulateur.
- Entité Match : tout arrive pré-calculé (seats_left par date, arrival_time, score) — aucun calcul côté Flutter, la frontière API/app tient.
- Toggle Aujourd'hui/Demain (les deux seuls jours d'un pendulaire), PlaceField réutilisé tel quel.
- Analytics search_performed{results_count} : la source du taux de match.

**Critère de fin atteint :** oui.

**Ce que j'ai appris :**
- La base de dev n'est pas un invariant : re-seed entre deux sessions = tokens app orphelins. Réflexe : re-login avant de conclure à un bug.

**Demain :** J10 — TAMPON. N'y mets rien (règle 3 du planning).

<!-- Nouvelles entrées AU-DESSUS de cette ligne, la plus récente en premier -->

---

## Tableau de bord — à mettre à jour chaque vendredi

| | Cible | Réel |
|---|---|---|
| **Jour actuel** | J20 le 14 août | J5 fait le 21/07 — 3 j d'avance |
| **Endpoints finis** | 17 | 5 (+ /health, hors liste) |
| **Composants finis** | 13 (8 au J2) | 9 |
| **Écrans finis** | 16 | 5 (phone_auth, otp_verify, profil ×3) |
| **Jours de retard** | 0 | 0 |
| **Marge restante** | J10 + J15 | intacte |
| **Conducteurs contactés** | 40 au J20 | 0 |
| **Zone choisie** | avant J20 | ✅ **Keur Massar → Plateau** |
| **Point de rencontre repéré** | avant la phase 0 | ❌ |
| **Matins passés à compter au point** | ~10 en S2-S3 | 0 |

## Les questions ouvertes

> Toute question sans réponse vit ici jusqu'à ce qu'elle soit tranchée. On ne code pas autour d'une question ouverte.

- [x] ~~Quelle zone ?~~ → **Keur Massar → Plateau** ✅ 17/07
- [ ] **Quel point de rencontre exactement ?** — à repérer physiquement, avant la phase 0
- [ ] **Plateau direct ou rabattement vers le BRT de Guédiawaye ?** — à observer en phase 0, ça peut changer le produit (`05-strategie.md §3bis`)
- [ ] **Wave : API marchande directe ou agrégateur ?** — semaine 1, par téléphone
- [ ] **Un juriste sur le « partage de frais »** — avant la phase 2 (S7)
- [ ] **La monétisation — largement débloquée le 17/07.** Les conducteurs paient déjà **125 F/passager** au point de rencontre : la disposition à payer est un fait, pas une hypothèse. Piste : crédits à 50 F/réservation (2,5× moins cher). Reste à vérifier sur le terrain (§6) : les 500 F sont-ils par trajet ou par jour ? vraiment 4 clients ? d'autres frais ? **Décision : mois 3.**
