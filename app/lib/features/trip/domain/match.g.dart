// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Match _$MatchFromJson(Map<String, dynamic> json) => _Match(
  trip: MatchTrip.fromJson(json['trip'] as Map<String, dynamic>),
  driver: MatchDriver.fromJson(json['driver'] as Map<String, dynamic>),
  pickupDistanceM: (json['pickup_distance_m'] as num).toInt(),
  dropoffDistanceM: (json['dropoff_distance_m'] as num).toInt(),
  score: (json['score'] as num).toDouble(),
);

Map<String, dynamic> _$MatchToJson(_Match instance) => <String, dynamic>{
  'trip': instance.trip,
  'driver': instance.driver,
  'pickup_distance_m': instance.pickupDistanceM,
  'dropoff_distance_m': instance.dropoffDistanceM,
  'score': instance.score,
};

_MatchTrip _$MatchTripFromJson(Map<String, dynamic> json) => _MatchTrip(
  id: (json['id'] as num).toInt(),
  originLabel: json['origin_label'] as String,
  destLabel: json['dest_label'] as String,
  departureTime: json['departure_time'] as String,
  arrivalTime: json['arrival_time'] as String,
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  pricePerSeat: (json['price_per_seat'] as num).toInt(),
  seatsLeft: (json['seats_left'] as num).toInt(),
);

Map<String, dynamic> _$MatchTripToJson(_MatchTrip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'origin_label': instance.originLabel,
      'dest_label': instance.destLabel,
      'departure_time': instance.departureTime,
      'arrival_time': instance.arrivalTime,
      'duration_minutes': instance.durationMinutes,
      'price_per_seat': instance.pricePerSeat,
      'seats_left': instance.seatsLeft,
    };

_MatchDriver _$MatchDriverFromJson(Map<String, dynamic> json) => _MatchDriver(
  id: (json['id'] as num).toInt(),
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  photoUrl: json['photo_url'] as String?,
  rating: (json['rating'] as num?)?.toDouble() ?? 0,
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  tripsCompleted: (json['trips_completed'] as num?)?.toInt() ?? 0,
  badges:
      (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$MatchDriverToJson(_MatchDriver instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'photo_url': instance.photoUrl,
      'rating': instance.rating,
      'rating_count': instance.ratingCount,
      'trips_completed': instance.tripsCompleted,
      'badges': instance.badges,
    };
