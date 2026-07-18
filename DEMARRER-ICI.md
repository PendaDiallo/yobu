# Démarrer — à lire une fois, puis jamais

## 1. Où mettre ce dossier

**Ce dossier `yobu/` EST la racine de ton projet.** Tu ne le mets pas *dans* un projet — c'est lui, le projet.

```bash
# quelque part chez toi, ex. ~/dev/
unzip yobu.zip
cd yobu
git init && git add . && git commit -m "Conception"
```

Au J1, Claude Code va créer `api/` et `app/` **dedans** :

```
yobu/                    ← tu ouvres Claude Code ICI
├── DEMARRER-ICI.md      ← ce fichier
├── PLANNING.md          ← ⭐ ton point d'entrée quotidien
├── jours/               ← un fichier par jour, avec le prompt
├── CLAUDE.md            ← Claude Code le lit tout seul, tu n'y touches pas
├── docs/                ← la source de vérité
├── api/                 ← créé au J1 (Laravel)
└── app/                 ← créé au J1 (Flutter)
```

> **Claude Code doit être lancé depuis `yobu/`, pas depuis `yobu/api/`.** Sinon il ne voit ni `CLAUDE.md` ni les docs, et tu perds tout l'intérêt du système.

## 2. Ce que tu donnes à Claude Code

**Le prompt du fichier du jour. C'est tout.**

Tu n'expliques pas le projet. Tu ne joins pas les docs. Tu ne redis pas le stack. `CLAUDE.md` est lu automatiquement à chaque session, et il lui dit d'aller lire `JOURNAL.md`, `PLANNING.md`, le fichier du jour, et les docs dont il a besoin.

**Ta session commence comme ça, tous les jours :**

```
On est au J[N]. Lis CLAUDE.md, docs/JOURNAL.md (les 3 dernières entrées) et
jours/J[NN]-*.md. Fais le point sur ce qui est fait, puis attaque le jour.
```

Puis tu colles le prompt du jour. **Une session = un jour. Jamais deux.**

## 3. Ce que tu donnes à Claude Design

**Rien, sauf les jours marqués 🎨 dans `PLANNING.md`.** Il y en a 9 sur 20.

Les jours 🎨, avant de coder, tu ouvres une conversation séparée et tu colles le prompt de `docs/03-design-brief.md §4`, **en joignant** :
- `docs/03-design-brief.md`
- `docs/01-produit.md`

Tu remplaces `[NOM]` par l'écran du jour. 30-45 minutes, pas plus.

**Puis tu passes la maquette à Claude Code** avec le second prompt du §4.

> **Pourquoi ça marche :** les tokens Dart sont écrits au J2. Claude Design ne dessine pas dans le vide — il **compose** avec 13 briques qui existent déjà en code. C'est ce qui évite de passer ta semaine 3 à traduire des maquettes en Flutter.

## 4. Et le J1, concrètement ?

| | |
|---|---|
| **Claude Design** | **rien.** Pas d'écran au J1. |
| **Claude Code** | les 2 prompts du fichier `jours/J01-setup.md` — d'abord le local, puis le déploiement. |
| **Toi, hors clavier** | commander le VPS, lancer le compte Wave Business + PayDunya, appeler Wave. **30 minutes, et ça tourne 6 semaines en fond.** |

## 5. La boucle, une fois pour toutes

```
Matin  → PLANNING.md → clic sur le jour
       → si 🎨 : 30-45 min de design (conversation séparée)
       → colle le prompt du jour dans Claude Code
Soir   → Claude Code te propose l'entrée de docs/JOURNAL.md → tu valides
       → critère de fin atteint ? oui → OK dans PLANNING.md → commit
                                  non → coupe du scope, ne rattrape pas
```

**Tu n'ouvres qu'un fichier par jour.** Le reste existe pour Claude Code, pas pour toi.

---

## Les 3 choses à ne pas oublier du mois

1. **Le week-end n'est pas du temps de dev.** C'est ta marge. C'est la règle que tu voudras casser en premier, et celle qui coûte le plus cher.
2. **Le matching (J8) et le durcissement (J18) ne se coupent jamais.** Tout le reste est négociable.
3. **Le J20, tu sors même si tu es à 80 %.** La date est plus importante que le périmètre.
