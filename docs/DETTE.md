# Dette technique assumée

> Règle : quand tu contournes un problème pour tenir le planning, tu l'écris **ici** et tu avances.
> Une dette écrite est une décision. Une dette non écrite est un piège.
> Claude Code doit ajouter une ligne ici chaque fois qu'il laisse quelque chose d'imparfait.

| Date | Quoi | Pourquoi on l'assume | Quand on paie |
|---|---|---|---|
| 16/07 | **Pas de chat intégré → WhatsApp** | Reverb = 3-4 j. **C'est ce troc qui finance la bascule Laravel.** Les gens sont déjà sur WhatsApp. | seulement s'ils le réclament |
| 16/07 | iOS non supporté | 99 $/an + certificats, marché sur Android | quand un user le demande |
| 16/07 | Paiement en cash | Ne teste pas l'hypothèse, coûte 1 semaine | V1.1 (S7-S8) |
| 16/07 | Pas de vérif pièce d'identité | Vérif téléphone suffit pour 30 personnes qu'on recrute à la main | V1.1 (S7-S8) |
| 16/07 | Pas de suivi GPS temps réel | Le trajet est connu d'avance, personne ne le demande encore | V2 |
| 16/07 | Réservations non renouvelées auto | Le *trajet* est récurrent (c'est ça le produit), la *réservation* est ponctuelle. Le renouvellement est une commodité. | V1.1 |
| 16/07 | Badge `punctual` non implémenté | Demande une mesure de ponctualité qu'on n'a pas (pas de GPS) | avec le GPS, ou jamais |
| 16/07 | Tests uniquement sur le matching + les Policies | Les deux seuls endroits où un bug est invisible à l'œil et grave | jamais, probablement |
| 16/07 | Queue en driver `database`, pas Redis | Une dépendance de moins sur le VPS. Suffit largement à ce volume. | quand la queue traînera |
| 17/07 | VPS à 5 €/mois au lieu de l'O2switch déjà payé | PostGIS impossible sur mutualisé (superuser), PostgreSQL 9.6 en fin de vie et en voie de suppression chez eux. Le repli MariaDB marchait, mais migrer plus tard coûte 2-3 j. | jamais — c'est le bon choix |
| 18/07 | PHP local en 8.5, prod visée en 8.3 | Homebrew n'a que `php` (8.5) d'installé. Composer est épinglé `platform.php=8.3.0` : les dépendances résolvent comme en prod, seul le runtime diffère. | au J1-déploiement, vérifier que le VPS est bien en 8.3 |
| 18/07 | Pas de projet Firebase réel — émulateur seul (`demo-yobu`) | Créer le projet demande la console (login). L'émulateur Auth suffit pour développer sans SMS facturé. | J4 : créer le projet, `flutterfire configure`, déclarer les numéros de test dans la console |
| 18/07 | Cleartext HTTP autorisé en debug Android | L'API locale est en http (10.0.2.2). Limité au manifest debug — release reste HTTPS-only. | jamais — c'est le bon périmètre |
| 18/07 | Plus Jakarta Sans téléchargée au premier lancement (google_fonts) | Suffit en dev. En release, un premier lancement hors ligne retomberait sur la police système. | J19 : bundler les .ttf en assets avant le build store |
