/// Le contrat de la notation. Erreurs en AppException (« Tu as déjà noté ce
/// trajet. » vient de l'API).
abstract interface class RatingRepository {
  /// Note l'autre partie d'un trajet terminé. L'API déduit qui est noté
  /// (conducteur ↔ passager) — l'app ne le décide pas.
  Future<void> submit({
    required int bookingId,
    required int score,
    required List<String> tags,
    String? comment,
  });
}
