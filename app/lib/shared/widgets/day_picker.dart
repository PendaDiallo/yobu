import 'package:flutter/material.dart';

import '../theme/tokens.dart';

/// L M M J V S D en pastilles. Jour sélectionné = pastille vert vif avec
/// texte vert profond (5,3:1 — le blanc sur vert vif est interdit).
///
/// `onChanged` null = lecture seule (affichage des jours d'un trajet).
class DayPicker extends StatelessWidget {
  const DayPicker({
    super.key,
    required this.selected,
    this.onChanged,
  });

  /// Jours ISO : 1 = lundi … 7 = dimanche. Même convention que
  /// `trips.days_of_week` côté API.
  final Set<int> selected;
  final ValueChanged<Set<int>>? onChanged;

  static const _labels = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var day = 1; day <= 7; day++) ...[
          if (day > 1) const SizedBox(width: AppSpacing.xs),
          Expanded(child: _DayDot(
            label: _labels[day - 1],
            active: selected.contains(day),
            onTap: onChanged == null
                ? null
                : () {
                    final next = Set<int>.from(selected);
                    next.contains(day) ? next.remove(day) : next.add(day);
                    onChanged!(next);
                  },
          )),
        ],
      ],
    );
  }
}

class _DayDot extends StatelessWidget {
  const _DayDot({required this.label, required this.active, this.onTap});

  final String label;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dot = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      height: AppSpacing.xxl,
      decoration: BoxDecoration(
        color: active ? AppColors.primaryVivid : AppColors.surface,
        shape: BoxShape.circle,
        border: active ? null : Border.all(color: AppColors.line),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppText.body.copyWith(
          fontWeight: FontWeight.w800,
          color: active ? AppColors.primary : AppColors.inkMuted,
        ),
      ),
    );

    if (onTap == null) return dot;
    return GestureDetector(onTap: onTap, child: dot);
  }
}
