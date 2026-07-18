# J9 — jeudi 30 juillet 2026
## La recherche (app)

← [J8](J08-matching.md) · [Planning](../PLANNING.md) · [J10 →](J10-tampon.md)

---

## Objectif

Tu cherches depuis l'app et tu vois des conducteurs.

## Le prompt

```
App : search + search_results, branchés sur POST /api/trips/search.
États : chargement, résultats, vide.

Chaque TripCard affiche les places libres POUR LA DATE cherchée — l'API les
renvoie déjà calculées. Ne les calcule PAS côté Flutter (CLAUDE.md, la frontière
API/app).

PlaceField est déjà fait (J7) — réutilise-le.

Analytics : search_performed avec un paramètre results_count.
C'est de là que sort le taux de match, ta métrique n°1.
```

## Pourquoi `results_count` compte plus que le reste

C'est la mesure directe de l'hypothèse du J8. **Taux de match = % de recherches avec ≥ 1 résultat.** Sous 70 %, la densité naturelle ne suffit pas — et c'est la seule information qui compte vraiment ce mois-ci.

## ✅ Critère de fin

- [ ] Recherche fonctionnelle depuis l'app
- [ ] Les 3 états s'affichent correctement
- [ ] `search_performed` remonte avec `results_count`

## Notes du soir
