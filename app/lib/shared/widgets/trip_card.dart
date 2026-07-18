import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import 'route_display.dart';
import 'star_rating.dart';
import 'yobu_avatar.dart';

/// LE composant central du design system — search_results, trip_my_list,
/// bookings, home. Hiérarchie de la direction B : le prix écrase tout,
/// l'itinéraire ensuite, le conducteur en dernier.
///
/// Toutes les valeurs affichées arrivent déjà formatées par l'API
/// (« 1 000 F », « 06:45 », « 3 places ») — aucun calcul ici.
class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.timeLabel,
    required this.price,
    required this.seatsLabel,
    required this.driverName,
    required this.driverInitials,
    required this.driverRating,
    this.driverRatingLabel,
    this.driverPhotoUrl,
    this.driverVerified = false,
    this.onTap,
  });

  final String origin;
  final String destination;

  /// Ex. « 06:45 » — heure de départ.
  final String timeLabel;

  /// Ex. « 1 000 F » — toujours le plus gros élément de la carte.
  final String price;

  /// Ex. « 3 places » — les places restantes ce jour-là, calculées par l'API.
  final String seatsLabel;
  final String driverName;
  final String driverInitials;
  final double driverRating;
  final String? driverRatingLabel;
  final String? driverPhotoUrl;
  final bool driverVerified;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ratingLabel = driverRatingLabel;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // L'itinéraire, et l'heure en face.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RouteDisplay(
                      originLabel: origin,
                      destLabel: destination,
                      dense: true,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
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
                      timeLabel,
                      style: AppText.h2.copyWith(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              // LE PRIX — le plus gros élément, c'est la règle.
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: Text(price, style: AppText.display)),
                  Text(
                    seatsLabel,
                    style: AppText.caption.copyWith(color: AppColors.inkMuted),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(height: 1, color: AppColors.line),
              const SizedBox(height: AppSpacing.md),
              // Le conducteur, en dernier.
              Row(
                children: [
                  YobuAvatar(
                    initials: driverInitials,
                    photoUrl: driverPhotoUrl,
                    verified: driverVerified,
                    size: AppSpacing.xl,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      driverName,
                      style:
                          AppText.bodySm.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StarRating(value: driverRating, size: 14),
                  if (ratingLabel != null) ...[
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      ratingLabel,
                      style:
                          AppText.caption.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
