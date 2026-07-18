# J3 — mercredi 22 juillet 2026
## Le schéma + les modèles

← [J2](J02-design-system.md) · [Planning](../PLANNING.md) · [J4 →](J04-auth.md)

---

## Objectif

La base est en place, avec les index GIST. C'est le socle de tout le reste — une erreur ici contamine le mois.

## Le prompt

```
API : les 4 migrations de docs/02-technique.md §3 (users, trips, bookings, ratings)
avec TOUS les index, y compris les GIST sur route et dest_point.
Les modèles Eloquent, les relations, les factories, les seeders.

ATTENTION, les 3 pièges du modèle. Lis-les avant de coder :
- trips.departure_time est un TIME, pas un timestamp. Un trajet récurrent n'a
  pas de date.
- trips.seats_total ne se décrémente JAMAIS. Les places sont par date (§5).
- bookings n'a PAS de champ recurring.

Utilise geography(Point/LineString, 4326), pas geometry — les distances en mètres.
Pas de colonne badges sur users : ils sont dérivés (§4ter).

Écris un test unitaire qui vérifie que departure_time reste un TIME.
```

## ✅ Critère de fin

- [ ] `php artisan migrate:fresh --seed` passe
- [ ] `php artisan test` est vert
- [ ] `\d trips` montre bien les index GIST

## Notes du soir
