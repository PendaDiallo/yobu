import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/place_field.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../domain/place.dart';
import '../search_controller.dart';

/// L'écran passager : mon départ, mon arrivée, mon horaire → le matching.
/// Objectif produit : demande envoyée en moins de 2 minutes.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  Place? _origin;
  Place? _destination;
  TimeOfDay _arrivalBefore = const TimeOfDay(hour: 8, minute: 0);
  bool _tomorrow = false;

  bool get _complete => _origin != null && _destination != null;

  String get _date {
    final day = DateTime.now().add(Duration(days: _tomorrow ? 1 : 0));

    return '${day.year.toString().padLeft(4, '0')}-'
        '${day.month.toString().padLeft(2, '0')}-'
        '${day.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _arrivalBefore,
    );
    if (picked != null) setState(() => _arrivalBefore = picked);
  }

  Future<void> _search() async {
    ref.read(searchControllerProvider.notifier).search(
          origin: _origin!,
          destination: _destination!,
          arrivalBefore: _formatTime(_arrivalBefore),
          date: _date,
        );
    context.pushNamed(AppRoute.searchResults);
  }

  Future<List<PlaceSuggestion>> _searchPlaces(String query) async {
    final places = await ref.read(placesRepositoryProvider).search(query);

    return [
      for (final place in places)
        PlaceSuggestion(label: place.label, data: place),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trouver un conducteur')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            PlaceField(
              label: 'Ton départ',
              hint: 'Ex. Keur Massar, Unité 15',
              onSearch: _searchPlaces,
              onSelected: (suggestion) =>
                  setState(() => _origin = suggestion?.data as Place?),
            ),
            const SizedBox(height: AppSpacing.md),
            PlaceField(
              label: 'Ton arrivée',
              hint: 'Ex. Plateau, Sandaga',
              onSearch: _searchPlaces,
              onSelected: (suggestion) =>
                  setState(() => _destination = suggestion?.data as Place?),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ARRIVER AVANT',
                          style: AppText.label
                              .copyWith(color: AppColors.inkMuted)),
                      const SizedBox(height: AppSpacing.sm),
                      _TimeButton(
                        label: _formatTime(_arrivalBefore),
                        onTap: _pickTime,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('JOUR',
                          style: AppText.label
                              .copyWith(color: AppColors.inkMuted)),
                      const SizedBox(height: AppSpacing.sm),
                      _DayToggle(
                        tomorrow: _tomorrow,
                        onChanged: (tomorrow) =>
                            setState(() => _tomorrow = tomorrow),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            YobuButton(
              label: 'Rechercher',
              onPressed: _complete ? _search : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeButton extends StatelessWidget {
  const _TimeButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              const Icon(Icons.schedule_rounded,
                  size: AppSpacing.lg, color: AppColors.inkMuted),
              const SizedBox(width: AppSpacing.sm),
              Text(label, style: AppText.body),
            ],
          ),
        ),
      ),
    );
  }
}

/// Aujourd'hui / Demain — les deux seuls jours qu'un pendulaire cherche.
class _DayToggle extends StatelessWidget {
  const _DayToggle({required this.tomorrow, required this.onChanged});

  final bool tomorrow;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final (isTomorrow, label) in const [
          (false, 'Aujourd\'hui'),
          (true, 'Demain'),
        ]) ...[
          if (isTomorrow) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(isTomorrow),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                height: AppSpacing.xxl + AppSpacing.xs,
                decoration: BoxDecoration(
                  color: tomorrow == isTomorrow
                      ? AppColors.primaryVivid
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: tomorrow == isTomorrow
                      ? null
                      : Border.all(color: AppColors.line),
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: AppText.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: tomorrow == isTomorrow
                        ? AppColors.primary
                        : AppColors.inkMuted,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
