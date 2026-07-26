import 'booking.dart';

/// Le contrat des réservations. Erreurs en AppException (messages français
/// de l'API : déjà demandé, trajet complet, demande déjà traitée…).
abstract interface class BookingRepository {
  /// La demande du passager → pending.
  Future<Booking> request({required int tripId, required String date});

  /// Mes réservations (passager).
  Future<List<Booking>> mine();

  /// Les demandes reçues sur mes trajets (conducteur), pending d'abord.
  Future<List<Booking>> received();

  /// accepted | rejected (conducteur) · cancelled (passager).
  Future<Booking> respond(int bookingId, String status);
}
