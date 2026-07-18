import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'yobu_button.dart';

/// Illustration + message + CTA optionnel. Utilisé pour tous les états vides
/// (aucun résultat, aucune réservation, aucun trajet publié…).
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.ctaLabel,
    this.onCta,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? ctaLabel;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    final message = this.message;
    final ctaLabel = this.ctaLabel;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSpacing.xxl * 2,
              height: AppSpacing.xxl * 2,
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: AppSpacing.xl + AppSpacing.sm,
                  color: AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: AppText.h2, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: AppText.body.copyWith(color: AppColors.inkMuted),
                textAlign: TextAlign.center,
              ),
            ],
            if (ctaLabel != null) ...[
              const SizedBox(height: AppSpacing.lg),
              YobuButton(label: ctaLabel, onPressed: onCta, expanded: false),
            ],
          ],
        ),
      ),
    );
  }
}
