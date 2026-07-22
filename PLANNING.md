# PLANNING — 20 jours

**Départ : lundi 20 juillet 2026 · Beta : vendredi 14 août 2026**

> Chaque matin : tu ouvres le fichier du jour, tu colles le prompt.
> Chaque soir : tu écris **OK** dans la colonne *Fait*.
> Un jour non coché est un jour non fini — **tu ne passes pas au suivant, tu coupes du scope.**

**🎨 = il y a un écran à designer ce jour-là** (30-45 min le matin, avant de coder). Sinon, tout va direct à Claude Code.

---

## Semaine 1 — Fondations

| Jour | Date | 🎨 | À faire | Fait |
|---|---|:---:|---|:---:|
| [J1](jours/J01-setup.md) | lun 20/07 | | Monorepo, PostGIS en local (Docker), **squelette déployé sur le VPS** — et lancer le compte Wave | |
| [J2](jours/J02-design-system.md) | mar 21/07 | 🎨 | Les tokens + les 9 composants du socle, dont **`TripCard`** | **OK** |
| [J3](jours/J03-schema.md) | mer 22/07 | | Les 4 migrations avec les index GIST, les modèles Eloquent | **OK** |
| [J4](jours/J04-auth.md) | jeu 23/07 | 🎨 | Auth téléphone de bout en bout — **tester 3 vrais numéros +221** | **OK**¹ |
| [J5](jours/J05-profil.md) | ven 24/07 | 🎨 | Profil complet avec photo, puis on s'arrête | **OK** |

## Semaine 2 — Le cœur

| Jour | Date | 🎨 | À faire | Fait |
|---|---|:---:|---|:---:|
| [J6](jours/J06-trajet-api.md) | lun 27/07 | | API publier un trajet + la fourchette de prix | **OK** |
| [J7](jours/J07-trajet-app.md) | mar 28/07 | 🎨 | Écran publier un trajet — **moins de 3 min chrono** | |
| [J8](jours/J08-matching.md) | mer 29/07 | | ⚠️ **LE MATCHING** — le jour qui décide du projet | |
| [J9](jours/J09-recherche.md) | jeu 30/07 | 🎨 | Écrans recherche + résultats | |
| [J10](jours/J10-tampon.md) | ven 31/07 | | 🛡️ **Tampon — n'y mets rien** | |

## Semaine 3 — La boucle

| Jour | Date | 🎨 | À faire | Fait |
|---|---|:---:|---|:---:|
| [J11](jours/J11-reservation.md) | lun 03/08 | 🎨 | Réservation : demande → acceptation → places | |
| [J12](jours/J12-push.md) | mar 04/08 | | Notifications push | |
| [J13](jours/J13-bookings-home.md) | mer 05/08 | 🎨 | Mes réservations, home, et le rappel de 5h30 | |
| [J14](jours/J14-notation.md) | jeu 06/08 | 🎨 | Notation + badges dérivés | |
| [J15](jours/J15-tampon.md) | ven 07/08 | | 🛡️ **Tampon n°2 — n'y mets rien** | |

## Semaine 4 — Rendre ça réel

| Jour | Date | 🎨 | À faire | Fait |
|---|---|:---:|---|:---:|
| [J16](jours/J16-onboarding.md) | lun 10/08 | 🎨 | Onboarding + tous les états vides | |
| [J17](jours/J17-finition.md) | mar 11/08 | | Finition + vérifier que le taux de match se lit | |
| [J18](jours/J18-durcissement.md) | mer 12/08 | | ⚠️ **Durcissement — ne se coupe jamais** | |
| [J19](jours/J19-build-store.md) | jeu 13/08 | | Build Android signé + fiche Play Store | |
| [J20](jours/J20-test-terrain.md) | ven 14/08 | | 🎯 **Point de rencontre, 6h. Pas de code.** | |

---

## Hors clavier — à ne pas oublier

| Quand | Quoi | Fait |
|---|---|:---:|
| J1 | **Commander le VPS** (5-10 €/mois, Paris ou Francfort) | |
| J1 | Compte marchand Wave Business + PayDunya lancés | |
| J1 | Alerte budget 10 $ + backups Postgres | |
| Semaine 1 | Appeler Wave : « API marchande directe, oui ou non ? » | |
| ~~Avant le J20~~ | ~~Choisir la zone~~ → **Keur Massar → Plateau** | **OK** |
| Avant la phase 0 | **Repérer le point de rencontre exact** ⚠️ | |
| S2-S3, 1h/jour | Aller compter au point de rencontre de Keur Massar, à 6h | |
| Avant le J20 | 40 numéros de conducteurs | |
| Avant la phase 2 | Juriste sur le « partage de frais » | |

---

## Les 4 règles

1. **Un jour = une tâche = une session Claude Code.** Jamais deux.
2. **L'API avant l'app, toujours.** Testée au curl avant qu'un widget existe.
3. **J10 et J15 sont tes seuls tampons.** N'y mets rien — ils vont servir.
4. **Le week-end n'est pas du temps de dev.** C'est la règle que tu voudras casser en premier, et celle qui coûte le plus cher.

¹ J4 : tout est validé sauf les SMS réels (plan Blaze requis) — voir DETTE.md, à payer avant le J18.

**Si un jour déborde, ordre de sacrifice :** badges · profile_edit · welcome slides · trip_my_list (toggle seulement).
**Ce qui ne se coupe jamais :** le matching (J8) et le durcissement (J18).
