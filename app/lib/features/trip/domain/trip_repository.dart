import 'place.dart';
import 'price_hint.dart';
import 'trip.dart';

/// Le contrat des trajets côté conducteur. Erreurs en AppException.
abstract interface class TripRepository {
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
