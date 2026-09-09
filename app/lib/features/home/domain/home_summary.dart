import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_summary.freezed.dart';
part 'home_summary.g.dart';

/// Le dashboard tel que l'API le renvoie. Tout est déjà calculé côté
/// serveur : « prochain », rôle, places prises — l'app affiche, point.
@freezed
abstract class HomeSummary with _$HomeSummary {
  const factory HomeSummary({NextRide? next}) = _HomeSummary;

  factory HomeSummary.fromJson(Map<String, dynamic> json) =>
      _$HomeSummaryFromJson(json);
}

/// Le prochain trajet — soit une place réservée (rôle `rider`), soit une
/// occurrence d'un trajet publié (rôle `driver`). Les champs propres à un
/// rôle sont nuls pour l'autre.
@freezed
abstract class NextRide with _$NextRide {
  const factory NextRide({
    required String role,
    required String date,
    required String departureTime,
    required String originLabel,
    required String destLabel,
    // rôle rider
    int? price,
    @JsonKey(name: 'with') NextRidePartner? partner,
    // rôle driver
    int? seatsTaken,
    int? seatsTotal,
  }) = _NextRide;

  factory NextRide.fromJson(Map<String, dynamic> json) =>
      _$NextRideFromJson(json);
}

@freezed
abstract class NextRidePartner with _$NextRidePartner {
  const factory NextRidePartner({
    required String firstName,
    required String lastName,
    String? photoUrl,
    String? phone,
  }) = _NextRidePartner;

  factory NextRidePartner.fromJson(Map<String, dynamic> json) =>
      _$NextRidePartnerFromJson(json);
}
