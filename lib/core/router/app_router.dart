import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/age_verification_screen.dart';
import '../../features/onboarding/presentation/interests_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/notifications_screen.dart';
import '../../features/character/presentation/character_detail_screen.dart';
import '../../features/character/presentation/character_list_screen.dart';
import '../../features/anime/presentation/anime_detail_screen.dart';
import '../../features/creator/presentation/creator_screen.dart';
import '../../features/collection/presentation/collection_screen.dart';
import '../../features/character/presentation/gallery_screen.dart';
import '../../features/legal/presentation/privacy_policy_screen.dart';
import '../../features/legal/presentation/terms_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/subscription/presentation/subscription_screen.dart';
import '../../core/models/character.dart';
import '../constants/app_constants.dart';
import '../widgets/auth_required_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String ageVerification = '/onboarding/age';
  static const String interests = '/onboarding/interests';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: ageVerification,
        name: 'age-verification',
        builder: (context, state) => const AgeVerificationScreen(),
      ),
      GoRoute(
        path: interests,
        name: 'interests',
        builder: (context, state) => const InterestsScreen(),
      ),
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const AuthRequiredScreen(
          message: 'Connecte-toi pour consulter tes notifications OTADEX.',
          child: NotificationsScreen(),
        ),
      ),
      GoRoute(
        path: '/character/:id',
        name: 'character',
        builder: (context, state) {
          final character = state.extra as Character;
          return CharacterDetailScreen(character: character);
        },
      ),
      GoRoute(
        path: '/characters',
        name: 'character-list',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CharacterListScreen(
            title: extra['title'] as String,
            characters: extra['characters'] as List<Character>,
          );
        },
      ),
      GoRoute(
        path: '/anime/:id',
        name: 'anime',
        builder: (context, state) {
          final animeId = state.pathParameters['id']!;
          return AnimeDetailScreen(animeId: animeId);
        },
      ),
      GoRoute(
        path: '/creator/:id',
        name: 'creator',
        builder: (context, state) {
          final creatorId = state.pathParameters['id']!;
          return CreatorScreen(creatorId: creatorId);
        },
      ),
      GoRoute(
        path: '/collection',
        name: 'collection',
        builder: (context, state) => const AuthRequiredScreen(
          message: 'Connecte-toi pour retrouver ta collection personnelle.',
          child: CollectionScreen(),
        ),
      ),
      GoRoute(
        path: '/search-standalone',
        name: 'search-standalone',
        builder: (context, state) => const RechercheScreen(),
      ),
      GoRoute(
        path: '/gallery/:charId',
        name: 'gallery',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final images = (extra['images'] as List).cast<String>();
          final initialIndex = extra['initialIndex'] as int;
          return GalleryScreen(images: images, initialIndex: initialIndex);
        },
      ),
      GoRoute(
        path: '/subscription',
        name: 'subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );
}

// Helper pour lire les prefs en dehors du widget tree
Future<String> getInitialRoute() async {
  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding =
      prefs.getBool(AppConstants.keyHasSeenOnboarding) ?? false;
  final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;

  if (!hasSeenOnboarding) return AppRouter.onboarding;
  return isLoggedIn ? AppRouter.home : AppRouter.login;
}
