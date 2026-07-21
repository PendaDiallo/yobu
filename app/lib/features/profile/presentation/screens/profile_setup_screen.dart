import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/tokens.dart';
import 'profile_form.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              Text('Fais connaissance', style: AppText.h1),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Ton nom et ta photo rassurent ceux qui partageront ta route.',
                style: AppText.body.copyWith(color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: ProfileForm(
                  ctaLabel: 'C\'est parti',
                  onSaved: () => context.goNamed(AppRoute.home),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
