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
import '../../features/subscription/presentation/plans_screen.dart';
import '../../features/subscription/presentation/license_activation_screen.dart';
import '../../features/studio/presentation/studio_screen.dart';
import '../../features/voice_actor/presentation/voice_actor_screen.dart';
import '../../features/character/presentation/character_chat_screen.dart';
import '../../features/character/presentation/character_quiz_screen.dart';
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
          final id = state.pathParameters['id']!;
          return CharacterDetailScreen(characterId: id);
        },
      ),
      GoRoute(
        path: '/characters',
        name: 'character-list',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CharacterListScreen(
            title: extra['title'] as String,
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
        path: '/search',
        name: 'search',
        builder: (context, state) => const RechercheScreen(),
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
        builder: (context, state) => const PlansScreen(),
      ),
      GoRoute(
        path: '/activate-license',
        name: 'activate-license',
        builder: (context, state) => const LicenseActivationScreen(),
      ),
      GoRoute(
        path: '/studio/:id',
        name: 'studio',
        builder: (context, state) => StudioScreen(
          studioId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/voice-actor/:id',
        name: 'voice-actor',
        builder: (context, state) => VoiceActorScreen(
          staffId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/chat/:charId',
        name: 'chat',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CharacterChatScreen(
            charId: state.pathParameters['charId']!,
            charName: extra['charName'] as String? ?? '',
            charImageUrl: extra['charImageUrl'] as String? ?? '',
            charBio: extra['charBio'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/quiz/:charId',
        name: 'quiz',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          final raw = extra['quizQuestions'];
          final quizQuestions = raw is List
              ? raw.whereType<QuizQuestion>().toList()
              : null;
          return CharacterQuizScreen(
            charId: state.pathParameters['charId']!,
            charName: extra['charName'] as String? ?? '',
            quizQuestions: quizQuestions,
          );
        },
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
