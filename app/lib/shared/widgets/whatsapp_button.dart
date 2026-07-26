import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/tokens.dart';

/// « Écrire sur WhatsApp » — LE canal de contact de YOBU (pas de chat
/// intégré, docs/01-produit.md §2). N'apparaît qu'une fois la réservation
/// acceptée : avant, l'API ne renvoie pas le numéro.
class WhatsAppButton extends StatelessWidget {
  const WhatsAppButton({
    super.key,
    required this.phone,
    this.label = 'Écrire sur WhatsApp',
  });

  /// Au format E.164 (+221...), tel que renvoyé par l'API.
  final String phone;
  final String label;

  Future<void> _open() {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');

    return launchUrl(
      Uri.parse('https://wa.me/$digits'),
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.xxl + AppSpacing.sm,
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.line),
        ),
        child: InkWell(
          onTap: _open,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.chat_rounded,
                    size: AppSpacing.lg, color: AppColors.success),
                const SizedBox(width: AppSpacing.sm),
                Text(label,
                    style: AppText.h2.copyWith(color: AppColors.ink)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
