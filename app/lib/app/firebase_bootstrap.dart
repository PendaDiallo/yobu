import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../core/env.dart';
import '../firebase_options.dart';

/// Firebase, réduit à deux usages : Auth téléphone et FCM.
///
/// Le plugin google-services initialise déjà l'app [DEFAULT] au démarrage
/// Android (options du projet yobu-594f7) — on ne ré-initialise que si
/// nécessaire, sinon [core/duplicate-app].
///
/// En dev (`--dart-define=USE_FIREBASE_EMULATOR=true`), l'Auth est branchée
/// sur l'émulateur local : aucun SMS, aucun coût. Même project id que le
/// réel — seule la destination change.
Future<void> initFirebase() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  if (Env.useFirebaseEmulator) {
    await FirebaseAuth.instance.useAuthEmulator(Env.firebaseEmulatorHost, 9099);
  }
}
