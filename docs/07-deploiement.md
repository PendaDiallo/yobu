# YOBU — Déploiement

> **Statut : squelette déployé et vérifié le 06/09** sur la machine OVH
> `51.91.100.103`. `GET /api/health` répond `{"ok":true}` en externe, les 4
> services (`caddy`, `php8.3-fpm`, `postgresql`, `yobu-queue`) sont `active` +
> `enabled` (reboot-safe), backup quotidien en cron. Sections §2→§8 + §11 : **OK**.
> Restent §9 (scheduler → J13) et §10/§12 (procédures et dette, non déclenchées).
> Chaque section porte sa case `Validé sur la prod`.

Ce fichier comble le trou signalé le 06/09 : `02-technique.md §8` s'arrêtait sur
« tu sais faire ». Or le J13 **dépend** du scheduler sur le VPS, et un déploiement
non écrit est un déploiement qu'on refait de mémoire à 2h du matin.

---

## 0. Le principe — déploie le squelette tôt

> **Si tu attends le J19 pour déployer, tu découvres tes problèmes de déploiement
> au J19** — avec 5 personnes qui attendent l'APK et zéro marge.

Le squelette part en ligne dès que `GET /api/health` renvoie `{"ok":true}`. À ce
stade, une extension `pgsql` manquante ou un souci de permissions se règle en
20 min parce que rien d'autre ne peut casser. Le même bug au J19 coûte la date.

Et le VPS devient **obligatoire au J13** : le rappel de 5h30 ne se teste pas sur
une machine qui se met en veille.

---

## 1. La cible — ce qui tourne sur la machine

| Rôle | Choix | Pourquoi |
|---|---|---|
| OS | **Ubuntu 24.04 LTS** | PHP 8.3 **natif** (la cible pinée dans `composer.json`), PostgreSQL 16 natif — aucun PPA |
| Reverse proxy | **Caddy** | config en 6 lignes, TLS auto le jour où un domaine pointe dessus |
| Runtime PHP | **php8.3-fpm** | socket `/run/php/php8.3-fpm.sock` |
| Base | **PostgreSQL 16 + PostGIS 3** | `postgresql-16-postgis-3`, extension créée à la main (§4) |
| Queue | **worker `queue:work` en service systemd** | driver `database` (cf `DETTE.md` 16/07) — pas de Redis, une dépendance de moins |
| Scheduler | **cron `schedule:run` chaque minute** (J13) | rappel 5h30 `Africa/Dakar`, passage auto en `completed` |
| Backups | **`pg_dump -Fc` quotidien, rotation 7 j** | restauré pour de vrai au J18 |

**Pas dans cette session, assumé en dette (§12) :** domaine + HTTPS, fail2ban,
port SSH non standard, Sentry, CI/CD. L'app debug tolère déjà le cleartext HTTP.

---

## 2. Provisionner la machine

**Décision (06/09) : OVH.** Commandé par Penda. Zone Europe (Gravelines / Roubaix
/ Strasbourg) → ~50 ms depuis Dakar, imperceptible pour du REST. Gabarit visé :
**2 vCPU / 4 Go / ~40 Go SSD** (VPS « Value » ou « Essential »), ~6-8 €/mois.
Image **Ubuntu 24.04**. Clé SSH `id_ed25519` déposée à la commande.

> Hetzner CX22 (~3,79 €) était la reco initiale ; OVH fait le job, on ne revient
> pas dessus.

- [x] **Livré le 06/09** — IP publique : `51.91.100.103`

**Machine confirmée le 06/09** (snapshot à la première connexion) :

| | Valeur | Note |
|---|---|---|
| OS | Ubuntu **24.04.4 LTS** | ✅ PHP 8.3 + PostgreSQL 16 natifs |
| Hostname | `vps-4887efe2` | |
| CPU / RAM | **2 vCPU / 3.7 Gio** | conforme à la cible |
| Swap | **0 B** | ⚠️ à créer en §3 (sinon OOM au `composer install`) |
| `php8.3-fpm` (apt) | candidat `8.3.6-0ubuntu0.24.04.10` | dépôt Ubuntu, pas de PPA |
| `postgresql-16` (apt) | candidat `16.14-0ubuntu0.24.04.1` | idem |

---

## 3. Premier contact + accès

**Décision (06/09) : le user de connexion et de déploiement est `ubuntu`.**
OVH livre le VPS avec un user `ubuntu` (sudo), la connexion `root` par SSH est
désactivée d'origine, et un mot de passe initial est disponible dans le *manager
OVH → section « Secret »* (jamais nécessaire ici, la clé `id_ed25519` suffit —
**ne jamais le commiter, ne pas le coller dans ce fichier**).

**On ne crée pas de user `deploy` séparé.** Solo dev, une machine, un rôle :
`ubuntu` est à la fois l'admin (sudo) et le user qui fait tourner l'app
(PHP-FPM, worker de queue, cron). La séparation admin/runtime est notée en
dette §12 — elle se fera si un second intervenant arrive.

```bash
ssh ubuntu@51.91.100.103
```

Vérifier que `sudo` ne demande pas de mot de passe (OVH le configure en NOPASSWD
en général) :

```bash
sudo -n true && echo "sudo OK (NOPASSWD)" || echo "sudo demande un mot de passe"
```

Mises à jour + fuseau + swap (la VM 3.7 Gio sans swap se fait tuer par l'OOM au
premier `composer install`) :

```bash
sudo apt update && sudo apt -y upgrade
sudo timedatectl set-timezone Africa/Dakar
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile
sudo mkswap /swapfile && sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
free -h | grep -i swap        # doit montrer 2,0Gi
```

Firewall — SSH + HTTP seulement (HTTPS ouvert d'avance pour le jour du domaine) :

```bash
sudo ufw allow OpenSSH
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
sudo ufw status
```

État SSH de départ (OVH) : `root` déjà interdit, `ubuntu` par clé uniquement.
Rien à durcir de plus dans cette session ; fail2ban + port custom → dette §12.

> Le premier `apt upgrade` a tiré un nouveau kernel (`needrestart` le signale) —
> **`sudo reboot`** tout de suite, machine vide, avant d'installer la stack.

- [x] **Validé sur la prod (06/09)** — swap 2 Gio actif, ufw actif (SSH/80/443),
  fuseau `Africa/Dakar` (affiché « GMT », UTC+0), reboot kernel fait.

---

## 4. La stack système

Tout en `sudo` depuis `ubuntu`.

```bash
# PHP 8.3 (natif 24.04) + les extensions dont Laravel 12 a besoin
sudo apt -y install php8.3-fpm php8.3-cli php8.3-pgsql php8.3-mbstring \
  php8.3-xml php8.3-curl php8.3-bcmath php8.3-gd php8.3-zip php8.3-intl

# PostgreSQL 16 + PostGIS
sudo apt -y install postgresql-16 postgresql-16-postgis-3

# Caddy (dépôt officiel)
sudo apt -y install debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' \
  | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' \
  | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update && sudo apt -y install caddy

# Composer + git
sudo apt -y install git unzip
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# Versions attendues
php -v            # PHP 8.3.x
psql --version    # psql (PostgreSQL) 16.x
caddy version
composer --version
```

**Pool PHP-FPM en `ubuntu`** (`/etc/php/8.3/fpm/pool.d/www.conf`) : `user = ubuntu`,
`group = ubuntu`, `listen.owner = ubuntu`, `listen.group = caddy` →
`sudo systemctl restart php8.3-fpm`. Évite la valse de permissions sur `storage/`
(le code appartient à `ubuntu`, FPM tourne en `ubuntu`).

- [x] **Validé sur la prod (06/09)** — PHP 8.3.6 (fpm), PostgreSQL 16.15 (cluster
  `16/main`, tz `Africa/Dakar`), PostGIS 3.4.2, Caddy 2.11.4, Composer 2.10.3.
  Les 3 services `active`. Caddy sert sa page par défaut sur `:80` (écrasée en §7).

---

## 5. La base

Le mot de passe du rôle est **généré sur la machine** et rangé dans
`/root/yobu_db_pass` (chmod 600) — il ne transite jamais par le chat ni par git.
`§6` le relit de là pour écrire le `.env`.

```bash
DBPASS=$(openssl rand -hex 24)
sudo -u postgres psql -v pass="$DBPASS" <<'SQL'
CREATE ROLE yobu LOGIN PASSWORD :'pass';
CREATE DATABASE yobu OWNER yobu;
SQL
sudo -u postgres psql -d yobu -c "CREATE EXTENSION IF NOT EXISTS postgis;"
sudo -u postgres psql -d yobu -c "SELECT PostGIS_Version();"
printf '%s\n' "$DBPASS" | sudo tee /root/yobu_db_pass >/dev/null && sudo chmod 600 /root/yobu_db_pass

# test : le rôle se connecte bien en TCP (ce que fait Laravel : DB_HOST=127.0.0.1)
PGPASSWORD=$(sudo cat /root/yobu_db_pass) psql -h 127.0.0.1 -U yobu -d yobu \
  -c "SELECT current_user, PostGIS_Version();"
```

Le rôle `yobu` n'est **pas** superuser : `CREATE EXTENSION postgis` doit donc être
lancé une fois en `postgres` (ci-dessus), pas par la migration. C'est exactement
ce qui était impossible sur O2switch (`02-technique.md §8`).

`pg_hba.conf` (défaut Ubuntu) : `local … peer`, `host 127.0.0.1/32 … scram-sha-256`.
Rien à ouvrir vers l'extérieur, l'API tape la base en `127.0.0.1`.

- [x] **Validé sur la prod (06/09)** — rôle + base + `CREATE EXTENSION postgis`
  (PostGIS 3.4, GEOS/PROJ/STATS), connexion TCP `yobu@127.0.0.1` OK en scram-sha-256.

---

## 6. Déployer le code

**Dépôt privé `git@github.com:PendaDiallo/yobu.git`** → une *deploy key* en lecture
seule (pas ta clé perso sur le serveur) :

```bash
ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_yobu -N ""
cat ~/.ssh/id_ed25519_yobu.pub
# → GitHub : repo yobu › Settings › Deploy keys › Add, lecture seule
```

`~/.ssh/config` (user `ubuntu`) :

```
Host github-yobu
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_yobu
```

Clone du monorepo — on ne déploie que `api/`, mais le clone complet (l'app Flutter
pèse quelques Mo) évite un sparse-checkout fragile :

```bash
sudo mkdir -p /var/www && sudo chown ubuntu:ubuntu /var/www
git clone github-yobu:PendaDiallo/yobu.git /var/www/yobu
cd /var/www/yobu/api
composer install --no-dev --optimize-autoloader
```

`.env` de prod (`/var/www/yobu/api/.env`) — **jamais commité**. On part de
`.env.example`, on écrase les clés qui changent, et `DB_PASSWORD` est réinjecté
depuis `/root/yobu_db_pass` (jamais tapé à la main) :

```bash
cd /var/www/yobu/api
cp .env.example .env
DBPASS=$(sudo cat /root/yobu_db_pass)
sed -i \
  -e 's#^APP_ENV=.*#APP_ENV=production#' \
  -e 's#^APP_DEBUG=.*#APP_DEBUG=false#' \
  -e 's#^APP_URL=.*#APP_URL=http://51.91.100.103#' \
  -e 's#^DB_CONNECTION=.*#DB_CONNECTION=pgsql#' \
  -e 's#^DB_HOST=.*#DB_HOST=127.0.0.1#' \
  -e 's#^DB_PORT=.*#DB_PORT=5432#' \
  -e 's#^DB_DATABASE=.*#DB_DATABASE=yobu#' \
  -e 's#^DB_USERNAME=.*#DB_USERNAME=yobu#' \
  -e "s#^DB_PASSWORD=.*#DB_PASSWORD=${DBPASS}#" \
  -e 's#^QUEUE_CONNECTION=.*#QUEUE_CONNECTION=database#' \
  .env
cat >> .env <<'EOF'

APP_TIMEZONE=Africa/Dakar
GOOGLE_CLOUD_PROJECT=yobu-594f7
FIREBASE_CREDENTIALS=/var/www/yobu/api/storage/app/firebase/service-account.json
# NE PAS définir FIREBASE_AUTH_EMULATOR_HOST en prod : FCM/Auth tapent le vrai Google
EOF
```

Le `service-account.json` (secret, hors git) se copie depuis le poste de dev :

```bash
# depuis la machine locale
scp api/storage/app/firebase/service-account.json \
    ubuntu@51.91.100.103:/var/www/yobu/api/storage/app/firebase/service-account.json
```

Finalisation :

```bash
cd /var/www/yobu/api
php artisan key:generate
php artisan migrate --force
php artisan config:cache && php artisan route:cache && php artisan event:cache
php artisan storage:link
chmod -R ug+rw storage bootstrap/cache
```

- [x] **Validé sur la prod (06/09)** — deploy key GitHub, clone, `composer install
  --no-dev` (Laravel 12.64), `.env` prod + `APP_KEY`, `service-account.json` en
  place (2370 o, projet `yobu-594f7`), 7 migrations `Ran`, caches générés.

---

## 7. Caddy

`/etc/caddy/Caddyfile` — **IP nue, HTTP seulement** (le jour du domaine : remplacer
`:80` par `api.yobu.sn` et Caddy fait le TLS tout seul, rien d'autre à changer) :

```caddy
:80 {
	root * /var/www/yobu/api/public
	encode gzip
	php_fastcgi unix//run/php/php8.3-fpm.sock
	file_server
}
```

```bash
sudo systemctl restart caddy
curl -s http://51.91.100.103/api/health   # → {"ok":true,"postgis":"3.x ..."}
```

`GET /api/health` (pas `/up`, cf `02-technique.md §6`) est le check qui fait foi :
il exécute `PostGIS_Version()` et renvoie `503` si la base ou l'extension manque.

> **Pas de fichier de log Caddy dans le squelette.** Le `caddy.service` du paquet
> Ubuntu est sandboxé (`ProtectSystem`) : `log { output file /var/log/caddy/… }`
> échoue en `permission denied` même avec le dossier possédé par `caddy`, et même
> avec un drop-in `LogsDirectory=caddy`. Les logs d'accès et d'erreur partent donc
> vers **journald** : `journalctl -u caddy -f`. Le drop-in
> `/etc/systemd/system/caddy.service.d/override.conf` (`LogsDirectory=caddy`) est
> laissé en place pour rebrancher un fichier plus tard si le volume le justifie.

- [x] **Validé sur la prod (06/09)** — `curl http://51.91.100.103/api/health` →
  `{"ok":true,"postgis":"3.4 …"}` en interne **et** en externe. Chaîne complète OK.

---

## 8. La queue en service

`/etc/systemd/system/yobu-queue.service` :

```ini
[Unit]
Description=YOBU queue worker
After=network.target postgresql.service

[Service]
User=ubuntu
Group=ubuntu
Restart=always
RestartSec=3
WorkingDirectory=/var/www/yobu/api
ExecStart=/usr/bin/php artisan queue:work --tries=3 --max-time=3600 --sleep=3

[Install]
WantedBy=multi-user.target
```

Logs → **journald** (`journalctl -u yobu-queue -f`), même raison qu'en §7.

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now yobu-queue
sudo systemctl status yobu-queue --no-pager | head -12
```

**Après chaque déploiement**, le worker tourne encore l'ancien code en mémoire →
`php artisan queue:restart` (ci-dessous, §10) le fait redémarrer proprement.

Test bout en bout (J12) : depuis l'émulateur pointé sur `http://51.91.100.103`,
publier → demander → accepter, vérifier la notif reçue **app fermée** et le job
traité dans `journalctl -u yobu-queue`.

- [x] **Validé sur la prod (06/09)** — service `enabled` + `active (running)`,
  PID sur `queue:work --tries=3`, aucun crash/boucle. Preuve fonctionnelle
  (traitement d'un job réel) reportée au test e2e de J12.

---

## 9. Le scheduler (J13)

Crontab du user `ubuntu` (`crontab -e`, sans `sudo`) :

```cron
* * * * * cd /var/www/yobu/api && php artisan schedule:run >> /var/log/yobu/schedule.log 2>&1
```

La planification vit dans `routes/console.php` (commande `app:daily-reminders` à
5h30 `Africa/Dakar` + passage en `completed` 2h après le départ — à coder au J13).
Le fuseau de la machine est déjà `Africa/Dakar` (§3), `APP_TIMEZONE` aussi.

Vérif au J13 : se lever, constater la notif de 5h30. (Oui.)

- [ ] **À faire au J13** — le squelette ne l'installe pas (aucune commande
  planifiée n'existe encore dans `routes/console.php`).

---

## 10. Déployer une mise à jour

Le geste répété, à scripter plus tard dans `bin/deploy.sh` :

```bash
cd /var/www/yobu/api
php artisan down
git -C /var/www/yobu pull --ff-only
composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan config:cache && php artisan route:cache && php artisan event:cache
php artisan queue:restart
php artisan up
curl -s http://127.0.0.1/api/health
```

---

## 11. Backups

`/usr/local/bin/yobu-backup.sh` :

```bash
#!/usr/bin/env bash
set -euo pipefail
DIR=/var/backups/yobu
mkdir -p "$DIR"
STAMP=$(date +%Y%m%d-%H%M%S)
sudo -u postgres pg_dump -Fc yobu > "$DIR/yobu-$STAMP.dump"
find "$DIR" -name 'yobu-*.dump' -mtime +7 -delete
```

```bash
sudo chmod +x /usr/local/bin/yobu-backup.sh
sudo /usr/local/bin/yobu-backup.sh          # premier run manuel
( sudo crontab -l 2>/dev/null; echo "30 2 * * * /usr/local/bin/yobu-backup.sh" ) | sudo crontab -
```

- [x] **Validé sur la prod (06/09)** — 1er dump `yobu-20260906-180620.dump` (65 K)
  dans `/var/backups/yobu`, ligne cron `30 2 * * *` en place (crontab root).

**Restauration (à faire pour de vrai au J18) :**

```bash
sudo -u postgres createdb yobu_restore_test
sudo -u postgres pg_restore -d yobu_restore_test /var/backups/yobu/yobu-<STAMP>.dump
sudo -u postgres psql -d yobu_restore_test -c "SELECT count(*) FROM trips;"
sudo -u postgres dropdb yobu_restore_test
```

Un backup jamais restauré n'est pas un backup.

- [x] **Cron en place (06/09)** — 1er dump créé.
- [ ] **Restauration testée (J18) : ⬜**

---

## 12. Ce qui reste — dette de déploiement assumée

À reporter dans `DETTE.md` une fois le squelette en ligne :

| Quoi | Pourquoi on l'assume maintenant | Quand on paie |
|---|---|---|
| **Pas de domaine → HTTP nu** | L'app debug tolère le cleartext ; le release est HTTPS-only et ne sort qu'au J19 | Avant le J19 : sous-domaine + `:80` → `api.yobu.sn` dans le Caddyfile, Caddy fait le TLS |
| **Durcissement SSH minimal** (pas de fail2ban, port 22) | 1 machine, 1 clé, surface faible ; le temps est au produit | J18 (durcissement) ou avant si les logs `auth.log` chauffent |
| **Pas de séparation admin / runtime** — `ubuntu` fait tout (sudo + PHP-FPM + queue + cron) | Solo dev, 1 machine ; `02-technique.md §10` (pas de couche préventive). Un user dédié sans second intervenant n'apporte que du boilerplate | Le jour où un 2ᵉ intervenant arrive : créer `deploy` non-sudo, `chown -R deploy` sur `/var/www/yobu`, repointer FPM/queue/cron |
| **Déploiement manuel** (pas de CI/CD) | 20 déploiements sur le mois, `git pull` + 4 commandes suffisent | Après le J20, si la fréquence le justifie |
| **Pas de Sentry** | Les logs Laravel + `journalctl` suffisent à 10 utilisateurs | J18 (l'audit le prévoit déjà) |
| **App Check / reCAPTCHA absent** sur Firebase Phone Auth | Le flux OTP part côté client, pas via l'API — le rate-limit Laravel ne le couvre pas ; quota SMS exposé | J18 : activer App Check sur le projet `yobu-594f7` |

---

## 13. Checklist « le squelette est en ligne »

Vérifiée le **06/09** :

- [x] `curl http://51.91.100.103/api/health` → `{"ok":true,"postgis":"3.4 …"}` depuis le Mac
- [x] `php artisan migrate:status` : 7 migrations `Ran`
- [x] `systemctl is-active caddy php8.3-fpm postgresql yobu-queue` → `active` ×4
- [x] les 4 services `enabled` (survivent au reboot)
- [x] `SELECT PostGIS_Version()` répond (3.4, GEOS+PROJ+STATS)
- [x] `yobu-20260906-180620.dump` (65 K) dans `/var/backups/yobu` + cron `30 2 * * *`
- [x] `service-account.json` présent (2370 o, projet `yobu-594f7`), hors git (gitignore + non cloné)
- [ ] **L'émulateur pointé sur `http://51.91.100.103` fait publier → chercher → réserver** → à faire côté app (J12)
- [ ] **`PLANNING.md` : ligne « Commander le VPS » + note J1 à cocher**
