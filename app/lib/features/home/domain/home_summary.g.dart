// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HomeSummary _$HomeSummaryFromJson(Map<String, dynamic> json) => _HomeSummary(
  next: json['next'] == null
      ? null
      : NextRide.fromJson(json['next'] as Map<String, dynamic>),
);

Map<String, dynamic> _$HomeSummaryToJson(_HomeSummary instance) =>
    <String, dynamic>{'next': instance.next};

_NextRide _$NextRideFromJson(Map<String, dynamic> json) => _NextRide(
  role: json['role'] as String,
  date: json['date'] as String,
  departureTime: json['departure_time'] as String,
  originLabel: json['origin_label'] as String,
  destLabel: json['dest_label'] as String,
  price: (json['price'] as num?)?.toInt(),
  partner: json['with'] == null
      ? null
      : NextRidePartner.fromJson(json['with'] as Map<String, dynamic>),
  seatsTaken: (json['seats_taken'] as num?)?.toInt(),
  seatsTotal: (json['seats_total'] as num?)?.toInt(),
);

Map<String, dynamic> _$NextRideToJson(_NextRide instance) => <String, dynamic>{
  'role': instance.role,
  'date': instance.date,
  'departure_time': instance.departureTime,
  'origin_label': instance.originLabel,
  'dest_label': instance.destLabel,
  'price': instance.price,
  'with': instance.partner,
  'seats_taken': instance.seatsTaken,
  'seats_total': instance.seatsTotal,
};

_NextRidePartner _$NextRidePartnerFromJson(Map<String, dynamic> json) =>
    _NextRidePartner(
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      photoUrl: json['photo_url'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$NextRidePartnerToJson(_NextRidePartner instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'photo_url': instance.photoUrl,
      'phone': instance.phone,
    };
