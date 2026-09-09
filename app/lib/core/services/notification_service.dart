import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../network/api_client.dart';
import '../network/token_storage.dart';
import '../../app/router.dart';

/// Gestion FCM côté app :
///   - refresh token → POST /api/me/fcm-token
///   - foreground  → SnackBar
///   - background/terminé → deep link au tap
///
/// Android uniquement. iOS : pas de config, pas de permission demandée.
class NotificationService {
  NotificationService(this._dio, this._tokens);

  final Dio _dio;
  final TokenStorage _tokens;

  /// À appeler dans main() après initFirebase(), avec la clé du Navigator
  /// racine (le contexte du router).
  Future<void> init(GlobalKey<NavigatorState> navigatorKey) async {
    final messaging = FirebaseMessaging.instance;

    // Android 13+ : demande de permission explicite.
    await messaging.requestPermission(alert: true, badge: false, sound: true);

    // Token initial → API
    final token = await messaging.getToken();
    if (token != null) await _sendToken(token);

    // Refresh → API
    messaging.onTokenRefresh.listen(_sendToken);

    // NB : si l'utilisateur n'est pas encore connecté ici, `_sendToken` a
    // abandonné. Le token part alors via `registerToken()`, appelé juste
    // après un login réussi (cf AuthController).

    // App au premier plan : SnackBar discret.
    FirebaseMessaging.onMessage.listen((message) {
      final context = navigatorKey.currentContext;
      if (context == null || !context.mounted) return;
      final title = message.notification?.title ?? '';
      final body = message.notification?.body ?? '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title — $body'),
          duration: const Duration(seconds: 4),
        ),
      );
    });

    // Tap sur notif quand l'app était en arrière-plan.
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) => _handleTap(navigatorKey, message),
    );

    // Tap sur notif quand l'app était complètement fermée (démarrage à froid).
    final initial = await messaging.getInitialMessage();
    if (initial != null) _handleTap(navigatorKey, initial);
  }

  /// Route vers l'écran lié à la notif tapée. Au réveil ou au démarrage à
  /// froid, le Navigator racine n'est pas encore attaché quand l'événement
  /// arrive — on réessaie brièvement plutôt que d'abandonner en silence.
  Future<void> _handleTap(
    GlobalKey<NavigatorState> key,
    RemoteMessage message,
  ) async {
    final route = _routeFor(message.data['type']);
    developer.log(
      'notif tapée : type=${message.data['type']} → route=$route',
      name: 'fcm',
    );
    if (route == null) return;

    for (var attempt = 0; attempt < 25; attempt++) {
      final context = key.currentContext;
      if (context != null && context.mounted) {
        context.goNamed(route);
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    developer.log('notif tapée : Navigator jamais prêt, navigation abandonnée',
        name: 'fcm');
  }

  static String? _routeFor(Object? type) => switch (type) {
        'booking_requested' => AppRoute.tripRequests,
        'booking_accepted' || 'booking_rejected' => AppRoute.bookings,
        _ => null,
      };

  /// Pousse le token FCM courant à l'API. À appeler après un login réussi :
  /// `init()` tourne au démarrage de l'app, avant qu'une session Sanctum
  /// existe, donc l'envoi initial y est perdu au tout premier login.
  Future<void> registerToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) await _sendToken(token);
  }

  Future<void> _sendToken(String token) async {
    // Pas de token Sanctum → pas connecté, on ne fait rien.
    if (await _tokens.read() == null) return;
    try {
      await _dio.post<void>('/me/fcm-token', data: {'fcm_token': token});
    } catch (_) {
      // Erreur réseau tolérée : le prochain refresh réessaiera.
    }
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
    ref.watch(dioProvider),
    ref.watch(tokenStorageProvider),
  );
});
