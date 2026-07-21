import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
import '../core/network/token_storage.dart';
import '../features/auth/data/auth_api.dart';
import '../features/auth/data/auth_repository_impl.dart';
import '../features/auth/domain/auth_repository.dart';
import '../features/profile/data/profile_api.dart';
import '../features/profile/data/profile_repository_impl.dart';
import '../features/profile/domain/profile_repository.dart';

/// Composition root : le SEUL endroit qui connaît à la fois les interfaces
/// domain et leurs implémentations data. Les controllers n'injectent que
/// les interfaces exposées ici.
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    FirebaseAuth.instance,
    AuthApi(ref.watch(dioProvider)),
    ref.watch(tokenStorageProvider),
  );
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ProfileApi(ref.watch(dioProvider)));
});
