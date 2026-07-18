# J17 — mardi 11 août 2026
## Finition + vérification des métriques

← [J16](J16-onboarding.md) · [Planning](../PLANNING.md) · [J18 →](J18-durcissement.md)

---

## Objectif

Rien ne casse. Et tu peux lire ton taux de match.

## Le prompt

```
App : tous les états de chargement, tous les cas d'erreur réseau, tous les
messages en français correct. PAS de nouvelle feature.

Puis vérifie dans Firebase Analytics que les 5 événements remontent :
- trip_published (J7)
- search_performed avec results_count (J9)
- booking_requested (J11)
- booking_accepted (J11)
- trip_completed (J14)

Les 4 métriques de docs/05-strategie.md §7 doivent être calculables à partir
d'eux — vérifie-le explicitement, une par une.
```

## ✅ Critère de fin

- [ ] **Téléphone en mode avion sur chaque écran** — rien ne casse
- [ ] Les 5 événements remontent dans la console
- [ ] **Tu lis ton taux de match dans Firebase Analytics**

## Notes du soir
