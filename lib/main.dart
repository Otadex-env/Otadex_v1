import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/services/chariow_service.dart';
import 'core/services/notification_service.dart';
import 'core/models/user_rank.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/currency_provider.dart';
import 'core/providers/user_profile_provider.dart';
import 'core/theme/app_colors.dart';
import 'firebase_options.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService.initialize();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ??
      prefs.getBool('isLoggedIn') ??
      false;
  var rankStr =
      prefs.getString(AppConstants.keyUserRank) ?? AppConstants.rankGenin;
  final userId = prefs.getString(AppConstants.keyUserId);
  final pseudo = prefs.getString(AppConstants.keyUserPseudo);
  final email = prefs.getString(AppConstants.keyUserEmail);
  final currency = prefs.getString(AppConstants.keyUserCurrency) ?? 'XAF';

  // Vérification expiration licence au démarrage
  if (isLoggedIn) {
    final expiresMs = prefs.getInt(AppConstants.keyLicenseExpires) ?? 0;
    if (expiresMs > 0) {
      final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresMs);
      if (expiresAt.isBefore(DateTime.now())) {
        // Licence expirée localement — vérifier via Chariow
        try {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            final doc = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();
            final licenseKey =
                doc.data()?['licenseKey'] as String?;
            if (licenseKey != null && licenseKey.isNotEmpty) {
              final result =
                  await ChariowService().checkLicense(licenseKey);
              if (!result.isActive || result.isExpired) {
                // Rétrograder vers genin
                rankStr = AppConstants.rankGenin;
                await prefs.setString(
                    AppConstants.keyUserRank, AppConstants.rankGenin);
                await prefs.remove(AppConstants.keyLicenseExpires);
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({'abonnement': AppConstants.rankGenin});
              } else if (result.expiresAt != null) {
                // Mettre à jour la date d'expiration depuis Chariow
                await prefs.setInt(AppConstants.keyLicenseExpires,
                    result.expiresAt!.millisecondsSinceEpoch);
              }
            } else {
              // Aucune clé enregistrée — rétrograder
              rankStr = AppConstants.rankGenin;
              await prefs.setString(
                  AppConstants.keyUserRank, AppConstants.rankGenin);
              await prefs.remove(AppConstants.keyLicenseExpires);
            }
          }
        } catch (_) {
          // Erreur réseau — on garde le rang actuel pour ne pas pénaliser offline
        }
      }
    }
  }

  final userRank = UserRank.values.firstWhere(
    (r) => r.name == rankStr,
    orElse: () => UserRank.genin,
  );

  // Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
