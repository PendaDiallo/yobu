import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/formats.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/star_rating.dart';
import '../../../../shared/widgets/whatsapp_button.dart';
import '../../../../shared/widgets/yobu_avatar.dart';
import '../../../../shared/widgets/yobu_button.dart';
import '../../domain/booking.dart';
import '../received_requests_controller.dart';

/// Les demandes reçues sur mes trajets (conducteur). Accepter fait
/// apparaître le bouton WhatsApp — pas avant.
class TripRequestsScreen extends ConsumerWidget {
  const TripRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(receivedRequestsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Demandes reçues')),
      body: SafeArea(
        child: requests.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(
            child: Text('$error',
                style: AppText.body.copyWith(color: AppColors.danger),
                textAlign: TextAlign.center),
          ),
          data: (bookings) => bookings.isEmpty
              ? const EmptyState(
                  icon: Icons.inbox_outlined,
                  title: 'Aucune demande',
                  message:
                      'Les demandes de tes passagers arriveront ici.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: bookings.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) =>
                      _RequestCard(booking: bookings[index]),
                ),
        ),
      ),
    );
  }
}

class _RequestCard extends ConsumerStatefulWidget {
  const _RequestCard({required this.booking});

  final Booking booking;

  @override
  ConsumerState<_RequestCard> createState() => _RequestCardState();
}

class _RequestCardState extends ConsumerState<_RequestCard> {
  bool _busy = false;

  Future<void> _respond(String status) async {
    setState(() => _busy = true);
    try {
      await ref
          .read(receivedRequestsControllerProvider.notifier)
          .respond(widget.booking, status);
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

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final rider = booking.rider;
    final phone = rider?.phone;

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
                initials: rider == null
                    ? '?'
                    : [rider.firstName, rider.lastName]
                        .map((part) => part.isNotEmpty ? part[0] : '')
                        .join(),
                photoUrl: rider?.photoUrl,
                size: AppSpacing.xxl,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rider == null
                          ? 'Passager'
                          : '${rider.firstName} ${rider.lastName}'.trim(),
                      style: AppText.h2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (rider != null && rider.ratingCount > 0)
                      Row(
                        children: [
                          StarRating(value: rider.rating),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            rider.rating
                                .toStringAsFixed(1)
                                .replaceAll('.', ','),
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
          const SizedBox(height: AppSpacing.md),
          if (booking.status == 'pending')
            Row(
              children: [
                Expanded(
                  child: YobuButton(
                    label: 'Refuser',
                    variant: YobuButtonVariant.ghost,
                    onPressed: _busy ? null : () => _respond('rejected'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: YobuButton(
                    label: 'Accepter',
                    loading: _busy,
                    onPressed: _busy ? null : () => _respond('accepted'),
                  ),
                ),
              ],
            )
          else if (booking.status == 'accepted' && phone != null)
            WhatsAppButton(phone: phone),
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
