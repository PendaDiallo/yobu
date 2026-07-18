# J2 — mardi 21 juillet 2026
## Design system + TripCard

← [J1](J01-setup.md) · [Planning](../PLANNING.md) · [J3 →](J03-schema.md)

---

## Objectif

Les 9 composants du socle existent en vrai, en Dart. À partir de demain, designer un écran = assembler des briques, pas dessiner.

## Le prompt

```
Implémente app/lib/shared/theme/tokens.dart exactement comme spécifié dans
docs/03-design-brief.md §2 — direction B « Affirmé ».

Puis les 9 widgets du SOCLE (§3, premier tableau). Pas les 4 autres — ils
viendront avec leur feature (J7, J11, J14).
StarRating fait partie du socle : UserCard affiche une note dès le J5.

Pour chacun : tous les variants et états listés.
Crée une route /debug qui affiche tous les composants dans tous leurs états.

RÈGLES ABSOLUES :
- Aucune valeur en dur. Tout vient de tokens.dart.
- JAMAIS de texte blanc sur AppColors.primaryVivid (#00B368) — 2,7:1, illisible
  au soleil. Le vert vif est un ACCENT : points, pastilles, états actifs.
- Le CTA principal : fond AppColors.primary (#05301C), texte blanc, 56 de haut,
  pleine largeur, AppRadius.md.
- Chiffres en tabular-nums partout.
```

## La demi-journée TripCard

`TripCard` apparaît sur 4 écrans. **Si cette carte est bonne, l'app est bonne.** C'est le seul composant qui mérite d'être designé hors urgence (`docs/03-design-brief.md §5`).

**La règle qui le définit :** le prix est le plus gros élément de la carte. 34px, poids 800. Le conducteur vient après.

## ✅ Critère de fin

- [ ] `/debug` montre les 9 composants du socle, dans tous leurs états
- [ ] **Tu les regardes sur ton téléphone, dehors, en plein soleil**
- [ ] `flutter analyze` propre

## Notes du soir
