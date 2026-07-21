import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/user_card.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../domain/user.dart';
import '../profile_controller.dart';

/// Les codes badges de l'API (docs/02-technique.md §4ter), traduits pour
/// l'affichage. Pas une règle métier : juste de la traduction.
const _badgeLabels = {
  'phone_verified': 'Vérifié',
  'regular': 'Régulier',
};

class ProfileViewScreen extends ConsumerWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil')),
      body: SafeArea(
        child: profile.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text(
              '$error',
              style: AppText.body.copyWith(color: AppColors.danger),
              textAlign: TextAlign.center,
            ),
          ),
          data: (user) => _ProfileBody(user: user),
        ),
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserCard(
            name: '${user.firstName} ${user.lastName}'.trim(),
            initials: _initials,
            photoUrl: user.photoUrl,
            verified: user.badges.contains('phone_verified'),
            rating: user.rating,
            ratingLabel: user.ratingCount > 0
                ? user.rating.toStringAsFixed(1).replaceAll('.', ',')
                : null,
            tripsLabel: user.tripsCompleted <= 1
                ? '${user.tripsCompleted} trajet'
                : '${user.tripsCompleted} trajets',
            badges: [
              for (final badge in user.badges)
                if (_badgeLabels[badge] != null) _badgeLabels[badge]!,
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                const Icon(Icons.phone_outlined,
                    size: AppSpacing.lg, color: AppColors.inkMuted),
                const SizedBox(width: AppSpacing.sm),
                Text(user.phone, style: AppText.body),
              ],
            ),
          ),
          const Spacer(),
          YobuButton(
            label: 'Modifier mon profil',
            variant: YobuButtonVariant.secondary,
            onPressed: () => context.pushNamed(AppRoute.profileEdit),
          ),
        ],
      ),
    );
  }

  String get _initials => [user.firstName, user.lastName]
      .map((part) => part.isNotEmpty ? part[0] : '')
      .join();
}
