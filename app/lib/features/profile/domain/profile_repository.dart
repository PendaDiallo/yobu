import 'user.dart';

/// Le contrat du profil. Toute erreur remonte en AppException, message
/// français prêt à afficher.
abstract interface class ProfileRepository {
  Future<User> getMe();

  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? role,
  });

  /// Envoie la photo (chemin local) — la compression finale est côté API.
  Future<User> uploadPhoto(String filePath);
}
