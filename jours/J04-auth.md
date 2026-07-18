# J4 — jeudi 23 juillet 2026
## Auth de bout en bout

← [J3](J03-schema.md) · [Planning](../PLANNING.md) · [J5 →](J05-profil.md)

---

## Objectif

Tu te connectes avec ton vrai numéro. C'est le seul endroit où Firebase et Laravel se parlent — fais-le proprement une fois, n'y touche plus.

## Le prompt

```
API : POST /api/auth/firebase — le flux complet de docs/02-technique.md §2.
Vérification de l'ID token via kreait, User::firstOrCreate sur firebase_uid,
renvoi d'un token Sanctum. GET /api/me. Tests Feature.

App : phone_auth et otp_verify. Firebase Auth téléphone, +221 pré-rempli et
verrouillé. Gère : mauvais code, renvoi après 60s, numéro invalide, pas de réseau.
Stocke le token Sanctum dans flutter_secure_storage.

Le token Firebase ne sert QU'UNE FOIS, à l'appel /api/auth/firebase. Ensuite
c'est du Sanctum. Ne le renvoie pas à chaque requête.

DEV : utilise les numéros de test de la console Firebase.
```

## ⚠️ Le truc à ne pas rater aujourd'hui

**Teste avec 2 ou 3 vrais numéros +221 aujourd'hui.** C'est le jour où les surprises opérateur sortent — pas le J19. Un problème d'OTP découvert en semaine 4 est un problème qui décale ton lancement.

Mais **développe avec les numéros de test** : chaque vrai SMS coûte 0,06 $, échecs compris.

## ✅ Critère de fin

- [ ] Tu te connectes avec ton vrai numéro
- [ ] Une ligne apparaît dans `users`
- [ ] 2 autres numéros réels testés
- [ ] `php artisan test` vert

## Notes du soir
