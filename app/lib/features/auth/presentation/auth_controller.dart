import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di.dart';
import '../../../core/errors/app_exception.dart';
import '../../profile/domain/user.dart';
import '../domain/auth_repository.dart';

enum AuthStep { idle, codeSent, authenticated }

class AuthFlowState {
  const AuthFlowState({
    this.step = AuthStep.idle,
    this.phone = '',
    this.verificationId = '',
    this.user,
    this.loading = false,
    this.error,
  });

  final AuthStep step;

  /// Au format E.164 : +2217XXXXXXXX.
  final String phone;
  final String verificationId;
  final User? user;
  final bool loading;
  final String? error;
}

class AuthController extends Notifier<AuthFlowState> {
  @override
  AuthFlowState build() => const AuthFlowState();

  /// [localNumber] : les 9 chiffres saisis, sans indicatif.
  Future<void> sendOtp(String localNumber) async {
    await _requestOtp('+221$localNumber');
  }

  Future<void> resendOtp() async {
    await _requestOtp(state.phone);
  }

  Future<void> _requestOtp(String phone) async {
    state = AuthFlowState(step: state.step, phone: phone, loading: true);
    try {
      final result = await ref.read(authRepositoryProvider).sendOtp(phone);
      state = switch (result) {
        OtpCodeSent(:final verificationId) => AuthFlowState(
            step: AuthStep.codeSent,
            phone: phone,
            verificationId: verificationId,
          ),
        OtpAutoVerified(:final user) => AuthFlowState(
            step: AuthStep.authenticated,
            phone: phone,
            user: user,
          ),
      };
    } on AppException catch (exception) {
      state = AuthFlowState(
        step: state.step,
        phone: phone,
        error: exception.message,
      );
    }
  }

  Future<void> verifyCode(String code) async {
    final phone = state.phone;
    final verificationId = state.verificationId;
    state = AuthFlowState(
      step: AuthStep.codeSent,
      phone: phone,
      verificationId: verificationId,
      loading: true,
    );
    try {
      final user = await ref
          .read(authRepositoryProvider)
          .verifyOtp(verificationId: verificationId, code: code);
      state = AuthFlowState(
        step: AuthStep.authenticated,
        phone: phone,
        user: user,
      );
    } on AppException catch (exception) {
      state = AuthFlowState(
        step: AuthStep.codeSent,
        phone: phone,
        verificationId: verificationId,
        error: exception.message,
      );
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AuthFlowState>(AuthController.new);
