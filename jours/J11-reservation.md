# J11 — lundi 3 août 2026
## Réservation

← [J10](J10-tampon.md) · [Planning](../PLANNING.md) · [J12 →](J12-push.md)

---

> **Semaine 3 — à la fin, deux personnes peuvent réellement faire un trajet ensemble.**

## Objectif

Demande → acceptation → places à jour.

## Le prompt

```
API : POST /api/bookings (pending), GET /api/bookings, GET /api/bookings/received,
PATCH /api/bookings/{booking}.

L'acceptation suit EXACTEMENT le pseudo-code de docs/02-technique.md §5 :
transaction + lockForUpdate + comptage des accepted pour (trip_id, date).
Ne décrémente PAS seats_total.

BookingPolicy : le conducteur seul accepte.

App : les composants WhatsAppButton (wa.me/221..., visible seulement une fois la
réservation acceptée) et RouteMap, puis trip_detail + trip_requests.

Analytics : booking_requested, booking_accepted.
```

## ⚠️ Le `lockForUpdate()` n'est pas optionnel

Deux passagers acceptés pour la dernière place à la même seconde : les deux passent, **quelqu'un reste sur le trottoir à 6h30**. C'est le seul endroit de la V1 où une race condition a une conséquence physique.

## ✅ Critère de fin

- [ ] Demande → acceptation → les places du jour se calculent juste
- [ ] **Teste la course :** deux onglets curl, accepte deux demandes pour la dernière place quasi simultanément → la seconde échoue proprement
- [ ] Le bouton WhatsApp n'apparaît qu'après acceptation

## Notes du soir
