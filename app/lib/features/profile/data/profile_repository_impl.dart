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
    } catch (error) {
      throw AppException.fromDio(error);
    }
  }
}
