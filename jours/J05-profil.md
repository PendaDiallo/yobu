# J5 — vendredi 24 juillet 2026
## Profil

← [J4](J04-auth.md) · [Planning](../PLANNING.md) · [J6 →](J06-trajet-api.md)

---

## Objectif

Profil complet avec photo. Fin de la semaine 1.

## Le prompt

```
API : PATCH /api/me, POST /api/me/photo (upload + compression 800px/80%),
POST /api/me/fcm-token. UserResource.
Les champs rating, rating_count, trips_completed ne sont JAMAIS modifiables par
le client — $fillable strict.
Les badges sont dérivés dans UserResource (docs/02-technique.md §4ter) :
phone_verified toujours vrai, regular à 10 trajets. Pas de colonne.

App : profile_setup, profile_view, profile_edit.
UserCard affiche la note via StarRating en mode lecture (déjà fait au J2).
```

## 🛑 Puis tu t'arrêtes

**Tu ne prends pas d'avance sur la semaine 2.** L'avance prise en S1 se paie toujours en S3 — tu arrives au matching fatigué, et c'est le jour qui décide du projet.

## ✅ Critère de fin

- [ ] Profil complet avec photo, de bout en bout
- [ ] Impossible d'écrire `rating` depuis le client (essaie, pour de vrai)

## Notes du soir

_Bilan de la semaine 1 : mets à jour le tableau de bord dans `docs/JOURNAL.md`._
