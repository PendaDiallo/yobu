import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_hint.freezed.dart';
part 'price_hint.g.dart';

/// La fourchette réglementaire renvoyée par GET /api/trips/price-hint.
/// L'app l'affiche telle quelle — elle ne calcule jamais un prix.
@freezed
abstract class PriceHint with _$PriceHint {
  const factory PriceHint({
    required int min,
    required int suggested,
    required int max,
  }) = _PriceHint;

  factory PriceHint.fromJson(Map<String, dynamic> json) =>
      _$PriceHintFromJson(json);
}
