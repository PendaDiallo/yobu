import 'match.dart';
import 'place.dart';
import 'price_hint.dart';
import 'trip.dart';

/// Le contrat des trajets. Erreurs en AppException.
abstract interface class TripRepository {
  /// Le matching (docs/02-technique.md §4) : l'API renvoie le top 10
  /// déjà trié par score, places restantes calculées pour [date].
  Future<List<Match>> search({
    required Place origin,
    required Place destination,
    required String arrivalBefore,
    required String date,
  });

  /// La fourchette de prix, calculée par l'API — jamais localement.
  Future<PriceHint> priceHint({required Place origin, required Place destination});

  Future<Trip> publish({
    required Place origin,
    required Place destination,
    required String departureTime,
    required List<int> daysOfWeek,
    required int seatsTotal,
    required int pricePerSeat,
  });

  Future<List<Trip>> mine();

  Future<Trip> setActive(int tripId, bool active);

  Future<void> delete(int tripId);
}
