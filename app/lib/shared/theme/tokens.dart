import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Source de vérité du design system — direction B « Affirmé ».
/// Spécifié dans docs/03-design-brief.md §2. Aucune valeur visuelle n'existe
/// en dehors de ce fichier.
abstract final class AppColors {
  // ── Primaire — vert profond. Distinct de Wave (bleu) et Orange Money (orange).
  static const primary = Color(0xFF05301C); // CTA, texte fort, avatars. 14,5:1 en blanc dessus.
  static const primaryVivid = Color(0xFF00B368); // ACCENT SEULEMENT : points, pastilles, états actifs.
  // ⚠️ JAMAIS de texte blanc dessus (2,7:1 — illisible au soleil).
  static const primaryMint = Color(0xFF6EE7A8); // texte/icônes SUR primary (9,4:1)
  static const primarySurface = Color(0xFFF4F7F5); // panneaux, fonds de section

  // ── Neutres — TEINTÉS VERT, jamais gris pur. C'est ce qui fait la cohérence.
  static const ink = Color(0xFF05301C); // texte principal (= primary, volontairement)
  static const inkMuted = Color(0xFF7A8B82); // texte secondaire, labels
  static const line = Color(0xFFD3DED8); // bordures, séparateurs
  static const surface = Color(0xFFFFFFFF); // cartes
  static const background = Color(0xFFEFF1F0); // fond d'écran

  // ── Sémantiques
  static const success = Color(0xFF00B368); // accepté, confirmé
  static const warning = Color(0xFFF2A900); // prix hors fourchette, étoiles
  static const danger = Color(0xFFD92D20); // refus, annulation
}

abstract final class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;
}

abstract final class AppRadius {
  static const sm = 10.0; // pastilles, petits éléments
  static const md = 14.0; // boutons, champs, panneaux internes
  static const lg = 22.0; // cartes — le geste signature de la direction B
  static const full = 999.0;
}

/// Plus Jakarta Sans via google_fonts. Poids 500/700/800 uniquement — jamais de light.
/// L'échelle est VOLONTAIREMENT très contrastée : c'est elle qui porte la hiérarchie.
/// Chiffres en tabular-nums partout — sinon les colonnes dansent d'une carte à l'autre.
abstract final class AppText {
  static final display = _jakarta(34, FontWeight.w800, 1.0, -1.0); // LE PRIX
  static final h1 = _jakarta(24, FontWeight.w800, 1.2, -0.5);
  static final h2 = _jakarta(17, FontWeight.w700, 1.35, -0.2);
  static final body = _jakarta(15, FontWeight.w500, 1.5);
  static final bodySm = _jakarta(13, FontWeight.w500, 1.45);
  static final caption = _jakarta(12, FontWeight.w600, 1.4);
  static final label = _jakarta(10, FontWeight.w700, 1.3, 0.9); // UPPERCASE

  static TextStyle _jakarta(
    double size,
    FontWeight weight,
    double height, [
    double? letterSpacing,
  ]) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: AppColors.ink,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
