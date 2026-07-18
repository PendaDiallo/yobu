# J8 — mercredi 29 juillet 2026
## ⚠️ LE MATCHING — le jour le plus important du mois

← [J7](J07-trajet-app.md) · [Planning](../PLANNING.md) · [J9 →](J09-recherche.md)

---

## Ce qui se joue aujourd'hui

Ce n'est pas une feature. **C'est l'hypothèse du projet.**

> Le point de rencontre marche *parce qu'il agrège* : il crée de la densité par la force. YOBU parie que **la densité naturelle d'un quartier suffit, sans convergence**.
>
> `ST_DWithin(route, passager, 1500 m)` *est* ce pari. Rien d'autre dans l'app ne le teste.

**Ce jour ne se coupe jamais.** (`docs/01-produit.md §5`)

## Le prompt

```
API : TripMatchingService + POST /api/trips/search.
La requête PostGIS de docs/02-technique.md §4, telle quelle.

Le SQL sort 50 candidats bruts triés par proximité — il ne trie PAS par score.
Le score n'existe pas en base : il dépend d'une normalisation du prix sur
l'ensemble des résultats. Le scoring et le top 10 se font en PHP.

Écris les tests AVANT le service. Cas à couvrir :
- passager exactement sur le trajet
- à 1,4 km
- à 1,6 km (exclu)
- horaire à +19 min
- à +21 min (exclu)
- trajet complet ce jour-là
- aucun résultat

N'appelle JAMAIS la Routes API ici — la route est déjà en base.
```

## ✅ Critère de fin

- [ ] Les tests du scoring passent, **écrits avant le code**
- [ ] Tu seedes 5 trajets sur ta zone, tu cherches depuis un point intermédiaire **au curl**, et les bons remontent en tête
- [ ] Aucun appel Routes API dans le flux de recherche

Si le classement te paraît absurde : **tu ajustes les poids du score, pas le pipeline.**

## Notes du soir
