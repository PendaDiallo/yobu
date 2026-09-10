import 'package:dio/dio.dart';

/// Erreur applicative avec un message déjà en français, prêt à afficher.
/// Les couches data traduisent les erreurs techniques (Firebase, réseau)
/// en AppException ; l'UI ne voit jamais un code d'erreur brut.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  /// Traduit une erreur `dio` (ou une AppException déjà prête) en message
  /// français affichable. Ordre :
  ///   1. AppException déjà construite → telle quelle
  ///   2. 1re erreur de validation Laravel (`errors`) — déjà en français
  ///   3. `message` de l'API (403, 409, règles métier) — déjà en français
  ///   4. [fallback] (défaut : problème réseau)
  ///   5. tout le reste (parsing, inattendu) → message générique
  factory AppException.fromDio(
    Object error, {
    String fallback =
        'Impossible de joindre le serveur. Vérifie ta connexion et réessaie.',
  }) {
    if (error is AppException) return error;

    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final first = errors.values.first;
          if (first is List && first.isNotEmpty) {
            return AppException('${first.first}');
          }
        }
        final message = data['message'];
        if (message is String && message.isNotEmpty) {
          return AppException(message);
        }
      }

      return AppException(fallback);
    }

    return const AppException('Une erreur est survenue. Réessaie.');
  }

  @override
  String toString() => message;
}
