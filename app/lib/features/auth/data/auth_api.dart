import 'package:dio/dio.dart';

import '../../profile/domain/user.dart';

/// Les appels dio bruts de l'auth, rien d'autre.
class AuthApi {
  const AuthApi(this._dio);

  final Dio _dio;

  /// POST /api/auth/firebase — échange l'ID token Firebase contre un token
  /// Sanctum. Le seul appel qui transporte un jeton Firebase.
  Future<({String token, User user})> loginWithFirebaseToken(
    String idToken,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/firebase',
      data: {'id_token': idToken},
    );

    final data = response.data!;
    return (
      token: data['token'] as String,
      user: User.fromJson(data['user'] as Map<String, dynamic>),
    );
  }
}
