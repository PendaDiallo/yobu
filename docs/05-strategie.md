# YOBU — Stratégie & présentation

> **Ce doc a été entièrement réécrit le 17/07** après que Penda a expliqué la réalité du terrain dakarois : le covoiturage domicile-travail **existe déjà**, organisé autour de points de rencontre informels. La version précédente raisonnait comme si YOBU créait un marché. C'est faux — il en réorganise un.

## 1. Le marché existe déjà. C'est ça, la bonne nouvelle.

**Comment ça marche aujourd'hui, sans app :**

Dans chaque zone, il y a des **points de rencontre** : des endroits connus où les conducteurs se garent le matin pour prendre des passagers. Le conducteur **paie ~500 F par trajet** à un groupe qui gère le point, et repart avec **4 clients**. Ces points sont tenus par des gens, parfois mal organisés, et il y a des querelles.

**Ce que ça t'apprend, et qui vaut de l'or :**

| Ce que la plupart des startups doivent prouver | Toi |
|---|---|
| Est-ce que les gens accepteront de monter avec un inconnu ? | **Déjà prouvé.** Ils le font tous les matins. |
| Y a-t-il une demande ? | **Déjà prouvée.** Les points sont pleins à 6h. |
| Les conducteurs paieront-ils pour accéder aux passagers ? | **Déjà prouvé. 500 F par trajet, en cash.** |
| Où sont mes utilisateurs ? | **Tu le sais physiquement.** Ils sont au point, à 6h. |

La disposition à payer est la chose qu'on ne sait jamais avant de lancer. **Toi, tu peux aller l'observer demain matin.**

## 2. Le gâchis que YOBU supprime

> **Un conducteur et un passager quittent le même quartier. Chacun fait 1 à 3 km — souvent dans la mauvaise direction — pour se retrouver à un point tenu par un tiers. Ils étaient à 400 m l'un de l'autre.**
>
> Rien ne les met en relation. C'est tout.

**Le point de rencontre n'est pas un service. C'est une rustine.** C'est une solution au problème de coordination, inventée sans technologie : à défaut de savoir qui va où, on force tout le monde à converger au même endroit. Le prix de cette convergence, c'est 1 à 3 km à pied, tous les matins, payés par tout le monde.

**YOBU propose de coordonner numériquement et de supprimer la marche.**

C'est ça, ton pitch. Pas « une app de covoiturage » :

> **« Ton voisin va au Plateau ce matin. Tu marches 2 km pour ne pas le savoir. »**

Et c'est déjà dans le produit : `ST_DWithin(route, passager, 1500 m)` veut dire exactement *« trouve les gens qui sont sur mon chemin, sans que je fasse un détour »*. Les points de rencontre nommés (choisir un lieu-dit plutôt qu'une adresse) sont un raffinement d'interface pour plus tard — le cœur est là dès la V1.

## 3. 🎯 Ce que la V1 doit prouver — la vraie hypothèse

Ce n'est **pas** « est-ce que les gens covoiturent ». Ils covoiturent.

> **Le point de rencontre fonctionne *parce qu'il agrège*.** Il crée de la densité par la force : tout le monde converge, donc tout le monde trouve.
>
> **YOBU parie que la densité naturelle d'un quartier suffit, sans convergence.** C'est un vrai inconnu, et c'est le seul.

**La question, formulée proprement :**

> **Sur une zone donnée, un passager qui cherche trouve-t-il un conducteur compatible ≥ 70 % du temps — sans que personne ne se déplace vers un point commun ?**

Si oui → tu supprimes 2 km de marche quotidienne à des milliers de gens, et tu es 2,5× moins cher que le point. Tu as un business.

Si non → **la densité naturelle ne suffit pas, et le point de rencontre avait raison.** Ce n'est pas un échec du produit, c'est une information majeure. Le repli existe et il est bon : **digitaliser le point plutôt que le supprimer** — la file d'attente, l'ordre de passage, la fin des querelles, l'appariement sur place. Un autre produit, sur le même marché, avec la même app à 80 %. Garde cette porte ouverte.

## 3bis. 🎯 La zone : **Keur Massar → Plateau** (choisie le 17/07)

### Pourquoi c'est le bon choix — vérifié, pas supposé

> **Le BRT ne dessert pas Keur Massar.** La ligne B1 va de **Guédiawaye à Petersen** : 18,3 km, 45 min, un bus toutes les 6 min, 6h-21h. C'est un excellent service — et il s'arrête avant chez toi.

C'est exactement pour ça que les points de rencontre existent à Keur Massar et pas à Guédiawaye. Le CETUD décrit lui-même Keur Massar comme une zone où **« la demande de mobilité est particulièrement forte »**.

**Tu as choisi l'endroit où la douleur est maximale et l'alternative absente.** C'est la définition d'un marché.

### La fenêtre — deux échéances à surveiller

| Échéance | Quoi | Horizon |
|---|---|---|
| **Fin 2026** | Restructuration du réseau de bus : **14 lignes, ~400 bus, un dépôt-atelier à Keur Massar** | **~6 mois** — ça peut bouger ton terrain pendant que tu construis |
| Plus tard | **2ᵉ ligne BRT vers Keur Massar** — financement bouclé, termes de référence finalisés (juillet 2026), mais les études commencent à peine | plusieurs années (la ligne 1 en a pris ~5) |

**Ta fenêtre est large, mais pas infinie.**

### Le retournement — c'est une slide de deck

> **L'État met un dépôt de bus et une ligne BRT à Keur Massar. C'est la meilleure validation externe de ton marché que tu puisses avoir.**

Tu n'as pas à convaincre un investisseur que la demande existe : **le CETUD l'a chiffrée avant toi**. Ça va directement dans la slide 2 (§9).

### ❓ La question à trancher en phase 0

> **Les gens de Keur Massar vont-ils au Plateau *directement*, ou vont-ils à Guédiawaye prendre le BRT ?**

Si beaucoup font du **rabattement vers la station BRT**, alors ton vrai produit n'est peut-être pas Keur Massar → Plateau (30 km), mais **Keur Massar → station BRT de Guédiawaye** : bien plus court, bien plus dense, **bien plus facile à matcher**. Un produit plus petit, et probablement plus facile à faire décoller.

**Tu le sauras en te postant au point à 6h et en écoutant où les gens descendent.** Ajoute-le à ta liste de comptage (§4).

## 4. L'amorçage — la liquidité est déjà là, va la chercher

C'est ce qui change le plus par rapport à l'ancienne version. Je te disais de recruter 30 conducteurs un par un, à froid. **Inutile : ils sont déjà réunis, au même endroit, à la même heure, tous les matins.**

**Phase 0 — pendant les semaines 2-3, 1h/jour : va observer**
Tu te postes au point de rencontre de **Keur Massar**. À 6h. Tu ne vends rien, tu regardes et tu comptes :
- Combien de conducteurs ? Combien de passagers ? Combien repartent bredouilles ?
- D'où viennent-ils ? **Combien de km ont-ils fait pour venir jusqu'ici ?** ← *c'est la mesure de ton marché*
- Le prix exact payé au point. Le prix exact payé par le passager.
- Les 500 F sont-ils par trajet ou par jour ? Payés par tous, ou seulement les réguliers ?
- Vraiment 4 clients par conducteur, ou ça varie ?
- **Où vont-ils vraiment : Plateau direct, ou station BRT de Guédiawaye ?** ← *§3bis, ça peut changer ton produit*
- Qui gère ? Comment ? Quelles querelles ?

**Objectif au J20 : tu connais ton marché par les chiffres, pas par intuition.** Et 40 numéros de conducteurs.

**Phase 1 — S5-S6 : les 30 conducteurs, au point**
Tu ne codes pas (`04-roadmap.md §Après`). Tu es au point à 6h, tous les matins, avec une équipe.

> **L'équipe se paie à la commission, jamais au fixe.**
> ```
> 1 000 F par conducteur qui publie un trajet ET reçoit une réservation
> 30 conducteurs = 30 000 F ≈ 45 €
> ```
> Tu n'avances rien, tu ne paies que ce qui marche, et le recruteur a intérêt à amener des conducteurs *actifs* plutôt que des installations mortes. C'est dans ton budget.

L'argument au conducteur tient en une phrase : **« Tu paies 500 F au point pour 4 clients. Avec YOBU tu les as sans venir jusqu'ici, et ça te coûte moins. »**

*(Et le point de rencontre de Keur Massar est ton lieu de recrutement idéal : tes 20 conducteurs et 80 passagers y sont déjà réunis, physiquement, en train d'attendre. Tu n'as personne à chercher.)*

**Phase 2 — S7-S8 : les passagers**
Aux points de ramassage de la zone, à 6h, en physique. Le passager qui installe trouve immédiatement 4 conducteurs → il reste. Les matins au terrain, les après-midi sur la V1.1.
**Objectif : 100 passagers, 20 trajets/jour.**

**Phase 3 — mois 3+ : la zone suivante.** Pas avant que la première tourne sans toi.

## 5. La pub — ciblée, et jamais avant la liquidité

**Le problème n'est pas la pub. C'est la dispersion.**

Une campagne « YOBU est disponible à Dakar ! » te donne 500 installations réparties sur 40 quartiers. Personne ne trouve personne. Tu as brûlé ta première impression auprès de 500 personnes qui ne réinstalleront jamais. **Une app de mise en relation ne pardonne pas une recherche vide.**

**La version qui marche :**
- **Rayon de 5 km autour de ta zone.** Facebook le fait. Keur Massar, et rien d'autre.
- **Seulement après tes 30 conducteurs.** Jamais avant. Chaque installation doit trouver quelqu'un le jour même.
- Le message parle du détour, pas du covoiturage : *« Ton voisin va au Plateau. »*

Pub géociblée après liquidité : oui. Pub « Dakar » avant : c'est ce qui tue les marketplaces.

## 6. Prix & modèle éco

**Le prix du trajet.** Le conducteur fixe. L'app suggère une fourchette (~50 F/km, bornée [400, 2 000] — endpoint au J6, écran au J7, cf `01-produit.md §3bis`). Sur 20 km : de l'ordre de **1 000 F** (fourchette 700-1 400). Le repère, c'est le car rapide, pas le taxi.

**La monétisation — la question est réglée par le terrain.**

> Le conducteur paie **déjà 500 F par trajet** pour 4 clients, soit **125 F par passager**.

Donc :
- **La disposition à payer est prouvée.** Ce n'est pas une hypothèse.
- **Le prix de marché est connu : 125 F par passager.**
- **Mon objection « ne taxe jamais le côté rare » tombe.** Le côté rare paie déjà, à un tiers, pour un service mal organisé.

**Le modèle qui en découle :**
```
1 crédit = 1 réservation acceptée
Pack 100 crédits = 5 000 F  →  50 F la réservation
Soit 2,5× moins cher que les 125 F qu'il paie aujourd'hui
Les 20 premières réservations gratuites → il a gagné 20 000 F avant de payer
Recharge Wave ponctuelle (pas d'abonnement : le mobile money ne prélève pas)
Au début : à la main, toi, avec ton téléphone
```

*Ce qui reste à vérifier sur le terrain, en phase 0 :*
- [ ] Les 500 F sont-ils par trajet ou par jour ? Payés par tous les conducteurs ou seulement les réguliers ?
- [ ] Est-ce vraiment 4 clients, ou ça varie ?
- [ ] Y a-t-il d'autres frais invisibles ?

*Ce qui reste en débat :*
- La friction du crédit au pire moment (il veut accepter, plus de crédits, il abandonne) → à mitiger : solde négatif toléré, alerte à 10 crédits.
- **Décision : mois 3.** Pas avant. Tu as zéro utilisateur.

**L'offre entreprise reste l'horizon.** Une entreprise du Plateau paie un forfait pour ses employés — elle y gagne du parking et de la ponctualité. C'est probablement là qu'est l'argent réel, mais ça se vend avec des chiffres d'usage. Pas un axe du mois 1.

## 7. Les métriques

| Métrique | Ce qu'elle dit | Seuil |
|---|---|---|
| **Taux de match** | % de recherches qui remontent ≥ 1 conducteur | **> 70 %** ← *c'est l'hypothèse du §3* |
| **Km économisés** | distance que l'utilisateur aurait marchée jusqu'au point | *ta valeur, en une mesure* |
| **Taux d'acceptation** | % de demandes acceptées | > 60 % |
| **Rétention S2** | % de passagers qui refont un trajet la semaine suivante | > 40 % |
| **Fréquence de renouvellement** | à quelle fréquence un conducteur cherche un *nouveau* passager | décide de la solidité du modèle |

**Le taux de match reste la seule qui compte.** Sous 70 %, tu n'as pas un problème de produit : tu as la réponse à l'hypothèse du §3, et elle est non. C'est alors la zone qu'il faut densifier — ou le repli « digitaliser le point ».

## 8. Les risques

**Le point de rencontre défendra son territoire.** C'est ton vrai concurrent — pas BlaBlaCar, pas Yango. Un système informel, cash, tenu par des gens dont YOBU supprime le revenu. Partout dans le monde, les organisations informelles de transport défendent leur territoire, et pas toujours poliment.

Penda a tranché : **on contourne, on ne s'allie pas** — la mentalité rend l'alliance difficile. C'est son appel, il connaît le terrain. Mais deux précautions :
- **Reste discret pendant les phases 0 et 1.** Tu n'as pas besoin d'être visible pour recruter 30 conducteurs.
- **La porte de l'alliance n'est pas fermée définitivement.** Si ça se tend, « on digitalise votre point, vous gardez vos 500 F » est une conversation qui existe.

**Sécurité / confiance.** Une mauvaise histoire dans un groupe WhatsApp et c'est fini. Parades V1 : vérification téléphone (l'auth *est* un OTP), notation visible, vraie photo. V1.1 : pièce d'identité. *(Le partage de trajet à un proche est dans `IDEES.md`, pas dans le scope — ne le compte pas comme acquis.)*
La parade structurelle : c'est **récurrent et local**. Les gens du même quartier ont une réputation à tenir et se recroisent tous les matins. Aucun concurrent ne peut te copier ça.

**Réglementaire.** Le transport de personnes contre rémunération est encadré. Ta position : **partage de frais**, pas transport commercial — le conducteur ne fait pas de bénéfice, il partage le coût d'un trajet qu'il faisait de toute façon. Elle tient **tant que le prix reste sous le coût réel** : d'où la fourchette suggérée. **Fais valider par un juriste avant la phase 2.** À noter : le système actuel opère déjà dans cette zone grise, ce qui te donne un précédent — et un risque, si YOBU le rend visible.

**Concurrence tech.** Yango/Heetch peuvent coder du covoiturage en un mois. Ta défense n'est pas technique : c'est **la densité sur ta zone**. Quand 200 personnes de Keur Massar se connaissent via YOBU, un entrant repart de zéro.

**Le transport public arrive à Keur Massar.** Le vrai concurrent à moyen terme, ce n'est pas une app — c'est l'État. **14 lignes de bus et un dépôt à Keur Massar visés fin 2026** (~6 mois), une ligne BRT plus tard. Ça réduira la douleur qui fait vivre ton produit.
Deux nuances : un BRT reste une marche jusqu'à la station + un bus bondé — YOBU est assis, quasi porte-à-porte, c'est un autre produit. Et surtout, si le rabattement vers la station BRT devient le vrai usage (§3bis), **le BRT devient ton allié, pas ton concurrent** : tu deviens le premier kilomètre. À surveiller en phase 0.

## 9. La présentation (mois 3, pas avant)

Un deck sans chiffres d'usage est une dissertation. Voici la structure, pour savoir quoi collecter.

1. **Le problème** — pas un embouteillage générique. **Une photo du point de rencontre de Keur Massar à 6h30, et la carte des 2 km que chacun a marchés pour y arriver.** C'est ta slide, personne d'autre ne l'a.
2. **Le marché existe déjà, et l'État le confirme** — les points, les 500 F, les volumes comptés en phase 0. **Plus : le CETUD investit un dépôt de bus et une future ligne BRT à Keur Massar, parce qu'il a mesuré que la demande y est « particulièrement forte ».** Tu n'as pas à prouver que le marché existe — une agence d'État l'a chiffré avant toi. *Tu ne vends pas un pari, tu vends une réorganisation.*
3. **L'insight** — même quartier, 2 km de détour, rien qui les relie.
4. **Le produit** — 3 captures. Pas 12.
5. **La traction** — taux de match, rétention, km économisés. **C'est la slide qui décide.**
6. **Le modèle** — 125 F payés aujourd'hui, 50 F avec YOBU. Le chiffre parle seul.
7. **La stratégie zone** — une zone prouvée, puis N zones.
8. **Toi** — solo, produit sorti en 4 semaines, **et tu as été des deux côtés : conducteur et passager**. C'est un argument de force.
9. **La demande** — combien, pour quoi, sur combien de temps.

---

## Ce qu'on décide maintenant

- [x] **ZONE = Keur Massar → Plateau** ✅ *(17/07 — §3bis)*
- [ ] **Quel point de rencontre exactement ?** — le repérer physiquement
- [ ] Compte marchand Wave Business + PayDunya lancés (J1)
- [ ] Question tranchée : Wave a-t-il une API marchande directe ?
- [ ] **Phase 0 : aller compter au point de rencontre** (S2-S3, 1h/jour) — c'est le truc le plus rentable de tout ce doc
- [ ] 40 numéros de conducteurs (au J20)
- [ ] Juriste consulté sur le partage de frais (avant la phase 2)

---

**Sources sur le corridor Keur Massar :**
- [Sunu BRT — la ligne B1 Dakar-Guédiawaye](https://www.sunubrt.sn/) · [BRT de Dakar — Wikipédia](https://fr.wikipedia.org/wiki/BRT_de_Dakar)
- [Stratégie de mobilité urbaine : deuxième ligne de BRT vers Keur Massar — allAfrica, juillet 2026](https://fr.allafrica.com/stories/202607160526.html)
- [Restructuration du réseau de transport en commun à Dakar : l'horizon 2026 — EnQuête+](https://www.enqueteplus.com/content/restructuration-du-r%C3%A9seau-de-transport-en-commun-dakar-%C2%A0lhorizon-2026-pour-la-premi%C3%A8re-phase)
- [CETUD — caractéristiques techniques du projet BRT](https://cetud.sn/les-caracteristiques-techniques-du-projet-brt/)
