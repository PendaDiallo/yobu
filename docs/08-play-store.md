# YOBU — J19 : build release + Play Store

> Ce qui est **fait dans le code** (signature conditionnelle, version, police
> bundlée, icône placeholder, politique de confidentialité) et ce qui reste
> **à faire dans la console** (compte Play, keystore, upload, captures).

---

## 0. Prérequis bloquant — le domaine

Un build **release Android est HTTPS-only** (pas de cleartext hors debug).
La prod est en `http://51.91.100.103` sans TLS → **un APK release ne joindrait
pas l'API**. Domaine acheté : **`yobu.sn`**.

À faire **avant le build** :
1. DNS : `A  api.yobu.sn  →  51.91.100.103`.
2. Sur le VPS, `/etc/caddy/Caddyfile` — remplacer la 1re ligne :
   ```caddy
   api.yobu.sn {
       root * /var/www/yobu/api/public
       encode gzip
       php_fastcgi unix//run/php/php8.3-fpm.sock
       file_server
   }
   ```
   `sudo systemctl reload caddy` — Caddy obtient le certificat Let's Encrypt
   tout seul (port 443 déjà ouvert au J18… vérifier `sudo ufw status`).
3. `.env` du VPS : `APP_URL=https://api.yobu.sn` → active le `URL::forceScheme('https')`
   armé au J18. `php artisan config:clear`.
4. `git pull` sur le VPS pour récupérer `api/public/privacy.html`.
5. Vérifier : `curl https://api.yobu.sn/api/health` et
   `curl https://api.yobu.sn/privacy.html`.

---

## 1. Keystore (une fois, jamais commité)

```bash
keytool -genkey -v -keystore ~/yobu-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias yobu
```

Puis `app/android/key.properties` (déjà dans `android/.gitignore`) :

```properties
storePassword=<mot de passe du keystore>
keyPassword=<mot de passe de la clé>
keyAlias=yobu
storeFile=/Users/penda/yobu-release.jks
```

`build.gradle.kts` lit ce fichier ; s'il est absent, il retombe sur la clé
debug (pour `flutter run --release` en local).

> **Sauvegarde le `.jks` et les mots de passe hors de la machine.** Perdre le
> keystore = impossible de publier une mise à jour de l'app. (Play App Signing
> atténue ça si tu l'actives à la création de l'app — recommandé.)

---

## 2. Build

```bash
cd app
flutter build appbundle --release --dart-define=API_URL=https://api.yobu.sn
# → build/app/outputs/bundle/release/app-release.aab   (~15-20 Mo livrés par device)
```

APK direct (pour installer à la main sur 1-2 téléphones sans passer par Play) :

```bash
flutter build apk --release --dart-define=API_URL=https://api.yobu.sn
# → build/app/outputs/flutter-apk/app-release.apk
```

Version : `pubspec.yaml` → `version: 1.0.0+1` (name `1.0.0`, code `1`).
Chaque upload Play doit incrémenter le `+N`.

---

## 3. Fiche Play Store — texte prêt

**Nom de l'app** : `YOBU`

**Description courte** (80 caractères max) :
> Ton voisin va au Plateau ce matin. Trouve-le au lieu de marcher 2 km.

**Description complète** :
> **YOBU relie les gens du même quartier qui font le même trajet le matin.**
>
> À Dakar, un conducteur et un passager quittent souvent la même rue et font
> chacun 1 à 3 km — parfois dans la mauvaise direction — pour se retrouver à un
> point de rencontre. Ils étaient à 400 mètres l'un de l'autre.
>
> YOBU supprime ce détour.
>
> **Pour le conducteur** : tu publies ton trajet une fois (départ, arrivée,
> heure, jours). YOBU te propose les passagers qui sont déjà sur ta route.
>
> **Pour le passager** : tu cherches ton trajet, tu vois les conducteurs
> compatibles près de chez toi, triés du plus proche au moins cher. Tu demandes
> une place. Une fois acceptée, vous vous contactez sur WhatsApp.
>
> **Pensé pour un usage quotidien** : le trajet est récurrent, tu le configures
> une fois. Numéro vérifié, note visible, vraie photo — tu sais avec qui tu
> montes.
>
> Lancement sur le corridor **Keur Massar → Plateau**.
>
> Paiement en espèces, de la main à la main. Aucune commission.

**Catégorie** : Cartes et navigation (ou Auto et véhicules)
**Type** : Application · Gratuite · Contient de la pub : Non
**Politique de confidentialité** : `https://api.yobu.sn/privacy.html`
**Email de contact** : `contact@yobu.sn` (à créer — cf `privacy.html`)

**Data safety form** (déclaration Play) — cocher :
- Localisation approximative/précise : collectée, non partagée, pour la
  fonctionnalité de l'app (l'utilisateur saisit ses lieux).
- Infos personnelles : nom, numéro de téléphone, photo — collectées, partagées
  avec l'autre participant, pour la fonctionnalité.
- Messages : non.
- Identifiants de l'appareil : jeton FCM, pour les notifications.
- Chiffrement en transit : oui. Suppression de compte : sur demande.

---

## 4. Assets visuels (à produire — design)

| Asset | Format | État |
|---|---|---|
| Icône appli (dans l'APK) | adaptive icon | ⚠️ **placeholder** : « Y » vert menthe sur fond `#05301C`. À remplacer par la vraie icône via `flutter_launcher_icons` + source 1024×1024. |
| Icône hi-res (fiche Play) | PNG 512×512 | à faire |
| Feature graphic | PNG 1024×500 | à faire |
| Captures téléphone | 2 à 8, PNG/JPEG, ratio 16:9 ou 9:16 | à faire — prendre `welcome`, `search`, résultats (`TripCard`), `bookings` |

Les densités legacy `mipmap-*/ic_launcher.png` sont encore l'icône Flutter par
défaut (utilisée seulement sur Android < 8 ; l'adaptive icon couvre le reste).
`flutter_launcher_icons` les régénèrera toutes d'un coup avec la vraie source.

---

## 5. Publication — test interne

1. Play Console → **Créer une application** (langue par défaut : français, app
   gratuite).
2. Activer **Play App Signing** (Google garde une copie de la clé de signature).
3. **Test interne** → créer une release → uploader l'`.aab`.
4. Ajouter la liste des testeurs (jusqu'à 100 e-mails) — les **5 personnes** du
   J20 + toi.
5. Remplir : fiche principale, questionnaire *Contenu de l'application*, *Data
   safety*, *Public cible* (18+), politique de confidentialité.
6. Envoyer en revue. Le test interne est généralement dispo en quelques heures
   (pas les jours de la prod). Partager le **lien d'opt-in** aux testeurs.

---

## Critère de fin J19

- [ ] `curl https://api.yobu.sn/api/health` → `{"ok":true}` (domaine + TLS)
- [ ] `.aab` signé avec le keystore release, uploadé
- [ ] Fiche remplie, politique de confidentialité en ligne
- [ ] Test interne actif, lien envoyé à 5 personnes
- [ ] Les 5 ont installé
