import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../domain/user.dart';

/// L'utilisateur connecté. Les écrans profil lisent cet état ; les mutations
/// lèvent une AppException (message français) que l'écran affiche.
class ProfileController extends AsyncNotifier<User> {
  @override
  Future<User> build() => ref.read(profileRepositoryProvider).getMe();

  /// Enregistre le profil, puis la photo si fournie. Lève une AppException
  /// en cas d'échec — l'état n'est mis à jour qu'en cas de succès.
  Future<void> saveProfile({
    required String firstName,
    required String lastName,
    required String role,
    String? photoPath,
  }) async {
    final repository = ref.read(profileRepositoryProvider);

    var user = await repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      role: role,
    );
    if (photoPath != null) {
      user = await repository.uploadPhoto(photoPath);
    }

    state = AsyncData(user);
  }
}

final profileControllerProvider =
    AsyncNotifierProvider<ProfileController, User>(ProfileController.new);
