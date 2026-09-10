import 'package:dio/dio.dart';

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
    } on DioException catch (error) {
      // Le premier message de validation Laravel est déjà en français
      // (« Tu as déjà noté ce trajet. »).
      final data = error.response?.data;
      if (data is Map && data['errors'] is Map) {
        final first = (data['errors'] as Map).values.first;
        if (first is List && first.isNotEmpty) {
          throw AppException('${first.first}');
        }
      }
      final message = data is Map ? data['message'] : null;
      if (message is String && message.isNotEmpty) {
        throw AppException(message);
      }

      throw const AppException(
        'Impossible d\'envoyer ta note. Vérifie ta connexion et réessaie.',
      );
    }
  }
}
