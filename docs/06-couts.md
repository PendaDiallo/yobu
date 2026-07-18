# YOBU — Ce que ça coûte

> Tarifs relevés en juillet 2026. **Vérifie avant de t'engager** — ces prix bougent, et une partie de mes sources sont des blogs, pas les éditeurs.

## La réponse courte

| Phase | Coût mensuel |
|---|---|
| **V1, beta 10 personnes** (S1-S4) | **~10 €** — le VPS, et c'est tout |
| **Zone amorcée, 130 utilisateurs** (S7-S8) | **~18 €** le premier mois, puis ~10 € |
| **1 000 utilisateurs** | **~85 €** le premier mois, puis ~12 €/mois |

Deux postes seulement : **le VPS** (fixe) et **les SMS** (par inscription).

## Le VPS — ton seul coût récurrent

- **2 vCPU / 4 Go : 5 à 10 €/mois** (Hetzner, DigitalOcean, OVH). Localisé à Paris ou Francfort : ~50 ms depuis Dakar, imperceptible pour du REST.
- Ça tient **très** large. Postgres + Laravel pour 1 000 utilisateurs et 100 recherches/jour, c'est une machine qui s'ennuie. Tu ne toucheras pas à ce poste avant plusieurs milliers d'utilisateurs.
- **Laravel Forge : +12 $/mois** si tu veux zéro friction de déploiement. Optionnel — tu sais faire à la main.

**C'est le gain caché de la bascule :** un coût fixe, prévisible, plafonné. Pas de facturation à l'opération, donc **pas de scénario où un bug te coûte 4 chiffres en une nuit**. Sur Firestore, une boucle de Cloud Function pouvait faire ça. Ici, un bug fait tomber ton VPS — c'est gênant, ce n'est pas ruineux.

## Les SMS — le seul coût variable

L'authentification Firebase par téléphone est facturée **à chaque code envoyé**.

- **~0,06 $ par vérification au Sénégal** (les US/Canada/Inde sont à 0,01 $ — pas nous)
- **Les échecs d'envoi sont facturés aussi**
- 10 SMS/jour gratuits **uniquement avec les numéros de test** — pour le dev, pas pour de vrais utilisateurs

| | SMS | Coût |
|---|---|---|
| Beta 10 personnes | ~15 (avec les ratés) | **~1 $** |
| 130 utilisateurs | ~180 | **~11 $** |
| 1 000 utilisateurs | ~1 300 | **~78 $** |

C'est un coût **par inscription**, pas récurrent : un utilisateur qui reste ne recoûte rien.

**Et Firebase est au prix du marché** — vérifié : Orange SMS API Sénégal est à 0,04–0,08 $, Twilio à **0,44 $**. Il n'y a rien à gagner à changer. Garde Firebase Auth.

**Ce que ça change concrètement :** développe avec les numéros de test de la console. Garde les vrais SMS pour les vrais tests (J4, puis J20).

## Google Maps — compte séparé, mais gratuit à ton échelle

- Un **crédit mensuel gratuit** couvre largement ton usage (ordre de grandeur : 200 $/mois, mais le modèle a changé récemment — **vérifie**).
- **Places Autocomplete** : les sessions sont gratuites **avec les session tokens**. Sans eux, tu paies chaque frappe au clavier. C'est dans le plan (J7), ne l'oublie pas.
- **Routes API** : 1 appel par trajet publié. 30 trajets = 30 appels. Négligeable. Et **jamais à la recherche** — la route est en base.
- ⚠️ **Routes API, pas Directions API** — cette dernière est passée en *legacy*.

## Firebase — quasi gratuit maintenant

Tu n'utilises plus que deux choses :
- **Auth** → les SMS ci-dessus
- **Cloud Messaging** (push) → **gratuit, illimité**
- **Analytics / Crashlytics** → **gratuit, illimité**

Plus de Firestore, plus de Cloud Functions, plus de Storage. **Tu peux rester sur le plan Spark (gratuit)** — le plan Blaze n'était obligatoire que pour les Cloud Functions. Ta carte n'est plus exposée.

## Le budget honnête du projet

| Poste | Coût |
|---|---|
| VPS, 4 semaines de dev | ~10 € |
| SMS pendant le dev | ~1 $ (numéros de test) |
| Google Maps, 4 semaines | 0 € |
| **Compte Google Play Developer** | **25 $, une fois, à vie** |
| Compte Apple Developer | 99 $/an — **pas maintenant** |
| VPS + SMS, 2 premiers mois en prod | ~35 € |
| **Équipe terrain** (1 000 F × 30 conducteurs actifs, à la commission) | **~45 €** |
| **Total pour sortir et amorcer** | **~120 €** |

Ton vrai coût n'est pas l'infrastructure. C'est **ton mois**.

## Les protections, quand même

Le risque de facture folle a quasiment disparu avec Postgres. Il reste deux choses, à faire au J1 :

1. **Une alerte de budget à 10 $** sur Google Cloud (pour Maps + les SMS Firebase). 2 minutes.
2. **Les backups Postgres quotidiens**, automatiques. Ce n'est pas un coût, c'est ton produit. Et **restaure-en un pour de vrai au J18** — un backup jamais testé n'est pas un backup.

---

**Sources :**
- [Firebase Pricing — Google](https://firebase.google.com/pricing) *(l'officielle, celle qui fait foi)*
- [Firebase Phone Number Verification pricing](https://firebase.google.com/docs/phone-number-verification/pricing)
- [Google Maps Platform core services pricing](https://developers.google.com/maps/billing-and-pricing/pricing)
- [Autocomplete (New) and session pricing — Places API](https://developers.google.com/maps/documentation/places/web-service/session-pricing)
- [SMS Senegal (2.0) API — Orange Developer](https://developer.orange.com/apis/sms-sn/pricing)
- [Tarification SMS au Sénégal — Twilio](https://www.twilio.com/en-us/sms/pricing/sn)
- [Senegal SMS Pricing Guide — Sent.dm](https://www.sent.dm/resources/senegal-sms-pricing)
