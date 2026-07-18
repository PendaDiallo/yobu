# YOBU — Produit

## 1. La niche — et le marché qui existe déjà

**Le covoiturage domicile-travail existe déjà à Dakar.** Il s'organise autour de **points de rencontre** : des endroits connus où les conducteurs se garent le matin. Le conducteur paie **~500 F par trajet** à un groupe qui gère le point, et repart avec **4 clients**.

**YOBU ne crée pas un comportement. Il supprime un gâchis :**

> Un conducteur et un passager quittent le **même quartier**. Chacun fait **1 à 3 km**, souvent dans la mauvaise direction, pour se retrouver au point. **Ils étaient à 400 m l'un de l'autre.** Rien ne les met en relation.

**Conducteur** : un particulier qui fait banlieue → centre le matin, à heure à peu près fixe, du lundi au vendredi. 2 à 4 places vides. Il ne cherche pas un métier — il amortit son essence. **Et il paie déjà pour accéder aux passagers.**

**Passager** : une personne non-véhiculée qui fait le même trajet. Elle veut arriver à l'heure, être assise, ne pas se ruiner — **et ne pas marcher 2 km à 6h du matin.**

**Ce qui rend cette niche gagnable :**
- Le trajet est **prévisible** → on pré-matche, pas besoin de temps réel.
- La relation est **répétée** → la confiance se construit après 3 trajets.
- **Le marché est déjà là, et tu sais physiquement où il est** : au point de rencontre, à 6h.

**Le corollaire stratégique :** on ne lance pas « à Dakar ». On lance **sur une zone**, autour d'un point de rencontre existant, où la liquidité est déjà réunie. Voir `05-strategie.md §4`.

## 2. Scope V1 — GELÉ

Tu as coché socle + Wave/OM + récurrence + notation. Voici mon avis de co-fondateur, et il compte :

> **Les quatre en un mois, seul, c'est faux.** Le paiement intégré, c'est 5 à 10 jours ouvrables rien que pour l'activation du compte marchand, plus l'intégration, plus les cas d'erreur (paiement à moitié passé, remboursement, litige). C'est la brique la moins différenciante et la plus chronophage.
>
> **Et surtout : elle ne teste rien.** Ce que tu dois valider en V1, c'est « est-ce que deux inconnus qui font le même trajet vont accepter de le faire ensemble ? ». Si la réponse est oui, le paiement cash ne t'en empêche pas — les gens à Dakar se paient en cash tous les jours. Si la réponse est non, tu auras brûlé une semaine sur une API pour rien.

**Donc :**

| Brique | V1 (4 semaines) | Après |
|---|---|---|
| Auth téléphone (OTP) | ✅ | |
| Profil + photo + vérif téléphone | ✅ | |
| Publier un trajet **récurrent** (jours + heure + itinéraire) | ✅ | |
| **Fourchette de prix suggérée** à la publication | ✅ | |
| Rechercher / matcher | ✅ | |
| Demander une place / accepter | ✅ | |
| **Contact via deep link WhatsApp** | ✅ | |
| ~~Chat 1-1 intégré~~ | ❌ | V1.1 si demandé |
| Notation post-trajet + badges | ✅ | |
| Notifications push | ✅ | |
| **Prix affiché, paiement cash en main propre** | ✅ | |
| **Paiement Wave/OM intégré** | ❌ | V1.1, semaine 7-8 |
| Suivi GPS temps réel | ❌ | V2 |
| Vérification pièce d'identité | ❌ | V1.1 |
| Parrainage, entreprises, abonnement | ❌ | V2 |

**En parallèle, dès la semaine 1** : tu ouvres le compte marchand Wave Business et/ou PayDunya. L'activation tourne en fond pendant que tu codes. **Semaine 7, tu branches** (S5-S6 = recrutement terrain, aucun dev — cf `05-strategie.md §3`). Ça ne coûte rien de lancer la démarche maintenant, et ton compte sera actif depuis longtemps.

### Et le chat est coupé aussi

Pas par manque de temps : **c'est lui qui finance la bascule vers Laravel.**

Un chat temps réel sur une API Laravel demande Reverb, des WebSockets, et une infra de plus à maintenir — 3 à 4 jours. Sur Firestore, il était quasi gratuit. En changeant de stack, on a perdu ce cadeau.

**Le remplacement : un bouton « Écrire sur WhatsApp »** qui ouvre `wa.me/221XXXXXXXXX`. Tes utilisateurs y sont déjà toute la journée. Ils n'attendaient pas une messagerie de plus.

C'était déjà le premier sacrifice prévu de la roadmap. Il devient structurel — et c'est ce troc qui fait tenir la date du 14 août malgré le changement de stack.

**Total : 16 écrans au lieu de 17.**

## 3. Les écrans — liste exhaustive

Aucun écran hors de cette liste en V1. **16 écrans.**

**Onboarding (4)**
1. `splash` — logo, check auth
2. `welcome` — 3 slides : ton trajet, tous les matins, avec des gens vérifiés
3. `phone_auth` — saisie numéro (+221)
4. `otp_verify` — code 6 chiffres

**Profil (3)**
5. `profile_setup` — prénom, nom, photo, « je suis conducteur / passager / les deux »
6. `profile_view` — ma fiche : note, nb de trajets, badges
7. `profile_edit`

**Trajet — conducteur (3)**
8. `trip_create` — départ (Places), arrivée (Places), heure, jours de la semaine, nb de places, prix/place **avec fourchette suggérée** (voir ci-dessous)
9. `trip_my_list` — mes trajets récurrents, activer/désactiver
10. `trip_requests` — demandes reçues, accepter/refuser

**Trajet — passager (3)**
11. `search` — mon départ, mon arrivée, mon horaire → lance le matching
12. `search_results` — liste des conducteurs compatibles, triée par score
13. `trip_detail` — fiche conducteur + itinéraire + prix → « Demander une place »

**Commun (3)**
14. `home` — dashboard : mon prochain trajet, actions rapides
15. `bookings` — mes réservations à venir / passées
16. `rating` — noter après le trajet (1-5 + tags rapides)

> Le contact se fait par un **bouton WhatsApp** sur `trip_detail`, `bookings` et `trip_requests` — pas par un écran. Il n'apparaît qu'une fois la réservation acceptée.

## 3bis. La fourchette de prix — ce n'est pas du confort

À la saisie du prix dans `trip_create`, l'app affiche une fourchette calculée sur la distance : **environ 50 F/km, borné à [400 F, 2 000 F]**. Le conducteur reste libre, mais sortir de la fourchette affiche un avertissement.

**Pourquoi c'est dans le scope gelé alors que ça a l'air secondaire :** c'est une **parade réglementaire**, pas une aide à la saisie. Ta position juridique est le *partage de frais* — le conducteur ne fait pas de bénéfice. Cette position tient tant que les prix restent sous le coût réel du trajet. Un conducteur qui affiche 5 000 F te fait basculer dans le transport commercial, avec toute la charge réglementaire qui va avec. La fourchette est ce qui garde tes utilisateurs — et donc toi — du bon côté de la ligne. Voir `05-strategie.md §6`.

Coût de développement : une demi-journée, incluse dans le J6.

## 4. Les deux parcours qui comptent

**Conducteur (une fois, puis jamais)**
```
welcome → phone_auth → otp → profile_setup (conducteur)
→ trip_create : Keur Massar → Plateau, 6h45, lun-ven, 3 places, 1000 F
→ [attend] → notif « Awa demande une place mardi »
→ trip_requests → accepte → bouton WhatsApp si besoin
→ [le mardi] notif rappel 6h15 → trajet → rating
```
👉 **Le test :** de l'ouverture à « trajet publié », **moins de 3 minutes**. Si ça prend plus, la V1 est ratée.

**Passager (récurrent)**
```
welcome → phone_auth → otp → profile_setup (passager)
→ search : Keur Massar → Plateau, arriver avant 8h
→ search_results : 4 conducteurs → trip_detail → « Demander »
→ notif « Moussa a accepté » → bouton WhatsApp si besoin
→ [le matin] notif rappel → trajet → rating
```
👉 **Le test :** de l'ouverture à « demande envoyée », **moins de 2 minutes**.

## 5. Ce que la V1 doit prouver

**Pas** « est-ce que les gens covoiturent ». Ils covoiturent déjà, tous les matins, en payant.

> **Le point de rencontre marche *parce qu'il agrège* :** il crée de la densité par la force. Tout le monde converge, donc tout le monde trouve. Le prix, c'est 1 à 3 km à pied.
>
> **YOBU parie que la densité naturelle d'un quartier suffit, sans convergence.** C'est le seul vrai inconnu du projet.

**L'hypothèse, formulée proprement :**

> **Sur une zone donnée, un passager qui cherche trouve-t-il un conducteur compatible ≥ 70 % du temps — sans que personne ne se déplace vers un point commun ?**

Si oui → tu supprimes 2 km de marche quotidienne à des milliers de gens, à 2,5× moins cher que le point. Tout le reste (paiement, GPS, entreprises) se construit dessus.

Si non → la densité naturelle ne suffit pas, et le point de rencontre avait raison. **Ce n'est pas un échec, c'est une information majeure**, et le repli est bon : digitaliser le point plutôt que le supprimer. Voir `05-strategie.md §3`.

**C'est cette hypothèse que le matching `ST_DWithin(route, passager, 1500 m)` teste.** Rien d'autre dans l'app ne la teste. C'est pour ça que le J8 ne se coupe jamais.
