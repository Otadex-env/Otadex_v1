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

late final ProviderContainer _providerContainer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

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

  _providerContainer = ProviderContainer(
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
  );

  runApp(UncontrolledProviderScope(
    container: _providerContainer,
    child: const OtadexApp(),
  ));

  // Notifications + licence vérifiés après le premier frame (évite l'ANR)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await NotificationService.initialize();
    // Attendre que Firebase Auth restaure la session (asynchrone au démarrage)
    final user = await FirebaseAuth.instance.authStateChanges().first;
    final uid = user?.uid;
    final firebaseEmail = user?.email;
    // Bypass développeur — force Kage en mémoire sans écrire dans Firestore
    if ((uid != null && kDeveloperUids.contains(uid)) ||
        (firebaseEmail != null && kDeveloperEmails.contains(firebaseEmail)) ||
        (email != null && kDeveloperEmails.contains(email))) {
      _providerContainer
          .read(userProfileProvider.notifier)
          .updateIdentity(rank: UserRank.kage.name);
    }
    if (isLoggedIn) _checkLicenseExpiry(prefs);
  });
}

Future<void> _checkLicenseExpiry(SharedPreferences prefs) async {
  // Ne jamais rétrograder un développeur vers Genin
  final devUser = FirebaseAuth.instance.currentUser ?? (await FirebaseAuth.instance.authStateChanges().first);
  final uid = devUser?.uid;
  final devEmail = devUser?.email;
  if ((uid != null && kDeveloperUids.contains(uid)) ||
      (devEmail != null && kDeveloperEmails.contains(devEmail))) {
    return;
  }

  final expiresMs = prefs.getInt(AppConstants.keyLicenseExpires) ?? 0;
  if (expiresMs <= 0) return;
  final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresMs);
  if (!expiresAt.isBefore(DateTime.now())) return;
  try {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final licenseKey = doc.data()?['licenseKey'] as String?;
    if (licenseKey != null && licenseKey.isNotEmpty) {
      final result = await ChariowService().checkLicense(licenseKey);
      if (!result.isActive || result.isExpired) {
        await prefs.setString(AppConstants.keyUserRank, AppConstants.rankGenin);
        await prefs.remove(AppConstants.keyLicenseExpires);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'abonnement': AppConstants.rankGenin});
        _providerContainer
            .read(userProfileProvider.notifier)
            .updateIdentity(rank: AppConstants.rankGenin);
      } else if (result.expiresAt != null) {
        await prefs.setInt(AppConstants.keyLicenseExpires,
            result.expiresAt!.millisecondsSinceEpoch);
      }
    } else {
      await prefs.setString(AppConstants.keyUserRank, AppConstants.rankGenin);
      await prefs.remove(AppConstants.keyLicenseExpires);
      _providerContainer
          .read(userProfileProvider.notifier)
          .updateIdentity(rank: AppConstants.rankGenin);
    }
  } catch (_) {}
}
