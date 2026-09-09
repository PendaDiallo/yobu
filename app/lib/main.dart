import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/firebase_bootstrap.dart';
import 'app/router.dart';
import 'core/services/notification_service.dart';

/// Isolat séparé, réveillé par Android quand un message FCM arrive alors que
/// l'app est en arrière-plan ou complètement fermée. La notification de la
/// barre système est affichée par le système lui-même (le message porte un
/// bloc `notification`) — on n'a rien à faire ici, mais le handler doit
/// exister : sans lui, `firebase_messaging` émet un avertissement et le
/// contrat de réveil n'est pas complet. Le deep link au tap est géré par
/// `NotificationService` via `getInitialMessage` / `onMessageOpenedApp`.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initFirebase();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Le container bootstrap permet d'injecter NotificationService (Riverpod)
  // avant que l'arbre de widgets existe.
  final container = ProviderContainer();
  await container
      .read(notificationServiceProvider)
      .init(navigatorKey);

  runApp(UncontrolledProviderScope(container: container, child: const YobuApp()));
}
