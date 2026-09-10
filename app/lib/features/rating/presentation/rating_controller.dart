import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';

/// La soumission d'une note. Pas d'état de liste ici — l'écran gère son
/// propre `loading` local ; ce contrôleur ne fait qu'orchestrer l'appel.
class RatingController {
  const RatingController(this._ref);

  final Ref _ref;

  Future<void> submit({
    required int bookingId,
    required int tripId,
    required int score,
    required List<String> tags,
    String? comment,
  }) async {
    await _ref.read(ratingRepositoryProvider).submit(
          bookingId: bookingId,
          score: score,
          tags: tags,
          comment: comment,
        );

    // Le signal « un trajet a eu lieu » — 5e des events de 04-roadmap §J17.
    await _ref.read(analyticsProvider).logEvent(
      name: 'trip_completed',
      parameters: {'trip_id': tripId},
    );
  }
}

final ratingControllerProvider =
    Provider<RatingController>((ref) => RatingController(ref));
