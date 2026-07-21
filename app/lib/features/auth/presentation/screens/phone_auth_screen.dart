import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../../../shared/widgets/yobu_text_field.dart';
import '../auth_controller.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _phone = TextEditingController();
  String? _localError;

  @override
  void dispose() {
    _phone.dispose();
    super.dispose();
  }

  /// Mobile sénégalais : 9 chiffres, 70/75/76/77/78.
  bool get _isValid => RegExp(r'^7[05678]\d{7}$').hasMatch(_phone.text);

  /// La navigation est liée à l'action, pas aux transitions de l'état
  /// global — resoumettre après un retour arrière re-navigue toujours.
  Future<void> _submit() async {
    if (!_isValid) {
      setState(() {
        _localError = 'Entre un numéro valide : 7X XXX XX XX.';
      });
      return;
    }
    setState(() => _localError = null);

    await ref.read(authControllerProvider.notifier).sendOtp(_phone.text);
    if (!mounted) return;

    final auth = ref.read(authControllerProvider);
    if (auth.error != null) return; // affiché sous le champ via watch

    switch (auth.step) {
      case AuthStep.codeSent:
        context.pushNamed(AppRoute.otpVerify);
      case AuthStep.authenticated:
        final user = auth.user!;
        context.goNamed(
          user.firstName.isEmpty ? AppRoute.profileSetup : AppRoute.home,
        );
      case AuthStep.idle:
        break;
    }
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
              Text('Ton numéro', style: AppText.h1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'On t\'envoie un code par SMS pour vérifier que c\'est bien toi.',
                style: AppText.body.copyWith(color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.xl),
              YobuTextField(
                label: 'Numéro de téléphone',
                hint: '77 123 45 67',
                prefixText: '+221 ',
                controller: _phone,
                keyboardType: TextInputType.phone,
                autofocus: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(9),
                ],
                errorText: _localError ?? auth.error,
                onChanged: (_) {
                  if (_localError != null) setState(() => _localError = null);
                },
              ),
              const Spacer(),
              YobuButton(
                label: 'Recevoir le code',
                loading: auth.loading,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
