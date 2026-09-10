import '../../../core/errors/app_exception.dart';
import '../domain/rating_repository.dart';
import 'rating_api.dart';

class RatingRepositoryImpl implements RatingRepository {
  const RatingRepositoryImpl(this._api);

  final RatingApi _api;

  @override
  Future<void> submit({
    required int bookingId,
    required int score,
    required List<String> tags,
    String? comment,
  }) async {
    try {
      await _api.create(
        bookingId: bookingId,
        score: score,
        tags: tags,
        comment: comment,
      );
    } catch (error) {
      // Le 1er message de validation Laravel est déjà en français
      // (« Tu as déjà noté ce trajet. »).
      throw AppException.fromDio(
        error,
        fallback:
            'Impossible d\'envoyer ta note. Vérifie ta connexion et réessaie.',
      );
    }
  }
}
