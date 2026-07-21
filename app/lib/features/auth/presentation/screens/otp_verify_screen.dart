import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../auth_controller.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  static const _codeLength = 6;
  static const _resendDelay = 60;

  final _code = TextEditingController();
  final _focus = FocusNode();
  Timer? _timer;
  int _secondsLeft = _resendDelay;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _code.addListener(() {
      setState(() {});
      if (_code.text.length == _codeLength) {
        _verify();
      }
    });
  }

  /// Navigation impérative, liée à l'action — pas de ref.listen : deux
  /// écrans montés qui écoutent le même état navigueraient en double.
  Future<void> _verify() async {
    await ref.read(authControllerProvider.notifier).verifyCode(_code.text);
    if (!mounted) return;

    final auth = ref.read(authControllerProvider);
    if (auth.step == AuthStep.authenticated) {
      final user = auth.user!;
      context.goNamed(
        user.firstName.isEmpty ? AppRoute.profileSetup : AppRoute.home,
      );
    } else if (auth.error != null) {
      _code.clear();
      _focus.requestFocus();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendDelay);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _resend() {
    _code.clear();
    ref.read(authControllerProvider.notifier).resendOtp();
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Le code reçu', style: AppText.h1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Envoyé par SMS au ${auth.phone}.',
                style: AppText.body.copyWith(color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.xl),
              _SegmentedCode(
                controller: _code,
                focusNode: _focus,
                length: _codeLength,
                hasError: auth.error != null,
              ),
              if (auth.error != null) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  auth.error!,
                  style: AppText.caption.copyWith(color: AppColors.danger),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              Center(
                child: YobuButton(
                  label: _secondsLeft > 0
                      ? 'Renvoyer le code (${_secondsLeft}s)'
                      : 'Renvoyer le code',
                  variant: YobuButtonVariant.ghost,
                  expanded: false,
                  onPressed: _secondsLeft > 0 ? null : _resend,
                ),
              ),
              const Spacer(),
              YobuButton(
                label: 'Valider',
                loading: auth.loading,
                onPressed:
                    _code.text.length == _codeLength ? _verify : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Champ OTP segmenté — l'une des trois exceptions natives assumées du design
/// system (docs/03-design-brief.md §3) : un TextField invisible pilote
/// 6 cases d'affichage.
class _SegmentedCode extends StatelessWidget {
  const _SegmentedCode({
    required this.controller,
    required this.focusNode,
    required this.length,
    required this.hasError,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Le vrai champ, invisible mais focusable.
        Opacity(
          opacity: 0,
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            autofocus: true,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(length),
            ],
          ),
        ),
        GestureDetector(
          onTap: focusNode.requestFocus,
          child: Row(
            children: [
              for (var i = 0; i < length; i++) ...[
                if (i > 0) const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Container(
                    height: AppSpacing.xxl + AppSpacing.sm,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: hasError
                            ? AppColors.danger
                            : i == controller.text.length
                                ? AppColors.primary
                                : AppColors.line,
                        width: i == controller.text.length ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      i < controller.text.length ? controller.text[i] : '',
                      style: AppText.h1,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
