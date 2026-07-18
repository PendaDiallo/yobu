# J14 — jeudi 6 août 2026
## Notation

← [J13](J13-bookings-home.md) · [Planning](../PLANNING.md) · [J15 →](J15-tampon.md)

---

## Objectif

La boucle est bouclée : trajet → note → confiance.

## Le prompt

```
API : POST /api/ratings + RatingService. Recalcul de users.rating en transaction.

Les badges sont DÉRIVÉS dans UserResource (docs/02-technique.md §4ter) :
phone_verified toujours vrai, regular à 10 trajets. N'ajoute PAS de colonne badges.

La contrainte UNIQUE (booking_id, from_user_id) fait le travail : les DEUX
participants notent, chacun une fois.
ratingId = ${bookingId}_${fromUid}.

RatingPolicy : booking completed + l'auteur en est participant.

App : le composant TagChip, puis l'écran rating.
StarRating existe depuis le J2 (socle) — active son mode saisie, ne le réécris pas.
UserCard affiche déjà la note en lecture depuis le J5.

Analytics : trip_completed.
```

## ✅ Critère de fin

- [ ] Noter met à jour la note du destinataire
- [ ] **Conducteur ET passager peuvent noter le même trajet**
- [ ] Aucun des deux ne peut noter deux fois
- [ ] Impossible de noter un booking auquel on n'a pas participé

## Notes du soir
