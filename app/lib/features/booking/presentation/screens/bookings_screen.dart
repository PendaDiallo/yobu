import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/formats.dart';
import '../../../../features/rating/presentation/screens/rating_screen.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../../shared/widgets/whatsapp_button.dart';
import '../../../../shared/widgets/yobu_avatar.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../domain/booking.dart';
import '../my_bookings_controller.dart';

/// Mes réservations, en deux sections « À venir / Passées ». Le partage se
/// fait sur `booking.upcoming`, calculé par l'API.
class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(myBookingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mes réservations')),
      body: SafeArea(
        child: bookings.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Text(
                '$error',
                style: AppText.body.copyWith(color: AppColors.danger),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const EmptyState(
                icon: Icons.event_seat_outlined,
                title: 'Aucune réservation',
                message:
                    'Tes demandes de place apparaîtront ici, à venir puis passées.',
              );
            }

            final upcoming = [for (final b in list) if (b.upcoming) b];
            final past = [for (final b in list) if (!b.upcoming) b];

            return ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                if (upcoming.isNotEmpty) ...[
                  const _SectionLabel('À venir'),
                  for (final b in upcoming)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _BookingCard(booking: b),
                    ),
                ],
                if (past.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const _SectionLabel('Passées'),
                  for (final b in past)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: _BookingCard(booking: b),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm, top: AppSpacing.xs),
        child: Text(text.toUpperCase(), style: AppText.label),
      );
}

class _BookingCard extends ConsumerStatefulWidget {
  const _BookingCard({required this.booking});

  final Booking booking;

  @override
  ConsumerState<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends ConsumerState<_BookingCard> {
  bool _busy = false;

  Future<void> _cancel() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(myBookingsControllerProvider.notifier)
          .cancel(widget.booking);
    } on AppException catch (exception) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(exception.message),
          backgroundColor: AppColors.danger,
        ));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _rate() async {
    final driver = widget.booking.driver;
    final result = await context.pushNamed<Object?>(
      AppRoute.rating,
      extra: RatingArgs(
        bookingId: widget.booking.id,
        tripId: widget.booking.trip.id,
        personName: '${driver.firstName} ${driver.lastName}'.trim(),
        personInitials: [driver.firstName, driver.lastName]
            .map((part) => part.isNotEmpty ? part[0] : '')
            .join(),
        personPhotoUrl: driver.photoUrl,
      ),
    );
    if (result == true && mounted) {
      ref.invalidate(myBookingsControllerProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Merci, ta note est envoyée.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final driver = booking.driver;
    final phone = driver.phone;
    final canCancel =
        booking.upcoming && (booking.status == 'pending' || booking.status == 'accepted');

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
            children: [
              YobuAvatar(
                initials: [driver.firstName, driver.lastName]
                    .map((part) => part.isNotEmpty ? part[0] : '')
                    .join(),
                photoUrl: driver.photoUrl,
                size: AppSpacing.xxl,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${driver.firstName} ${driver.lastName}'.trim(),
                      style: AppText.h2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (driver.ratingCount > 0)
                      Row(
                        children: [
                          StarRating(value: driver.rating),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            driver.rating.toStringAsFixed(1).replaceAll('.', ','),
                            style: AppText.caption
                                .copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              _StatusChip(status: booking.status),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            '${formatDateShort(booking.date)} · '
            '${booking.trip.originLabel} → ${booking.trip.destLabel} · '
            '${booking.trip.departureTime} · '
            '${formatPrice(booking.pricePaid)}',
            style: AppText.bodySm.copyWith(color: AppColors.inkMuted),
          ),
          if (booking.status == 'accepted' && phone != null) ...[
            const SizedBox(height: AppSpacing.md),
            WhatsAppButton(phone: phone),
          ],
          if (canCancel) ...[
            const SizedBox(height: AppSpacing.sm),
            YobuButton(
              label: 'Annuler',
              variant: YobuButtonVariant.ghost,
              loading: _busy,
              onPressed: _busy ? null : _cancel,
            ),
          ],
          if (booking.canRate) ...[
            const SizedBox(height: AppSpacing.sm),
            YobuButton(label: 'Noter le trajet', onPressed: _rate),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      'pending' => ('En attente', AppColors.warning),
      'accepted' => ('Acceptée', AppColors.success),
      'rejected' => ('Refusée', AppColors.danger),
      'cancelled' => ('Annulée', AppColors.inkMuted),
      'completed' => ('Terminée', AppColors.inkMuted),
      _ => (status, AppColors.inkMuted),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label,
              style: AppText.caption.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}
