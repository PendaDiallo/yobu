import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/day_picker.dart';
import '../../../../shared/widgets/place_field.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../../../shared/widgets/yobu_text_field.dart';
import '../../domain/place.dart';
import '../trip_create_controller.dart';

/// L'écran conducteur : publier son trajet récurrent. Objectif produit :
/// moins de 3 minutes de l'ouverture à la publication.
class TripCreateScreen extends ConsumerStatefulWidget {
  const TripCreateScreen({super.key});

  @override
  ConsumerState<TripCreateScreen> createState() => _TripCreateScreenState();
}

class _TripCreateScreenState extends ConsumerState<TripCreateScreen> {
  Place? _origin;
  Place? _destination;
  TimeOfDay? _time;
  Set<int> _days = {1, 2, 3, 4, 5};
  int _seats = 3;
  final _price = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _price.dispose();
    super.dispose();
  }

  bool get _complete =>
      _origin != null &&
      _destination != null &&
      _time != null &&
      _days.isNotEmpty &&
      (int.tryParse(_price.text) ?? 0) > 0;

  void _onPlaceChanged() {
    final origin = _origin;
    final destination = _destination;
    if (origin != null && destination != null) {
      ref
          .read(tripCreateControllerProvider.notifier)
          .loadHint(origin, destination);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 6, minute: 45),
    );
    if (picked != null) setState(() => _time = picked);
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:'
      '${time.minute.toString().padLeft(2, '0')}';

  String? get _priceWarning {
    final hint = ref.read(tripCreateControllerProvider).hint;
    final price = int.tryParse(_price.text);
    if (hint == null || price == null || price == 0) return null;
    if (price >= hint.min && price <= hint.max) return null;

    return 'Hors de la fourchette suggérée (${hint.min} – ${hint.max} F). '
        'Reste dans le partage de frais.';
  }

  Future<void> _publish() async {
    setState(() => _error = null);
    try {
      await ref.read(tripCreateControllerProvider.notifier).publish(
            origin: _origin!,
            destination: _destination!,
            departureTime: _formatTime(_time!),
            daysOfWeek: _days.toList()..sort(),
            seatsTotal: _seats,
            pricePerSeat: int.parse(_price.text),
          );
      if (mounted) context.goNamed(AppRoute.tripMyList);
    } on AppException catch (exception) {
      setState(() => _error = exception.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(tripCreateControllerProvider);
    final hint = createState.hint;
    final warning = _priceWarning;
    final error = _error;
    final time = _time;

    return Scaffold(
      appBar: AppBar(title: const Text('Publier mon trajet')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            PlaceField(
              label: 'Départ',
              hint: 'Ex. Keur Massar, Unité 15',
              onSearch: _search,
              onSelected: (suggestion) {
                setState(() => _origin = suggestion?.data as Place?);
                _onPlaceChanged();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            PlaceField(
              label: 'Arrivée',
              hint: 'Ex. Plateau, Sandaga',
              onSearch: _search,
              onSelected: (suggestion) {
                setState(() => _destination = suggestion?.data as Place?);
                _onPlaceChanged();
              },
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('DÉPART À',
                          style:
                              AppText.label.copyWith(color: AppColors.inkMuted)),
                      const SizedBox(height: AppSpacing.sm),
                      _TimeButton(
                        label: time == null ? '--:--' : _formatTime(time),
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
                      Text('PLACES',
                          style:
                              AppText.label.copyWith(color: AppColors.inkMuted)),
                      const SizedBox(height: AppSpacing.sm),
                      _SeatsPicker(
                        value: _seats,
                        onChanged: (seats) => setState(() => _seats = seats),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('JOURS',
                style: AppText.label.copyWith(color: AppColors.inkMuted)),
            const SizedBox(height: AppSpacing.sm),
            DayPicker(
              selected: _days,
              onChanged: (days) => setState(() => _days = days),
            ),
            const SizedBox(height: AppSpacing.md),
            YobuTextField(
              label: 'Prix par place',
              hint: hint == null ? '1 000' : '${hint.suggested}',
              controller: _price,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              suffix: Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child: Text('F',
                    style: AppText.h2.copyWith(color: AppColors.inkMuted)),
              ),
            ),
            if (hint != null) ...[
              const SizedBox(height: AppSpacing.sm),
              InkWell(
                onTap: () => setState(() => _price.text = '${hint.suggested}'),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Text(
                  'Suggéré : ${hint.suggested} F (${hint.min} – ${hint.max} F) — '
                  'touche pour appliquer',
                  style: AppText.caption.copyWith(color: AppColors.inkMuted),
                ),
              ),
            ],
            if (warning != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: AppSpacing.md, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      warning,
                      style:
                          AppText.caption.copyWith(color: AppColors.warning),
                    ),
                  ),
                ],
              ),
            ],
            if (error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(error,
                  style: AppText.bodySm.copyWith(color: AppColors.danger)),
            ],
            const SizedBox(height: AppSpacing.lg),
            YobuButton(
              label: 'Publier mon trajet',
              loading: createState.publishing,
              onPressed:
                  _complete && !createState.publishing ? _publish : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<List<PlaceSuggestion>> _search(String query) async {
    final places = await ref.read(placesRepositoryProvider).search(query);

    return [
      for (final place in places)
        PlaceSuggestion(label: place.label, data: place),
    ];
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
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

class _SeatsPicker extends StatelessWidget {
  const _SeatsPicker({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var seats = 1; seats <= 4; seats++) ...[
          if (seats > 1) const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(seats),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 120),
                height: AppSpacing.xxl,
                decoration: BoxDecoration(
                  color: seats == value
                      ? AppColors.primaryVivid
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: seats == value
                      ? null
                      : Border.all(color: AppColors.line),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$seats',
                  style: AppText.body.copyWith(
                    fontWeight: FontWeight.w800,
                    color: seats == value
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
