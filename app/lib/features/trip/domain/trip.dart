import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip.freezed.dart';
part 'trip.g.dart';

/// Le trajet récurrent tel que l'API le renvoie. C'EST le modèle.
@freezed
abstract class Trip with _$Trip {
  const factory Trip({
    required int id,
    required String originLabel,
    required String destLabel,
    /// « 06:45 » — un trajet récurrent n'a pas de date.
    required String departureTime,
    required int durationMinutes,
    required List<int> daysOfWeek,
    required int seatsTotal,
    required int pricePerSeat,
    required bool active,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
}
