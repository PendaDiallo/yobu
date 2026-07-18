# J1 — lundi 20 juillet 2026
## Monorepo, PostGIS en local, squelette déployé

← [Planning](../PLANNING.md) · [J2 →](J02-design-system.md)

---

## ⚠️ Avant de toucher au clavier — 30 min

Ces choses tournent en fond pendant 6 semaines. Si tu ne les fais pas aujourd'hui, tu les paieras en semaine 7.

- [ ] **Compte marchand Wave Business** — activation 5 à 10 jours ouvrables
- [ ] **Inscription PayDunya** (en parallèle, on ne sait pas encore lequel on prend)
- [ ] **Appeler Wave** : « API marchande directe, oui ou non ? » — la réponse change la décision (`docs/02-technique.md §7`)
- [ ] **Commander le VPS** — 2 vCPU / 4 Go, Paris ou Francfort, 5-10 €/mois

## Objectif

Tu développes en local avec Docker. **Et le squelette vide tourne déjà sur le VPS.**

## 🎯 Pourquoi on déploie aujourd'hui, alors qu'il n'y a rien dedans

> **Si tu attends le J19 pour déployer, tu découvriras tes problèmes de déploiement au J19** — avec 5 personnes qui attendent l'APK et zéro jour de marge.

Aujourd'hui, `/api/health` renvoie `{"ok":true}` et rien d'autre. Une extension `pgsql` manquante, un souci de permissions, une version de PHP : ça se règle en 20 minutes, parce que rien d'autre ne peut casser. Le même problème au J19 te coûte ta date.

*(Et de toute façon le VPS devient obligatoire au J13 : le rappel de 5h30 ne se teste pas sur une machine qui se met en veille.)*

## Le prompt — 1/2, le local

```
Initialise le monorepo YOBU selon l'arborescence de CLAUDE.md : api/ (Laravel 11,
PHP 8.3) et app/ (Flutter 3).

DEV LOCAL — docker-compose.yml à la racine :
  image postgis/postgis:16-3.4 (PostGIS inclus, l'extension est créée à l'init)
  POSTGRES_DB=yobu, port 5432, volume persistant.
.env : DB_CONNECTION=pgsql, DB_HOST=127.0.0.1, DB_PORT=5432

API : Sanctum, kreait/laravel-firebase, Model::preventLazyLoading() en local.
Un endpoint GET /api/health qui renvoie {"ok":true} ET vérifie que PostGIS
répond (SELECT PostGIS_Version()).

App : Riverpod, go_router avec les 16 routes de docs/01-produit.md (écrans vides),
freezed, dio avec l'intercepteur Bearer.
API_URL configurable par --dart-define. Sur émulateur Android : 10.0.2.2, PAS
localhost — l'émulateur ne voit pas le localhost de la machine hôte.

Firebase : Auth téléphone + FCM UNIQUEMENT. Pas de Firestore, pas de Functions,
pas de Storage.
Configure les émulateurs Firebase et les numéros de test pour l'auth téléphone —
chaque vrai SMS coûte 0,06 $ (docs/06-couts.md).
```

## Le prompt — 2/2, le déploiement

Une fois que ça tourne en local :

```
Déploie l'API sur le VPS : PHP 8.3, Postgres 16 + PostGIS, HTTPS, et un script
de déploiement que je relancerai à chaque fois.

Vérifie que /api/health répond en HTTPS depuis l'extérieur ET que
SELECT PostGIS_Version() fonctionne en prod.

Mets en place les backups Postgres quotidiens automatiques.
```

## Les protections — aujourd'hui, pas plus tard

`docs/06-couts.md`

- [ ] **Alerte budget à 10 $** sur Google Cloud (Maps + SMS Firebase)
- [ ] **Backups Postgres quotidiens** sur le VPS, automatiques

## Les 2 pièges du dev local

| Piège | Parade |
|---|---|
| **L'émulateur Android ne voit pas ton `localhost`** | Pour lui, ta machine c'est **`10.0.2.2`**. Tu perdras 30 min au J4 si tu l'ignores. |
| **`php artisan serve` n'écoute que `127.0.0.1`** | Sur vrai téléphone en Wi-Fi : `--host=0.0.0.0`, puis `http://192.168.x.x:8000` |

## ✅ Critère de fin

**En local :**
- [ ] `docker compose up -d` → Postgres + PostGIS tournent
- [ ] `SELECT PostGIS_Version();` répond
- [ ] `flutter run` affiche un écran sur l'émulateur

**En prod :**
- [ ] **`/api/health` répond en HTTPS depuis le VPS**
- [ ] **`SELECT PostGIS_Version();` répond aussi en prod**
- [ ] Le script de déploiement marche une deuxième fois

**Et :**
- [ ] C'est sur GitHub
- [ ] L'alerte budget est active, les backups tournent

## Notes du soir

_(Claude Code te propose l'entrée de `docs/JOURNAL.md` — relis et valide)_
