# J6 — lundi 27 juillet 2026
## Publier un trajet (API)

← [J5](J05-profil.md) · [Planning](../PLANNING.md) · [J7 →](J07-trajet-app.md)

---

> **Semaine 2 — c'est la semaine qui décide du projet.**

## Objectif

Un trajet en base, avec sa `route` PostGIS. Rien côté app aujourd'hui.

## Le prompt

```
API : POST /api/trips, GET /api/trips/mine, PATCH, DELETE + TripPolicy.

À la création : appel ROUTES API (pas Directions, qui est legacy) UNE SEULE FOIS
→ décode la polyline en LineString PostGIS, stocke route ET duration_minutes.

GET /api/trips/price-hint : la fourchette suggérée, calculée SANS appel Google —
ST_Distance à vol d'oiseau × 1,3, cf docs/02-technique.md §4bis.
C'est une parade réglementaire, pas du confort (01-produit.md §3bis).

Tests Feature.
```

## Pourquoi le price-hint n'appelle pas Google

La fourchette s'affiche **pendant que le conducteur saisit**, avant que le trajet existe. Une suggestion de prix n'a pas besoin d'être exacte au mètre — elle doit être *plausible* et *instantanée*. Appeler Routes API à chaque frappe, ce serait payer Google pour afficher un ordre de grandeur.

## ✅ Critère de fin

- [ ] Un trajet en base avec `route` et `duration_minutes` valides
- [ ] `SELECT ST_AsText(route) FROM trips LIMIT 1;` montre une vraie ligne
- [ ] `/api/trips/price-hint` répond au curl, sans appel Google

## Notes du soir
