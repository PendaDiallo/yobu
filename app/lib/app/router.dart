import 'package:go_router/go_router.dart';

import 'debug/debug_gallery_screen.dart';
import '../features/auth/presentation/screens/otp_verify_screen.dart';
import '../features/auth/presentation/screens/phone_auth_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/welcome_screen.dart';
import '../features/booking/presentation/screens/bookings_screen.dart';
import '../features/booking/presentation/screens/trip_requests_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/profile/presentation/screens/profile_edit_screen.dart';
import '../features/profile/presentation/screens/profile_setup_screen.dart';
import '../features/profile/presentation/screens/profile_view_screen.dart';
import '../features/rating/presentation/screens/rating_screen.dart';
import '../features/trip/presentation/screens/search_results_screen.dart';
import '../features/trip/presentation/screens/search_screen.dart';
import '../features/trip/presentation/screens/trip_create_screen.dart';
import '../features/trip/presentation/screens/trip_detail_screen.dart';
import '../features/trip/presentation/screens/trip_my_list_screen.dart';

/// Les noms des 16 écrans de docs/01-produit.md §3. On navigue par nom
/// (context.goNamed), jamais par chemin en dur.
abstract final class AppRoute {
  static const splash = 'splash';
  static const welcome = 'welcome';
  static const phoneAuth = 'phone_auth';
  static const otpVerify = 'otp_verify';
  static const profileSetup = 'profile_setup';
  static const profileView = 'profile_view';
  static const profileEdit = 'profile_edit';
  static const tripCreate = 'trip_create';
  static const tripMyList = 'trip_my_list';
  static const tripRequests = 'trip_requests';
  static const search = 'search';
  static const searchResults = 'search_results';
  static const tripDetail = 'trip_detail';
  static const home = 'home';
  static const bookings = 'bookings';
  static const rating = 'rating';
}

final router = GoRouter(
  // Dev : `--dart-define=INITIAL_ROUTE=/debug` ouvre l'app sur une route donnée.
  initialLocation:
      const String.fromEnvironment('INITIAL_ROUTE', defaultValue: '/'),
  routes: [
    // Onboarding
    GoRoute(
      path: '/',
      name: AppRoute.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/welcome',
      name: AppRoute.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/auth/phone',
      name: AppRoute.phoneAuth,
      builder: (context, state) => const PhoneAuthScreen(),
    ),
    GoRoute(
      path: '/auth/otp',
      name: AppRoute.otpVerify,
      builder: (context, state) => const OtpVerifyScreen(),
    ),
    // Profil
    GoRoute(
      path: '/profile/setup',
      name: AppRoute.profileSetup,
      builder: (context, state) => const ProfileSetupScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: AppRoute.profileView,
      builder: (context, state) => const ProfileViewScreen(),
    ),
    GoRoute(
      path: '/profile/edit',
      name: AppRoute.profileEdit,
      builder: (context, state) => const ProfileEditScreen(),
    ),
    // Trajet — conducteur
    GoRoute(
      path: '/trips/create',
      name: AppRoute.tripCreate,
      builder: (context, state) => const TripCreateScreen(),
    ),
    GoRoute(
      path: '/trips/mine',
      name: AppRoute.tripMyList,
      builder: (context, state) => const TripMyListScreen(),
    ),
    GoRoute(
      path: '/trips/requests',
      name: AppRoute.tripRequests,
      builder: (context, state) => const TripRequestsScreen(),
    ),
    // Trajet — passager
    GoRoute(
      path: '/search',
      name: AppRoute.search,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/search/results',
      name: AppRoute.searchResults,
      builder: (context, state) => const SearchResultsScreen(),
    ),
    GoRoute(
      path: '/trips/:id',
      name: AppRoute.tripDetail,
      builder: (context, state) => TripDetailScreen(
        tripId: state.pathParameters['id']!,
        args: state.extra as TripDetailArgs?,
      ),
    ),
    // Commun
    GoRoute(
      path: '/home',
      name: AppRoute.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/bookings',
      name: AppRoute.bookings,
      builder: (context, state) => const BookingsScreen(),
    ),
    GoRoute(
      path: '/rating',
      name: AppRoute.rating,
      builder: (context, state) => const RatingScreen(),
    ),
    // Galerie de dev — pas un écran produit (docs/01-produit.md n'en a que 16).
    GoRoute(
      path: '/debug',
      name: 'debug',
      builder: (context, state) => const DebugGalleryScreen(),
    ),
  ],
);
