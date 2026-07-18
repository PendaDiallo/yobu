# J7 — mardi 28 juillet 2026
## Publier un trajet (app)

← [J6](J06-trajet-api.md) · [Planning](../PLANNING.md) · [J8 →](J08-matching.md)

---

## Objectif

Parcours conducteur complet, de bout en bout.

## Le prompt

```
App : le composant PlaceField (docs/03-design-brief.md §3), puis trip_create
et trip_my_list.

PlaceField : Places Autocomplete restreint à country:sn, AVEC session tokens
(sinon chaque frappe est facturée).
DayPicker (déjà au socle). showTimePicker natif — ne le redessine pas.
Le prix affiche la fourchette de GET /api/trips/price-hint, avec un
avertissement hors fourchette.

trip_my_list : toggle actif/inactif, suppression avec confirmation.

Analytics : trip_published.
```

## ⏱️ Le test du jour — chronomètre-toi

**Ouverture de l'app → trajet publié, en moins de 3 minutes.**

Si c'est plus long, tu coupes des champs. Un conducteur qui abandonne au 4ᵉ écran de saisie ne revient pas.

## ✅ Critère de fin

- [ ] Parcours conducteur complet depuis l'app
- [ ] Moins de 3 minutes, chronomètre en main
- [ ] `trip_published` remonte dans Firebase Analytics

## Notes du soir
