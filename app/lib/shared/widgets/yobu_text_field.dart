import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';

/// Champ de saisie du design system : label au-dessus, erreur en dessous,
/// suffixe optionnel.
class YobuTextField extends StatelessWidget {
  const YobuTextField({
    super.key,
    required this.label,
    this.hint,
    this.errorText,
    this.suffix,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.onChanged,
    this.prefixText,
    this.inputFormatters,
    this.autofocus = false,
  });

  final String label;
  final String? hint;
  final String? errorText;
  final Widget? suffix;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  /// Préfixe non éditable, ex. « +221 ».
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: AppText.label.copyWith(color: AppColors.inkMuted),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          style: AppText.body,
          decoration: InputDecoration(
            prefixText: prefixText,
            prefixStyle: AppText.body.copyWith(fontWeight: FontWeight.w700),
            hintText: hint,
            hintStyle: AppText.body.copyWith(color: AppColors.inkMuted),
            errorText: errorText,
            errorStyle: AppText.caption.copyWith(color: AppColors.danger),
            suffixIcon: suffix,
            filled: true,
            fillColor: enabled ? AppColors.surface : AppColors.primarySurface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            enabledBorder: _border(AppColors.line),
            focusedBorder: _border(AppColors.primary, 1.5),
            errorBorder: _border(AppColors.danger),
            focusedErrorBorder: _border(AppColors.danger, 1.5),
            disabledBorder: _border(AppColors.line),
          ),
        ),
      ],
    );
  }
}
