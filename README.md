# YOBU

Covoiturage domicile-travail à Dakar. **Laravel + PostGIS + Flutter.** Solo dev.
**Départ : 20 juillet 2026 · Beta : 14 août 2026.**

## La structure

```
yobu/
├── PLANNING.md   ← ⭐ TON POINT D'ENTRÉE. La liste des 20 jours, tu coches ici.
├── jours/        ← un fichier par jour, avec le prompt à coller
├── CLAUDE.md     ← lu automatiquement par Claude Code
├── docs/         ← la source de vérité
├── api/          ← Laravel 11 + PostgreSQL 16 + PostGIS
└── app/          ← Flutter 3 (Android d'abord)
```

**Monorepo.** Une seule session Claude Code voit l'API et l'app. C'est ce qui évite d'expliquer deux fois le même projet.

## Le système

| Fichier | À quoi ça sert | Quand tu l'ouvres |
|---|---|---|
| **`PLANNING.md`** | **La liste des 20 jours. Tu écris OK quand c'est fait.** | **Tous les matins** |
| **`jours/J01..J20.md`** | **Le fichier du jour : objectif, prompt, critère de fin** | **Tous les matins** |
| `CLAUDE.md` | Le contrat avec Claude Code. Lu automatiquement. | Jamais — il travaille tout seul |
| `docs/01-produit.md` | Scope V1 gelé, 16 écrans, parcours | Quand tu te demandes « est-ce que je code ça ? » |
| `docs/02-technique.md` | Schéma SQL, matching PostGIS, endpoints, paiement | Avant chaque session de code |
| `docs/03-design-brief.md` | Design system + protocole Claude Design ↔ Claude Code | Avant chaque session de design |
| `docs/04-roadmap.md` | La vue d'ensemble des 4 semaines, les règles du mois | Une fois par semaine |
| `docs/05-strategie.md` | Le marché réel, l'amorçage au point de rencontre, métriques, deck | Une fois par semaine |
| `docs/06-couts.md` | VPS, SMS, Maps — et les protections | Une fois, le J1 |
| `docs/JOURNAL.md` | La mémoire du projet | **Tous les soirs, 2 min** |
| `docs/DETTE.md` | Ce qu'on s'autorise à faire mal | Quand tu contournes un truc |
| `docs/IDEES.md` | Le parking des bonnes idées hors scope | Quand une idée te vient |

## La boucle quotidienne

```
Matin  → ouvre PLANNING.md, clique sur le jour
       → 30-45 min de design de l'écran du jour (s'il y en a un)
       → colle le prompt du fichier dans Claude Code
       → il lit CLAUDE.md + JOURNAL.md + les docs tout seul
Soir   → 2 min : entrée dans docs/JOURNAL.md (Claude Code te la propose)
       → critère de fin atteint ? oui → OK dans PLANNING.md, commit, jour suivant
                                  non → coupe du scope, ne rattrape pas
```

**Tu n'ouvres qu'un fichier par jour.** Le reste est là pour Claude Code, pas pour toi.

## Les 4 règles qui font tenir le mois

1. **Un jour = une tâche = une session Claude Code.** Jamais deux.
2. **L'API avant l'app, toujours.** Testée au curl avant qu'un widget existe. Deux bugs qui se cachent l'un l'autre, c'est 3h perdues.
3. **Le scope V1 est gelé.** Toute idée nouvelle va dans `docs/IDEES.md`, pas dans le code.
4. **Le week-end n'est pas du temps de dev.** C'est ta marge. Tu vas en avoir besoin en semaine 3.

## Ce qui est décidé, et pourquoi

- **Laravel + PostGIS plutôt que Firestore** → tes données sont relationnelles, et le matching passe de ~200 lignes d'acrobaties geohash à **une requête** `ST_DWithin`. C'est le cœur du produit, il mérite le bon outil. `docs/02-technique.md §4`
- **Firebase réduit à l'auth SMS + les push** → les deux seules choses qu'il fait mieux que tout le monde. Et à 0,06 $/SMS, il est au prix du marché sénégalais (Twilio : 0,44 $).
- **Pas de chat intégré, un bouton WhatsApp** → 3 jours de WebSockets économisés. **C'est ce troc qui finance la bascule vers Laravel** et fait tenir le 14 août. `docs/01-produit.md §2`
- **Paiement cash en V1**, Wave en S7-S8 → il ne teste pas ton hypothèse et coûte une semaine. `docs/02-technique.md §7`
- **Zone de lancement : Keur Massar → Plateau** → **le BRT ne dessert pas Keur Massar** (il s'arrête à Guédiawaye), et le CETUD y mesure une demande « particulièrement forte ». Douleur maximale, alternative absente. `docs/05-strategie.md §3bis`
- **Une zone autour d'un point de rencontre existant, pas Dakar** → la liquidité est déjà réunie là-bas, à 6h. Inutile de recruter à froid. `docs/05-strategie.md §4`
- **S5-S6 : recrutement au point de rencontre, pas de code** → coder pour une app sans utilisateurs, c'est optimiser du vide. `docs/05-strategie.md §4`
- **La pub : géociblée sur 5 km, et jamais avant les 30 conducteurs** → la dispersion est l'ennemi, pas le manque d'utilisateurs. `docs/05-strategie.md §5`
- **Android d'abord** → iOS coûte 99 $/an et des certificats. Ton marché est sur Android.
- **0 % de commission au départ** → encaisser fait de toi un agrégateur de paiement. Pas seul, pas en un mois.
- **Le modèle éco : les conducteurs paient déjà 125 F/passager au point de rencontre** → la disposition à payer est prouvée, pas à tester. Piste : 50 F/réservation en crédits, soit 2,5× moins cher. Décision au mois 3. `docs/05-strategie.md §6`
- **Le taux de match est la seule métrique** → sous 70 %, rien d'autre ne compte. `docs/05-strategie.md §5`

## À faire aujourd'hui

- [ ] Lancer le compte marchand Wave Business + PayDunya (30 min, ça tourne 6 semaines en fond)
- [ ] Appeler Wave : « API marchande directe, oui ou non ? » — ça change la décision
- [x] ~~Choisir la zone~~ → **Keur Massar → Plateau** ✅
- [ ] Commander le VPS (5-10 €/mois, Paris ou Francfort)
- [ ] Lire `docs/01-produit.md §2` et valider ou contester le scope gelé

**Et le truc le plus rentable de tout ce dossier** (S2-S3, 1h/jour) : aller au point de rencontre à 6h et **compter**. Combien de conducteurs, combien de passagers, combien de km chacun a marché pour venir. `docs/05-strategie.md §4`
