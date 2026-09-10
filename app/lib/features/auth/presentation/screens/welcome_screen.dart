import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/tokens.dart';
import '../../../../shared/widgets/yobu_button.dart';

/// Les 3 slides d'accueil. On ne vend pas « du covoiturage » — on parle du
/// détour que YOBU supprime (docs/01-produit.md §2, jours/J16).
///
/// Pager Flutter natif : c'est une des trois exceptions assumées du design
/// system (docs/03-design-brief.md §3), il ne sert qu'ici.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _pager = PageController();
  int _page = 0;

  static const _slides = [
    _Slide(
      icon: Icons.directions_walk_rounded,
      title: 'Ton voisin va au Plateau ce matin',
      body: 'Et toi tu marches 2 km pour ne pas le savoir. '
          'YOBU vous met en relation — sans détour.',
    ),
    _Slide(
      icon: Icons.event_repeat_rounded,
      title: 'Une fois, pas tous les matins',
      body: 'Tu configures ton trajet du matin une seule fois. '
          'Ensuite, YOBU te retrouve quelqu\'un sur ta route.',
    ),
    _Slide(
      icon: Icons.verified_user_rounded,
      title: 'Tu sais avec qui tu montes',
      body: 'Numéro vérifié, note visible, vraie photo. '
          'Et vous êtes du même quartier.',
    ),
  ];

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _page == _slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pager,
                itemCount: _slides.length,
                onPageChanged: (page) => setState(() => _page = page),
                itemBuilder: (context, index) => _slides[index],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < _slides.length; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    width: i == _page ? AppSpacing.lg : AppSpacing.sm,
                    height: AppSpacing.sm,
                    decoration: BoxDecoration(
                      color: i == _page
                          ? AppColors.primaryVivid
                          : AppColors.line,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: YobuButton(
                label: isLast ? 'Commencer' : 'Suivant',
                onPressed: () {
                  if (isLast) {
                    context.goNamed(AppRoute.phoneAuth);
                  } else {
                    _pager.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.xxl * 2,
            height: AppSpacing.xxl * 2,
            decoration: const BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: AppSpacing.xl + AppSpacing.sm, color: AppColors.primary),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(title, style: AppText.h1),
          const SizedBox(height: AppSpacing.md),
          Text(body,
              style: AppText.body.copyWith(color: AppColors.inkMuted)),
        ],
      ),
    );
  }
}
