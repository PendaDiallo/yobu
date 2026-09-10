import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../app/router.dart';
import '../../../../core/network/token_storage.dart';
import '../../../../shared/theme/tokens.dart';

/// Le tout premier écran : le logo, le temps de savoir où t'envoyer.
///
/// - session valide + profil complet → `home`
/// - session valide + profil vide → `profile_setup`
/// - pas de session (ou `/me` échoue) → `welcome`
///
/// Si l'app a été ouverte en tapant une notification, on ne fait rien :
/// `NotificationService` a déjà programmé la navigation vers le bon écran.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _route());
  }

  Future<void> _route() async {
    if (await FirebaseMessaging.instance.getInitialMessage() != null) return;

    final token = await ref.read(tokenStorageProvider).read();
    if (!mounted) return;

    if (token == null) {
      context.goNamed(AppRoute.welcome);
      return;
    }

    try {
      final user = await ref.read(profileRepositoryProvider).getMe();
      if (!mounted) return;
      context.goNamed(
        user.firstName.isEmpty ? AppRoute.profileSetup : AppRoute.home,
      );
    } catch (_) {
      if (mounted) context.goNamed(AppRoute.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Text(
          'YOBU',
          style: AppText.display.copyWith(
            color: AppColors.surface,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}
