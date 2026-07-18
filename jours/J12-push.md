# J12 — mardi 4 août 2026
## Notifications push

← [J11](J11-reservation.md) · [Planning](../PLANNING.md) · [J13 →](J13-bookings-home.md)

---

## Objectif

Une notif arrive sur un vrai téléphone, app fermée.

## Le prompt

```
API : envoi FCM sur demande reçue, demande acceptée, demande refusée.
Job en queue (driver database, pas Redis — tu n'en as pas besoin, une dépendance
de moins sur le VPS).

App : réception FCM, deep link vers le bon écran au tap.
Android uniquement, pas iOS.

users.fcm_token existe déjà (J5) — gère le refresh du token.
```

## ✅ Critère de fin

- [ ] Notif reçue sur un vrai téléphone, **app complètement fermée**
- [ ] Le tap ouvre le bon écran
- [ ] La queue tourne sur le VPS (`php artisan queue:work` en supervisor)

## Notes du soir
