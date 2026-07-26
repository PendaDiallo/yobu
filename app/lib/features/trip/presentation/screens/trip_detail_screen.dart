import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/formats.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/route_map.dart';
import '../../../../shared/widgets/user_card.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../domain/match.dart';

/// Ce que search_results transmet à la fiche : le candidat + la date
/// cherchée. Pas de re-fetch — tout est déjà dans le Match.
class TripDetailArgs {
  const TripDetailArgs({required this.match, required this.date});

  final Match match;
  final String date;
}

class TripDetailScreen extends ConsumerStatefulWidget {
  const TripDetailScreen({super.key, required this.tripId, this.args});

  final String tripId;
  final TripDetailArgs? args;

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  bool _requesting = false;
  bool _requested = false;
  String? _error;

  Future<void> _request(TripDetailArgs args) async {
    setState(() {
      _requesting = true;
      _error = null;
    });
    try {
      await ref.read(bookingRepositoryProvider).request(
            tripId: args.match.trip.id,
            date: args.date,
          );
      await ref.read(analyticsProvider).logEvent(name: 'booking_requested');
      if (mounted) setState(() => _requested = true);
    } on AppException catch (exception) {
      setState(() => _error = exception.message);
    } finally {
      if (mounted) setState(() => _requesting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;

    return Scaffold(
      appBar: AppBar(title: const Text('Le trajet')),
      body: SafeArea(
        child: args == null
            // Fiche ouverte hors du flux de recherche (deep link) :
            // pas encore supporté en V1.
            ? Center(
                child: Text(
                  'Ouvre ce trajet depuis une recherche.',
                  style: AppText.body.copyWith(color: AppColors.inkMuted),
                ),
              )
            : _TripDetailBody(
                args: args,
                requesting: _requesting,
                requested: _requested,
                error: _error,
                onRequest: () => _request(args),
              ),
      ),
    );
  }
}

class _TripDetailBody extends StatelessWidget {
  const _TripDetailBody({
    required this.args,
    required this.requesting,
    required this.requested,
    required this.error,
    required this.onRequest,
  });

  final TripDetailArgs args;
  final bool requesting;
  final bool requested;
  final String? error;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final trip = args.match.trip;
    final driver = args.match.driver;
    final error = this.error;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        UserCard(
          name: '${driver.firstName} ${driver.lastName}'.trim(),
          initials: [driver.firstName, driver.lastName]
              .map((part) => part.isNotEmpty ? part[0] : '')
              .join(),
          photoUrl: driver.photoUrl,
          verified: driver.badges.contains('phone_verified'),
          rating: driver.rating,
          ratingLabel: driver.ratingCount > 0
              ? driver.rating.toStringAsFixed(1).replaceAll('.', ',')
              : null,
          tripsLabel: driver.tripsCompleted <= 1
              ? '${driver.tripsCompleted} trajet'
              : '${driver.tripsCompleted} trajets',
          badges: [
            if (driver.badges.contains('phone_verified')) 'Vérifié',
            if (driver.badges.contains('regular')) 'Régulier',
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        RouteMap(
          originLabel: trip.originLabel,
          destLabel: trip.destLabel,
          pickupLabel: 'Passe à ~${args.match.pickupDistanceM} m de ton départ',
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(formatPrice(trip.pricePerSeat),
                        style: AppText.display),
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
                      trip.seatsLeft <= 1
                          ? '${trip.seatsLeft} place'
                          : '${trip.seatsLeft} places',
                      style:
                          AppText.caption.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Cash, en main propre au conducteur.',
                style: AppText.caption.copyWith(color: AppColors.inkMuted),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(height: 1, color: AppColors.line),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(Icons.schedule_rounded,
                      size: AppSpacing.lg, color: AppColors.inkMuted),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${formatDateShort(args.date)} · départ '
                    '${trip.departureTime} · arrivée ~${trip.arrivalTime}',
                    style: AppText.bodySm,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (error != null) ...[
          Text(error,
              style: AppText.bodySm.copyWith(color: AppColors.danger),
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (requested)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.success),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Demande envoyée ! Le numéro WhatsApp du conducteur '
                    'apparaîtra une fois ta demande acceptée.',
                    style: AppText.bodySm.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          )
        else
          YobuButton(
            label: 'Demander une place',
            loading: requesting,
            onPressed: requesting ? null : onRequest,
          ),
      ],
    );
  }
}
