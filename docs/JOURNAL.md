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

<!-- Nouvelles entrées AU-DESSUS de cette ligne, la plus récente en premier -->

---

## Tableau de bord — à mettre à jour chaque vendredi

| | Cible | Réel |
|---|---|---|
| **Jour actuel** | J20 le 14 août | J3 fait le 18/07 — en avance |
| **Endpoints finis** | 17 | 0 (+ /health, hors liste) |
| **Composants finis** | 13 (8 au J2) | 9 |
| **Écrans finis** | 16 | 0 |
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
