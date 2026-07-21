import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import '../domain/profile_repository.dart';
import '../domain/user.dart';
import 'profile_api.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._api);

  final ProfileApi _api;

  @override
  Future<User> getMe() => _guard(() async => User.fromJson(await _api.getMe()));

  @override
  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? role,
  }) {
    return _guard(() async {
      final body = {
        'first_name': ?firstName,
        'last_name': ?lastName,
        'role': ?role,
      };

      return User.fromJson(await _api.updateMe(body));
    });
  }

  @override
  Future<User> uploadPhoto(String filePath) {
    return _guard(
      () async => User.fromJson(await _api.uploadPhoto(filePath)),
    );
  }

  Future<User> _guard(Future<User> Function() run) async {
    try {
      return await run();
    } on DioException catch (error) {
      throw _translate(error);
    }
  }

  AppException _translate(DioException error) {
    // Le premier message d'erreur de validation Laravel est déjà en français.
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      final errors = data['errors'];
      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) {
          return AppException(first.first as String);
        }
      }
    }

    return const AppException(
      'Impossible de joindre le serveur. Vérifie ta connexion et réessaie.',
    );
  }
}
