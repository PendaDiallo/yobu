import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/day_picker.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/route_display.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../domain/trip.dart';
import '../my_trips_controller.dart';

class TripMyListScreen extends ConsumerWidget {
  const TripMyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(myTripsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes trajets')),
      body: SafeArea(
        child: trips.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('$error',
                style: AppText.body.copyWith(color: AppColors.danger),
                textAlign: TextAlign.center),
          ),
          data: (trips) => trips.isEmpty
              ? EmptyState(
                  icon: Icons.directions_car_outlined,
                  title: 'Aucun trajet publié',
                  message:
                      'Publie ton trajet du matin : tes voisins le cherchent '
                      'peut-être déjà.',
                  ctaLabel: 'Publier un trajet',
                  onCta: () => context.pushNamed(AppRoute.tripCreate),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: trips.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) =>
                            _MyTripCard(trip: trips[index]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: YobuButton(
                        label: 'Publier un trajet',
                        onPressed: () =>
                            context.pushNamed(AppRoute.tripCreate),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _MyTripCard extends ConsumerWidget {
  const _MyTripCard({required this.trip});

  final Trip trip;

  void _showError(BuildContext context, Object error) {
    final message =
        error is AppException ? error.message : 'Une erreur est survenue.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: AppColors.danger,
    ));
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        title: Text('Supprimer ce trajet ?', style: AppText.h2),
        content: Text(
          '${trip.originLabel} → ${trip.destLabel}, ${trip.departureTime}. '
          'Cette action est définitive.',
          style: AppText.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Annuler',
                style: AppText.h2.copyWith(color: AppColors.inkMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Supprimer',
                style: AppText.h2.copyWith(color: AppColors.danger)),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(myTripsControllerProvider.notifier).delete(trip);
    } catch (error) {
      if (context.mounted) _showError(context, error);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RouteDisplay(
                  originLabel: trip.originLabel,
                  destLabel: trip.destLabel,
                  dense: true,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Switch(
                value: trip.active,
                activeTrackColor: AppColors.primaryVivid,
                thumbColor: const WidgetStatePropertyAll(AppColors.surface),
                onChanged: (active) async {
                  try {
                    await ref
                        .read(myTripsControllerProvider.notifier)
                        .setActive(trip, active);
                  } catch (error) {
                    if (context.mounted) _showError(context, error);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text('${trip.pricePerSeat} F', style: AppText.h1),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + AppSpacing.xs,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${trip.departureTime} · ${trip.seatsTotal} pl.',
                  style: AppText.caption.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: DayPicker(selected: trip.daysOfWeek.toSet())),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: () => _confirmDelete(context, ref),
                icon: const Icon(Icons.delete_outline_rounded,
                    color: AppColors.danger),
                tooltip: 'Supprimer',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
