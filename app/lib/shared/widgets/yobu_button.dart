import 'package:flutter/material.dart';

import '../theme/tokens.dart';

enum YobuButtonVariant { primary, secondary, ghost, danger }

/// Le bouton du design system.
///
/// Le CTA principal d'un écran : variant `primary`, en bas, pleine largeur —
/// fond vert profond, texte blanc, 56 de haut. Jamais de texte blanc sur le
/// vert vif (docs/03-design-brief.md §1).
class YobuButton extends StatelessWidget {
  const YobuButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = YobuButtonVariant.primary,
    this.loading = false,
    this.expanded = true,
  });

  final String label;

  /// `null` = désactivé.
  final VoidCallback? onPressed;
  final YobuButtonVariant variant;
  final bool loading;
  final bool expanded;

  static const _height = 56.0;

  bool get _disabled => onPressed == null;

  Color get _background {
    if (_disabled && !loading) {
      return switch (variant) {
        YobuButtonVariant.primary ||
        YobuButtonVariant.danger =>
          AppColors.line,
        YobuButtonVariant.secondary => AppColors.primarySurface,
        YobuButtonVariant.ghost => Colors.transparent,
      };
    }
    return switch (variant) {
      YobuButtonVariant.primary => AppColors.primary,
      YobuButtonVariant.secondary => AppColors.primarySurface,
      YobuButtonVariant.ghost => Colors.transparent,
      YobuButtonVariant.danger => AppColors.danger,
    };
  }

  Color get _foreground {
    if (_disabled && !loading) return AppColors.inkMuted;
    return switch (variant) {
      YobuButtonVariant.primary ||
      YobuButtonVariant.danger =>
        AppColors.surface,
      YobuButtonVariant.secondary || YobuButtonVariant.ghost => AppColors.ink,
    };
  }

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? SizedBox(
            width: AppSpacing.lg,
            height: AppSpacing.lg,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(_foreground),
            ),
          )
        : Text(label, style: AppText.h2.copyWith(color: _foreground));

    return SizedBox(
      height: _height,
      width: expanded ? double.infinity : null,
      child: Material(
        color: _background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: variant == YobuButtonVariant.secondary
              ? const BorderSide(color: AppColors.line)
              : BorderSide.none,
        ),
        child: InkWell(
          onTap: loading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
