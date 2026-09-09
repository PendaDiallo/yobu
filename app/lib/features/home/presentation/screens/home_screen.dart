import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/formats.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../domain/home_summary.dart';
import '../home_controller.dart';

/// Le dashboard : le prochain trajet (calculé par l'API) et les 3 actions
/// rapides. En régime établi l'app est quasi-invisible — cet écran est
/// l'essentiel de ce qu'on voit au quotidien.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('YOBU')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(homeControllerProvider.notifier).refresh(),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              Text('PROCHAIN TRAJET', style: AppText.label),
              const SizedBox(height: AppSpacing.sm),
              home.when(
                loading: () => const _Card(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (error, _) => _Card(
                  child: Text(
                    '$error',
                    style: AppText.bodySm.copyWith(color: AppColors.danger),
                  ),
                ),
                data: (summary) => summary.next == null
                    ? const _NoRideCard()
                    : _NextRideCard(ride: summary.next!),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text('QUE VEUX-TU FAIRE ?', style: AppText.label),
              const SizedBox(height: AppSpacing.sm),
              YobuButton(
                label: 'Chercher un trajet',
                onPressed: () => context.goNamed(AppRoute.search),
              ),
              const SizedBox(height: AppSpacing.sm),
              YobuButton(
                label: 'Publier un trajet',
                variant: YobuButtonVariant.secondary,
                onPressed: () => context.goNamed(AppRoute.tripCreate),
              ),
              const SizedBox(height: AppSpacing.sm),
              YobuButton(
                label: 'Mes réservations',
                variant: YobuButtonVariant.ghost,
                onPressed: () => context.goNamed(AppRoute.bookings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: child,
      );
}

class _NoRideCard extends StatelessWidget {
  const _NoRideCard();

  @override
  Widget build(BuildContext context) => _Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rien de prévu', style: AppText.h2),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Publie ton trajet du matin ou cherche un conducteur — '
              'tu ne le fais qu\'une fois.',
              style: AppText.bodySm.copyWith(color: AppColors.inkMuted),
            ),
          ],
        ),
      );
}

class _NextRideCard extends StatelessWidget {
  const _NextRideCard({required this.ride});

  final NextRide ride;

  @override
  Widget build(BuildContext context) {
    final isDriver = ride.role == 'driver';

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${formatDateShort(ride.date)} · ${ride.departureTime}',
                  style: AppText.h2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  isDriver ? 'Tu conduis' : 'Tu es passager',
                  style: AppText.caption.copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '${ride.originLabel} → ${ride.destLabel}',
            style: AppText.body,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isDriver
                ? '${ride.seatsTaken ?? 0} / ${ride.seatsTotal ?? 0} place(s) prise(s)'
                : 'Avec ${ride.partner?.firstName ?? ''} · '
                    '${formatPrice(ride.price ?? 0)}',
            style: AppText.bodySm.copyWith(color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}
