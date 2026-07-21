/// Erreur applicative avec un message déjà en français, prêt à afficher.
/// Les couches data traduisent les erreurs techniques (Firebase, réseau)
/// en AppException ; l'UI ne voit jamais un code d'erreur brut.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}
