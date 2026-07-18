import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'star_rating.dart';
import 'yobu_avatar.dart';

/// Fiche compacte d'un utilisateur : avatar + nom + note en lecture +
/// nb de trajets + badges. Les libellés (badges, « x trajets ») arrivent
/// déjà formatés — aucune règle métier ici.
class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
    required this.name,
    required this.initials,
    required this.rating,
    required this.tripsLabel,
    this.ratingLabel,
    this.photoUrl,
    this.verified = false,
    this.badges = const [],
    this.onTap,
  });

  final String name;
  final String initials;

  /// De 0 à 5. `0` avec `ratingLabel` null = « Nouveau ».
  final double rating;

  /// Ex. « 4,8 » — déjà formaté par l'API.
  final String? ratingLabel;

  /// Ex. « 132 trajets ».
  final String tripsLabel;
  final String? photoUrl;
  final bool verified;

  /// Libellés déjà traduits, ex. ["Vérifié", "Régulier"].
  final List<String> badges;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ratingLabel = this.ratingLabel;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              YobuAvatar(
                initials: initials,
                photoUrl: photoUrl,
                verified: verified,
                size: AppSpacing.xxl,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: AppText.h2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        StarRating(value: rating),
                        if (ratingLabel != null) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Text(ratingLabel,
                              style: AppText.caption
                                  .copyWith(fontWeight: FontWeight.w700)),
                        ],
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '· $tripsLabel',
                          style: AppText.bodySm
                              .copyWith(color: AppColors.inkMuted),
                        ),
                      ],
                    ),
                    if (badges.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xs,
                        children: [
                          for (final badge in badges) _BadgeChip(label: badge),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BadgeChip extends StatelessWidget {
  const _BadgeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primaryVivid,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label,
              style: AppText.caption.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
