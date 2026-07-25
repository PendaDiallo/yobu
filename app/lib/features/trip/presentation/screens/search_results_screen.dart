import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/trip_card.dart';
import '../../domain/match.dart';
import '../search_controller.dart';

class SearchResultsScreen extends ConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(searchControllerProvider);
    final results = search.results;

    return Scaffold(
      appBar: AppBar(title: const Text('Conducteurs')),
      body: SafeArea(
        child: results == null
            ? const SizedBox.shrink()
            : results.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Text(
                      '$error',
                      style: AppText.body.copyWith(color: AppColors.danger),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                data: (matches) => matches.isEmpty
                    ? EmptyState(
                        icon: Icons.search_off_rounded,
                        title: 'Aucun conducteur trouvé',
                        message:
                            'Personne ne passe près de chez toi à cette '
                            'heure pour l\'instant. Réessaie avec un autre '
                            'horaire.',
                        ctaLabel: 'Modifier ma recherche',
                        onCta: () => context.pop(),
                      )
                    : _ResultsList(
                        matches: matches,
                        summary: search.summary,
                      ),
              ),
      ),
    );
  }
}

class _ResultsList extends StatelessWidget {
  const _ResultsList({required this.matches, required this.summary});

  final List<Match> matches;
  final String summary;

  String _priceLabel(int price) {
    final digits = price.toString();
    // 1200 → « 1 200 F » — mise en forme d'affichage, pas un calcul.
    final grouped = digits.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]} ',
    );

    return '$grouped F';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: matches.length + 1,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                matches.length == 1
                    ? '1 conducteur'
                    : '${matches.length} conducteurs',
                style: AppText.h1,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                summary,
                style: AppText.bodySm.copyWith(color: AppColors.inkMuted),
              ),
            ],
          );
        }

        final match = matches[index - 1];
        final trip = match.trip;
        final driver = match.driver;

        return TripCard(
          origin: trip.originLabel,
          destination: trip.destLabel,
          timeLabel: trip.departureTime,
          price: _priceLabel(trip.pricePerSeat),
          seatsLabel: trip.seatsLeft == 1
              ? '1 place'
              : '${trip.seatsLeft} places',
          driverName: '${driver.firstName} ${driver.lastName}'.trim(),
          driverInitials: [driver.firstName, driver.lastName]
              .map((part) => part.isNotEmpty ? part[0] : '')
              .join(),
          driverPhotoUrl: driver.photoUrl,
          driverRating: driver.rating,
          driverRatingLabel: driver.ratingCount > 0
              ? driver.rating.toStringAsFixed(1).replaceAll('.', ',')
              : null,
          driverVerified: driver.badges.contains('phone_verified'),
          onTap: () => context.pushNamed(
            AppRoute.tripDetail,
            pathParameters: {'id': '${trip.id}'},
          ),
        );
      },
    );
  }
}
