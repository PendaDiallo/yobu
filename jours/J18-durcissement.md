# J18 — mercredi 12 août 2026
## ⚠️ Le durcissement — ne se coupe jamais

← [J17](J17-finition.md) · [Planning](../PLANNING.md) · [J19 →](J19-build-store.md)

---

## Pourquoi ce jour ne se coupe pas

**Une base ouverte, c'est le genre de chose qui tue un projet en une nuit.** Tu vas donner l'app à de vrais gens dans 48h, avec leurs numéros de téléphone et leurs adresses de domicile.

## Le prompt

```
Audit des Policies, endpoint par endpoint. Avec le token d'un AUTRE utilisateur,
essaie :
- PATCH un trip qui n'est pas le tien
- accepter un booking dont tu n'es pas le conducteur
- noter un booking auquel tu n'as pas participé
- écrire users.rating via PATCH /api/me

Chaque tentative doit renvoyer 403. Tests Feature pour chacune des 4.

Puis :
- rate limiting sur /api/auth/firebase et /api/trips/search
- Sentry
- vérifie qu'aucun secret n'est dans le repo (le .json Firebase surtout)
- HTTPS forcé
```

## Le backup

- [ ] **Restaure un backup Postgres pour de vrai.** Un backup jamais testé n'est pas un backup.

## ✅ Critère de fin

- [ ] Les 4 attaques renvoient 403, avec un test Feature chacune
- [ ] Un backup a été restauré avec succès
- [ ] Aucun secret dans le repo
- [ ] Sentry reçoit une erreur de test

## Notes du soir
