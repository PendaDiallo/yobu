import '../../profile/domain/user.dart';

/// Résultat d'une demande d'OTP.
sealed class OtpRequest {
  const OtpRequest();
}

/// Le SMS est parti : on attend la saisie du code.
class OtpCodeSent extends OtpRequest {
  const OtpCodeSent(this.verificationId);

  final String verificationId;
}

/// Android a validé le numéro tout seul (auto-retrieval) : l'utilisateur
/// est déjà connecté, pas de code à saisir.
class OtpAutoVerified extends OtpRequest {
  const OtpAutoVerified(this.user);

  final User user;
}

/// Le contrat d'authentification. La presentation ne connaît que cette
/// interface — Firebase et l'API Laravel vivent derrière, dans data/.
abstract interface class AuthRepository {
  /// Envoie un OTP au numéro (+221...). Lève une AppException en français
  /// en cas d'échec (numéro invalide, pas de réseau, trop d'essais).
  Future<OtpRequest> sendOtp(String phone);

  /// Vérifie le code saisi, échange l'ID token Firebase contre un token
  /// Sanctum (une seule fois — ensuite tout passe par le Bearer Sanctum),
  /// le stocke, et renvoie l'utilisateur.
  Future<User> verifyOtp({
    required String verificationId,
    required String code,
  });
}
