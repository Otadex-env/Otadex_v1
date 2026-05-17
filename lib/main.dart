import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/models/user_rank.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/currency_provider.dart';
import 'core/providers/user_profile_provider.dart';
import 'core/theme/app_colors.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ??
      prefs.getBool('isLoggedIn') ??
      false;
  final rankStr =
      prefs.getString(AppConstants.keyUserRank) ?? AppConstants.rankGenin;
  final userId = prefs.getString(AppConstants.keyUserId);
  final pseudo = prefs.getString(AppConstants.keyUserPseudo);
  final email = prefs.getString(AppConstants.keyUserEmail);
  final currency = prefs.getString(AppConstants.keyUserCurrency) ?? 'XAF';
  final userRank = UserRank.values.firstWhere(
    (r) => r.name == rankStr,
    orElse: () => UserRank.genin,
  );

  // DEBUG : réinitialise l'onboarding à chaque démarrage pour tester le flux complet
  if (kDebugMode) {
    await prefs.remove(AppConstants.keyHasSeenOnboarding);
  }

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Style de la barre système
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.backgroundDeep,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        isLoggedInProvider.overrideWith((ref) => isLoggedIn),
        currencyProvider.overrideWith((ref) => currency),
        userProfileProvider.overrideWith(
          (ref) => UserProfileNotifier(
            initialRank: userRank,
            id: userId,
            pseudo: pseudo,
            email: email,
          ),
        ),
      ],
      child: const OtadexApp(),
    ),
  );
}
