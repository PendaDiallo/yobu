/// Configuration d'environnement, injectée à la compilation via --dart-define.
///
/// Sur émulateur Android, la machine hôte est `10.0.2.2` — jamais `localhost`,
/// que l'émulateur résout vers lui-même.
///
/// Exemples :
///   flutter run                                          → API locale (émulateur)
///   flutter run --dart-define=API_URL=http://192.168.1.10:8000  → vrai téléphone en Wi-Fi
///   flutter run --dart-define=API_URL=https://api.yobu.sn        → prod
abstract final class Env {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// Activé en dev pour brancher Firebase Auth sur l'émulateur local
  /// (aucun SMS envoyé, aucun coût). Utilisé à partir du J4.
  static const bool useFirebaseEmulator =
      bool.fromEnvironment('USE_FIREBASE_EMULATOR');
}
