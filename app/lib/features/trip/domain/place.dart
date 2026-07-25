import 'package:freezed_annotation/freezed_annotation.dart';

part 'place.freezed.dart';
part 'place.g.dart';

/// Un lieu nommé avec ses coordonnées — ce que PlaceField renvoie.
@freezed
abstract class Place with _$Place {
  const factory Place({
    required String label,
    required double lat,
    required double lng,
  }) = _Place;

  factory Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);
}
