import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ),
  );

  return dio;
});
