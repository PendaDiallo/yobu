// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: (json['id'] as num).toInt(),
  date: json['date'] as String,
  status: json['status'] as String,
  seats: (json['seats'] as num).toInt(),
  pricePaid: (json['price_paid'] as num).toInt(),
  trip: BookingTrip.fromJson(json['trip'] as Map<String, dynamic>),
  driver: BookingParty.fromJson(json['driver'] as Map<String, dynamic>),
  rider: json['rider'] == null
      ? null
      : BookingParty.fromJson(json['rider'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'status': instance.status,
  'seats': instance.seats,
  'price_paid': instance.pricePaid,
  'trip': instance.trip,
  'driver': instance.driver,
  'rider': instance.rider,
};

_BookingTrip _$BookingTripFromJson(Map<String, dynamic> json) => _BookingTrip(
  id: (json['id'] as num).toInt(),
  originLabel: json['origin_label'] as String,
  destLabel: json['dest_label'] as String,
  departureTime: json['departure_time'] as String,
  durationMinutes: (json['duration_minutes'] as num).toInt(),
);

Map<String, dynamic> _$BookingTripToJson(_BookingTrip instance) =>
    <String, dynamic>{
      'id': instance.id,
      'origin_label': instance.originLabel,
      'dest_label': instance.destLabel,
      'departure_time': instance.departureTime,
      'duration_minutes': instance.durationMinutes,
    };

_BookingParty _$BookingPartyFromJson(Map<String, dynamic> json) =>
    _BookingParty(
      id: (json['id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      photoUrl: json['photo_url'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
      tripsCompleted: (json['trips_completed'] as num?)?.toInt() ?? 0,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$BookingPartyToJson(_BookingParty instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'photo_url': instance.photoUrl,
      'rating': instance.rating,
      'rating_count': instance.ratingCount,
      'trips_completed': instance.tripsCompleted,
      'phone': instance.phone,
    };
