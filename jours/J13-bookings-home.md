# J13 — mercredi 5 août 2026
## Bookings + home + le cron

← [J12](J12-push.md) · [Planning](../PLANNING.md) · [J14 →](J14-notation.md)

---

## Objectif

L'app devient utile au quotidien. Le rappel du matin part tout seul.

## Le prompt

```
App : bookings (à venir / passées) et home (prochain trajet, actions rapides).
Le WhatsAppButton apparaît sur bookings pour les réservations acceptées.

API : commande artisan dailyReminders, planifiée à 5h30 Africa/Dakar — notif aux
gens qui ont un trajet ce matin.
Passage auto des bookings en 'completed' 2h après l'heure de départ.

Vérifie que le scheduler tourne bien sur le VPS (crontab).
```

## ✅ Critère de fin

- [ ] **Tu reçois un rappel à 5h30.** (Oui, tu vas te lever pour vérifier.)
- [ ] Un booking passe en `completed` tout seul
- [ ] Le crontab du VPS appelle bien `schedule:run`

## Notes du soir
