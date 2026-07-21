import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/theme/tokens.dart';
import '../profile_controller.dart';
import 'profile_form.dart';

class ProfileEditScreen extends ConsumerWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileControllerProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('Modifier mon profil')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: user == null
              ? const Center(child: CircularProgressIndicator())
              : ProfileForm(
                  initial: user,
                  ctaLabel: 'Enregistrer',
                  onSaved: () => context.pop(),
                ),
        ),
      ),
    );
  }
}
