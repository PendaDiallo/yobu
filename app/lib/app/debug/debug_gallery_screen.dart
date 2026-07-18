import 'package:flutter/material.dart';

import '../../shared/theme/tokens.dart';
import '../../shared/widgets/day_picker.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/route_display.dart';
import '../../shared/widgets/star_rating.dart';
import '../../shared/widgets/trip_card.dart';
import '../../shared/widgets/user_card.dart';
import '../../shared/widgets/yobu_avatar.dart';
import '../../shared/widgets/yobu_button.dart';
import '../../shared/widgets/yobu_text_field.dart';

/// Galerie de dev : les 9 composants du socle dans tous leurs états.
/// Pas un écran produit — sert à vérifier le design system d'un coup d'œil.
class DebugGalleryScreen extends StatefulWidget {
  const DebugGalleryScreen({super.key});

  @override
  State<DebugGalleryScreen> createState() => _DebugGalleryScreenState();
}

class _DebugGalleryScreenState extends State<DebugGalleryScreen> {
  int _stars = 3;
  Set<int> _days = {1, 2, 3, 4, 5};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Design system — socle J2')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _section('YobuButton — variants × normal / loading / disabled', [
            for (final variant in YobuButtonVariant.values) ...[
              YobuButton(
                label: variant.name,
                variant: variant,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.sm),
              YobuButton(
                label: '${variant.name} · loading',
                variant: variant,
                loading: true,
                onPressed: () {},
              ),
              const SizedBox(height: AppSpacing.sm),
              YobuButton(
                label: '${variant.name} · disabled',
                variant: variant,
                onPressed: null,
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ]),
          _section('YobuTextField', [
            const YobuTextField(
              label: 'Ton départ',
              hint: 'Ex. Keur Massar, Unité 15',
            ),
            const SizedBox(height: AppSpacing.md),
            YobuTextField(
              label: 'Numéro de téléphone',
              hint: '77 123 45 67',
              keyboardType: TextInputType.phone,
              suffix: const Icon(Icons.phone_outlined,
                  color: AppColors.inkMuted),
            ),
            const SizedBox(height: AppSpacing.md),
            const YobuTextField(
              label: 'Prix par place',
              hint: '1 000',
              errorText: 'Hors de la fourchette suggérée (400 – 2 000 F)',
            ),
            const SizedBox(height: AppSpacing.md),
            const YobuTextField(
              label: 'Champ désactivé',
              hint: 'Non modifiable',
              enabled: false,
            ),
          ]),
          _section('YobuAvatar — photo / initiales / vérifié / tailles', [
            const Row(
              children: [
                YobuAvatar(initials: 'AN', size: 32),
                SizedBox(width: AppSpacing.md),
                YobuAvatar(initials: 'MD', size: 48),
                SizedBox(width: AppSpacing.md),
                YobuAvatar(initials: 'FS', size: 48, verified: true),
                SizedBox(width: AppSpacing.md),
                YobuAvatar(initials: 'IB', size: 64, verified: true),
              ],
            ),
          ]),
          _section('StarRating — lecture (0 · 2,5 · 4,5 · 5) et saisie', [
            const Row(
              children: [
                StarRating(value: 0),
                SizedBox(width: AppSpacing.md),
                StarRating(value: 2.5),
                SizedBox(width: AppSpacing.md),
                StarRating(value: 4.5),
                SizedBox(width: AppSpacing.md),
                StarRating(value: 5),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            StarRating(
              value: _stars.toDouble(),
              onChanged: (value) => setState(() => _stars = value),
            ),
          ]),
          _section('UserCard — complet / nouveau', [
            UserCard(
              name: 'Awa Ndiaye',
              initials: 'AN',
              rating: 4.5,
              ratingLabel: '4,8',
              tripsLabel: '132 trajets',
              verified: true,
              badges: const ['Vérifié', 'Régulier'],
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            const UserCard(
              name: 'Ibrahima Fall',
              initials: 'IF',
              rating: 0,
              tripsLabel: '0 trajet',
              badges: ['Vérifié'],
            ),
          ]),
          _section('TripCard — le composant central', [
            TripCard(
              origin: 'Keur Massar, Unité 15',
              destination: 'Plateau, Place de l\'Indépendance',
              timeLabel: '06:45',
              price: '1 000 F',
              seatsLabel: '3 places',
              driverName: 'Moussa Diop',
              driverInitials: 'MD',
              driverRating: 4.5,
              driverRatingLabel: '4,8',
              driverVerified: true,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.md),
            const TripCard(
              origin: 'Keur Massar, Boune',
              destination: 'Plateau, Sandaga',
              timeLabel: '07:15',
              price: '800 F',
              seatsLabel: '1 place',
              driverName: 'Fatou Sarr',
              driverInitials: 'FS',
              driverRating: 0,
            ),
          ]),
          _section('RouteDisplay — normal / dense', [
            const RouteDisplay(
              originLabel: 'Keur Massar, Unité 15',
              destLabel: 'Plateau, Place de l\'Indépendance',
            ),
            const SizedBox(height: AppSpacing.md),
            const RouteDisplay(
              originLabel: 'Keur Massar, Boune',
              destLabel: 'Plateau, Sandaga',
              dense: true,
            ),
          ]),
          _section('DayPicker — saisie / lecture', [
            DayPicker(
              selected: _days,
              onChanged: (days) => setState(() => _days = days),
            ),
            const SizedBox(height: AppSpacing.md),
            const DayPicker(selected: {1, 2, 3, 4, 5}),
          ]),
          _section('EmptyState — avec / sans CTA', [
            EmptyState(
              icon: Icons.search_off_rounded,
              title: 'Aucun conducteur trouvé',
              message:
                  'Personne ne passe près de chez toi à cette heure pour l\'instant.',
              ctaLabel: 'Modifier ma recherche',
              onCta: () {},
            ),
            const EmptyState(
              icon: Icons.directions_car_outlined,
              title: 'Aucun trajet publié',
            ),
          ]),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: AppSpacing.lg,
            bottom: AppSpacing.md,
          ),
          child: Text(
            title.toUpperCase(),
            style: AppText.label.copyWith(color: AppColors.inkMuted),
          ),
        ),
        ...children,
      ],
    );
  }
}
