import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// L'utilisateur tel que l'API le renvoie. C'EST le modèle — pas de doublon
/// entité/modèle. Les badges arrivent calculés par l'API, jamais dérivés ici.
@freezed
abstract class User with _$User {
  const factory User({
    required int id,
    required String phone,
    required String firstName,
    required String lastName,
    String? photoUrl,
    String? role,
    @Default(0) double rating,
    @Default(0) int ratingCount,
    @Default(0) int tripsCompleted,
    @Default([]) List<String> badges,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
