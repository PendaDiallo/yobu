import 'package:freezed_annotation/freezed_annotation.dart';

part 'match.freezed.dart';
part 'match.g.dart';

/// Un candidat renvoyé par POST /api/trips/search. TOUT arrive déjà
/// calculé par l'API — places restantes pour la date, heure d'arrivée,
/// distance de pickup, score. L'app affiche, point.
@freezed
abstract class Match with _$Match {
  const factory Match({
    required MatchTrip trip,
    required MatchDriver driver,
    required int pickupDistanceM,
    required int dropoffDistanceM,
    required double score,
  }) = _Match;

  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

@freezed
abstract class MatchTrip with _$MatchTrip {
  const factory MatchTrip({
    required int id,
    required String originLabel,
    required String destLabel,
    required String departureTime,
    required String arrivalTime,
    required int durationMinutes,
    required int pricePerSeat,
    /// Pour LA date cherchée — jamais recalculé côté app.
    required int seatsLeft,
  }) = _MatchTrip;

  factory MatchTrip.fromJson(Map<String, dynamic> json) =>
      _$MatchTripFromJson(json);
}

@freezed
abstract class MatchDriver with _$MatchDriver {
  const factory MatchDriver({
    required int id,
    required String firstName,
    required String lastName,
    String? photoUrl,
    @Default(0) double rating,
    @Default(0) int ratingCount,
    @Default(0) int tripsCompleted,
    @Default([]) List<String> badges,
  }) = _MatchDriver;

  factory MatchDriver.fromJson(Map<String, dynamic> json) =>
      _$MatchDriverFromJson(json);
}
