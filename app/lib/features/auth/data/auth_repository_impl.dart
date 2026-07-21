import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../../core/errors/app_exception.dart';
import '../../../core/network/token_storage.dart';
import '../../profile/domain/user.dart';
import '../domain/auth_repository.dart';
import 'auth_api.dart';

/// Orchestration du flux docs/02-technique.md §2 :
/// Firebase (OTP) → ID token → API Laravel → token Sanctum stocké.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._firebaseAuth, this._api, this._tokens);

  final firebase.FirebaseAuth _firebaseAuth;
  final AuthApi _api;
  final TokenStorage _tokens;

  @override
  Future<OtpRequest> sendOtp(String phone) {
    final completer = Completer<OtpRequest>();

    _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) async {
        try {
          final user = await _signInAndExchange(credential);
          if (!completer.isCompleted) {
            completer.complete(OtpAutoVerified(user));
          }
        } catch (error) {
          if (!completer.isCompleted) {
            completer.completeError(_translate(error));
          }
        }
      },
      verificationFailed: (error) {
        if (!completer.isCompleted) {
          completer.completeError(_translate(error));
        }
      },
      codeSent: (verificationId, _) {
        if (!completer.isCompleted) {
          completer.complete(OtpCodeSent(verificationId));
        }
      },
      codeAutoRetrievalTimeout: (_) {},
    );

    return completer.future;
  }

  @override
  Future<User> verifyOtp({
    required String verificationId,
    required String code,
  }) async {
    try {
      return await _signInAndExchange(
        firebase.PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: code,
        ),
      );
    } catch (error) {
      throw _translate(error);
    }
  }

  /// Le token Firebase ne sert QU'ICI, une fois. Ensuite, Sanctum.
  Future<User> _signInAndExchange(firebase.AuthCredential credential) async {
    final firebaseUser =
        (await _firebaseAuth.signInWithCredential(credential)).user!;
    final idToken = (await firebaseUser.getIdToken())!;

    final login = await _api.loginWithFirebaseToken(idToken);
    await _tokens.write(login.token);

    return login.user;
  }

  AppException _translate(Object error) {
    if (error is AppException) return error;

    if (error is firebase.FirebaseAuthException) {
      return AppException(switch (error.code) {
        'invalid-phone-number' => 'Ce numéro n\'est pas valide.',
        'invalid-verification-code' =>
          'Code incorrect. Vérifie et réessaie.',
        'session-expired' => 'Le code a expiré. Renvoie un nouveau code.',
        'too-many-requests' =>
          'Trop d\'essais. Attends quelques minutes avant de réessayer.',
        'network-request-failed' =>
          'Pas de connexion. Vérifie ton réseau et réessaie.',
        _ => 'Une erreur est survenue. Réessaie.',
      });
    }

    if (error is DioException) {
      return const AppException(
        'Impossible de joindre le serveur. Vérifie ta connexion et réessaie.',
      );
    }

    return const AppException('Une erreur est survenue. Réessaie.');
  }
}
