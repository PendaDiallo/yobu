// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_hint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PriceHint _$PriceHintFromJson(Map<String, dynamic> json) => _PriceHint(
  min: (json['min'] as num).toInt(),
  suggested: (json['suggested'] as num).toInt(),
  max: (json['max'] as num).toInt(),
);

Map<String, dynamic> _$PriceHintToJson(_PriceHint instance) =>
    <String, dynamic>{
      'min': instance.min,
      'suggested': instance.suggested,
      'max': instance.max,
    };
