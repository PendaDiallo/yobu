import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// Un tag rapide sélectionnable (écran `rating`). Sélectionné = vert vif +
/// texte vert profond (jamais de blanc sur vert vif).
class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryVivid : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: selected ? null : Border.all(color: AppColors.line),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppText.bodySm.copyWith(
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.primary : AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
