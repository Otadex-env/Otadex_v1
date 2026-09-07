import 'dart:io'; // === DEBUG IDTOKEN — À RETIRER ===

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // === DEBUG IDTOKEN — À RETIRER ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/services/notification_service.dart';
import 'core/subscription/rank_providers.dart';
import 'core/providers/auth_provider.dart';
import 'core/providers/user_profile_provider.dart';
import 'core/theme/app_colors.dart';
import 'firebase_options.dart';
import 'app.dart';

late final ProviderContainer _providerContainer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // `.env` est un asset livré en clair dans l'AAB : il ne doit contenir que des
  // valeurs publiques (App ID, UIDs dev). `isOptional` + catch : l'app démarre
  // même si le fichier est absent ou partiel.
  try {
    await dotenv.load(fileName: '.env', isOptional: true);
  } catch (_) {}

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

  final userRank = UserRankX.fromString(rankStr);

  // Override rang du menu développeur : rechargé UNIQUEMENT si l'utilisateur
  // courant est un développeur. Ne touche jamais au rang réel.
  final isDeveloper = kDeveloperUids.contains(userId) ||
      kDeveloperEmails.contains(email);
  final devOverrideStr = prefs.getString(AppConstants.keyDevRankOverride);
  final initialDevRankOverride = (isDeveloper && devOverrideStr != null)
      ? UserRankX.fromString(devOverrideStr)
      : null;

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
      storedRankProvider.overrideWith((ref) => userRank),
      devRankOverrideProvider.overrideWith(
        (ref) => DevRankOverrideNotifier(initialDevRankOverride),
      ),
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

  // Revérifie la licence à chaque retour au premier plan, pas seulement au
  // cold start (une licence peut expirer pendant que l'app est en arrière-plan).
  WidgetsBinding.instance.addObserver(_LicenseLifecycleObserver());

  // Notifications + licence vérifiés après le premier frame (évite l'ANR)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    await NotificationService.initialize();
    // Attendre que Firebase Auth restaure la session (asynchrone au démarrage)
    final user = await FirebaseAuth.instance.authStateChanges().first;
    final uid = user?.uid;
    final firebaseEmail = user?.email;
    // Sync identité Firebase → notifier (le notifier force Kage pour les devs)
    if (uid != null || firebaseEmail != null) {
      _providerContainer
          .read(userProfileProvider.notifier)
          .updateIdentity(id: uid, email: firebaseEmail ?? email);
    }
    if (isLoggedIn) _checkLicenseExpiry(prefs);

    // === DEBUG IDTOKEN — À RETIRER ===
    // Android : /tmp n'est pas accessible à l'app. On écrit dans le dossier
    // privé du package, récupérable via `adb ... run-as com.otadex.otadex`.
    if (kDebugMode) {
      final u = FirebaseAuth.instance.currentUser;
      if (u != null) {
        final t = await u.getIdToken(true); // forceRefresh : token frais à chaque lancement
        if (t != null) {
          final path = Platform.isAndroid
              ? '/data/data/com.otadex.otadex/idtoken.txt'
              : '/tmp/idtoken.txt';
          await File(path).writeAsString(t);
          debugPrint('IDTOKEN écrit dans $path');
        }
      }
    }
    // === FIN DEBUG ===
  });
}

/// Relance [_checkLicenseExpiry] sur `AppLifecycleState.resumed`.
class _LicenseLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(AppConstants.keyIsLoggedIn) ?? false) {
        _checkLicenseExpiry(prefs);
      }
    });
  }
}

void _setStoredRank(UserRank rank) =>
    _providerContainer.read(storedRankProvider.notifier).state = rank;

/// Rétrogradation d'abonnement à l'expiration — **100 % hors-ligne**.
///
/// Aucun appel réseau tiers (la clé API Chariow a été retirée du client, cf.
/// `ChariowService`). La seule source de vérité côté client est le timestamp
/// local `keyLicenseExpires`, écrit lors de l'activation / du refresh. S'il est
/// dépassé, l'utilisateur repasse Genin ; la persistance Firestore du champ
/// `abonnement` est un *write* de synchronisation (best-effort), pas une
/// lecture de contrôle.
Future<void> _checkLicenseExpiry(SharedPreferences prefs) async {
  // Ne jamais rétrograder un développeur vers Genin
  final devUser = FirebaseAuth.instance.currentUser ??
      (await FirebaseAuth.instance.authStateChanges().first);
  final devUid = devUser?.uid;
  final devEmail = devUser?.email;
  if ((devUid != null && kDeveloperUids.contains(devUid)) ||
      (devEmail != null && kDeveloperEmails.contains(devEmail))) {
    return;
  }

  final expiresMs = prefs.getInt(AppConstants.keyLicenseExpires) ?? 0;
  if (expiresMs <= 0) return;
  final expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresMs);
  if (!expiresAt.isBefore(DateTime.now())) return;

  // Licence expirée localement → rétrogradation immédiate.
  await prefs.setString(AppConstants.keyUserRank, AppConstants.rankGenin);
  await prefs.remove(AppConstants.keyLicenseExpires);
  _setStoredRank(UserRank.genin);
  _providerContainer
      .read(userProfileProvider.notifier)
      .updateIdentity(rank: AppConstants.rankGenin);

  // Synchronisation Firestore best-effort (write seul, non bloquant).
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return;
  try {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({kFieldAbonnement: AppConstants.rankGenin});
  } catch (_) {}
}
