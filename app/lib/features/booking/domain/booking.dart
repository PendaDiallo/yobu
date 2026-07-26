import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

/// Une réservation telle que l'API la renvoie. Le téléphone de l'autre
/// partie n'est présent QU'UNE FOIS la demande acceptée — c'est l'API qui
/// décide, jamais l'app.
@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required int id,
    required String date,
    required String status,
    required int seats,
    required int pricePaid,
    required BookingTrip trip,
    required BookingParty driver,
    BookingParty? rider,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) =>
      _$BookingFromJson(json);
}

@freezed
abstract class BookingTrip with _$BookingTrip {
  const factory BookingTrip({
    required int id,
    required String originLabel,
    required String destLabel,
    required String departureTime,
    required int durationMinutes,
  }) = _BookingTrip;

  factory BookingTrip.fromJson(Map<String, dynamic> json) =>
      _$BookingTripFromJson(json);
}

@freezed
abstract class BookingParty with _$BookingParty {
  const factory BookingParty({
    required int id,
    required String firstName,
    required String lastName,
    String? photoUrl,
    @Default(0) double rating,
    @Default(0) int ratingCount,
    @Default(0) int tripsCompleted,
    /// Présent seulement quand la réservation est acceptée.
    String? phone,
  }) = _BookingParty;

  factory BookingParty.fromJson(Map<String, dynamic> json) =>
      _$BookingPartyFromJson(json);
}
