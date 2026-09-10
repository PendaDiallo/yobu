import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../env.dart';
import 'token_storage.dart';

/// Le seul point d'entrée HTTP de l'app. Aucun appel réseau en dehors
/// de data/api/ — les repositories consomment ce Dio via Riverpod.
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: '${Env.apiUrl}/api',
      headers: {'Accept': 'application/json'},
    ),
  );

  final tokens = ref.watch(tokenStorageProvider);
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await tokens.read();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        // Token Sanctum révoqué ou expiré : on nettoie et on renvoie à
        // l'accueil plutôt que de laisser un « serveur injoignable » trompeur.
        if (error.response?.statusCode == 401 && await tokens.read() != null) {
          await tokens.clear();
          final context = navigatorKey.currentContext;
          if (context != null && context.mounted) {
            context.goNamed(AppRoute.welcome);
          }
        }
        handler.next(error);
      },
    ),
  );

  return dio;
});
