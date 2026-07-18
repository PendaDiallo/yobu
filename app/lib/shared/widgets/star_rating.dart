import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// 1-5 étoiles, couleur warning (docs/03-design-brief.md §2).
///
/// Deux modes :
/// - **lecture** (`onChanged` null) : petites étoiles, demi-étoiles gérées —
///   dans `UserCard` et `TripCard` dès le J5 ;
/// - **saisie** (`onChanged` fourni) : grandes étoiles, cible tactile 48 —
///   écran `rating` au J14.
class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    required this.value,
    this.onChanged,
    double? size,
  }) : size = size ?? (onChanged == null ? 16 : 40);

  /// De 0 à 5.
  final double value;
  final ValueChanged<int>? onChanged;
  final double size;

  bool get _editable => onChanged != null;

  Widget _star(int index) {
    final position = index + 1;
    final IconData icon;
    if (value >= position - 0.25) {
      icon = Icons.star_rounded;
    } else if (value >= position - 0.75) {
      icon = Icons.star_half_rounded;
    } else {
      icon = Icons.star_outline_rounded;
    }
    final filled = icon != Icons.star_outline_rounded;
    final star = Icon(
      icon,
      size: size,
      color: filled ? AppColors.warning : AppColors.line,
    );

    if (!_editable) return star;
    return InkWell(
      onTap: () => onChanged!(position),
      customBorder: const CircleBorder(),
      child: Padding(
        // Porte la cible tactile à 48 minimum quel que soit `size`.
        padding: EdgeInsets.all(((48 - size) / 2).clamp(0, 48).toDouble()),
        child: star,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [for (var i = 0; i < 5; i++) _star(i)],
    );
  }
}
