// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
  id: (json['id'] as num).toInt(),
  originLabel: json['origin_label'] as String,
  destLabel: json['dest_label'] as String,
  departureTime: json['departure_time'] as String,
  durationMinutes: (json['duration_minutes'] as num).toInt(),
  daysOfWeek: (json['days_of_week'] as List<dynamic>)
      .map((e) => (e as num).toInt())
      .toList(),
  seatsTotal: (json['seats_total'] as num).toInt(),
  pricePerSeat: (json['price_per_seat'] as num).toInt(),
  active: json['active'] as bool,
);

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
  'id': instance.id,
  'origin_label': instance.originLabel,
  'dest_label': instance.destLabel,
  'departure_time': instance.departureTime,
  'duration_minutes': instance.durationMinutes,
  'days_of_week': instance.daysOfWeek,
  'seats_total': instance.seatsTotal,
  'price_per_seat': instance.pricePerSeat,
  'active': instance.active,
};
