// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  phone: json['phone'] as String,
  firstName: json['first_name'] as String,
  lastName: json['last_name'] as String,
  photoUrl: json['photo_url'] as String?,
  role: json['role'] as String?,
  rating: (json['rating'] as num?)?.toDouble() ?? 0,
  ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
  tripsCompleted: (json['trips_completed'] as num?)?.toInt() ?? 0,
  badges:
      (json['badges'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'photo_url': instance.photoUrl,
  'role': instance.role,
  'rating': instance.rating,
  'rating_count': instance.ratingCount,
  'trips_completed': instance.tripsCompleted,
  'badges': instance.badges,
};
