import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/constants/app_constants.dart';
import 'core/services/license_service.dart';
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
    if (isLoggedIn) _checkLicenseExpiry(prefs, force: true);
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

/// Revalidation d'abonnement — chemin hors-ligne rapide + contrôle serveur.
///
/// 1. **Hors-ligne** : si le timestamp local `keyLicenseExpires` est dépassé,
///    rétrogradation immédiate à Genin, sans attendre le réseau.
/// 2. **Serveur (best-effort)** : `POST /refresh` au Worker de licences (la clé
///    Chariow vit côté Worker, cf. [LicenseService]). Le Worker fait autorité :
///    il peut rétrograder (révocation / expiration côté Chariow) ou re-accorder
///    un rang premium (renouvellement), et écrit lui-même `abonnement` /
///    `licenseExpires` / `licenseKey` dans Firestore.
///
/// Sur `resume`, l'appel serveur est limité à une fois toutes les 4 h ;
/// `force: true` (cold start) le déclenche toujours. Toute erreur réseau /
/// transitoire est ignorée : l'état courant est conservé.
Future<void> _checkLicenseExpiry(
  SharedPreferences prefs, {
  bool force = false,
}) async {
  // Ne jamais rétrograder un développeur vers Genin.
  final devUser = FirebaseAuth.instance.currentUser ??
      (await FirebaseAuth.instance.authStateChanges().first);
  final devUid = devUser?.uid;
  final devEmail = devUser?.email;
  if ((devUid != null && kDeveloperUids.contains(devUid)) ||
      (devEmail != null && kDeveloperEmails.contains(devEmail))) {
    return;
  }

  // 1. Chemin hors-ligne : expiration locale dépassée → Genin immédiatement.
  final expiresMs = prefs.getInt(AppConstants.keyLicenseExpires) ?? 0;
  if (expiresMs > 0 &&
      DateTime.fromMillisecondsSinceEpoch(expiresMs)
          .isBefore(DateTime.now())) {
    await _applyRank(prefs, UserRank.genin, null);
  }

  // 2. Contrôle serveur (best-effort), throttlé hors cold start.
  final lastRefreshMs = prefs.getInt(AppConstants.keyLastLicenseRefresh) ?? 0;
  final sinceLastRefresh =
      DateTime.now().millisecondsSinceEpoch - lastRefreshMs;
  if (!force && sinceLastRefresh < const Duration(hours: 4).inMilliseconds) {
    return;
  }

  final result = await const LicenseService().refresh();

  // Session absente / réseau coupé / incident transitoire → on ne touche à rien.
  if (result.reason != null && !result.isDefinitiveDowngrade) return;

  await prefs.setInt(AppConstants.keyLastLicenseRefresh,
      DateTime.now().millisecondsSinceEpoch);

  if (result.isDefinitiveDowngrade || result.rank == UserRank.genin) {
    await _applyRank(prefs, UserRank.genin, null);
  } else {
    // Remontée autorisée : le Worker fait autorité sur le rang.
    await _applyRank(prefs, result.rank, result.expiresAt);
  }
}

/// Applique un rang localement : SharedPreferences + providers (rang réel).
/// Ne touche pas à Firestore — c'est le Worker qui possède `abonnement` /
/// `licenseExpires` / `licenseKey`.
Future<void> _applyRank(
  SharedPreferences prefs,
  UserRank rank,
  DateTime? expiresAt,
) async {
  await prefs.setString(AppConstants.keyUserRank, rank.name);
  await prefs.setString(AppConstants.keySubscriptionPlan, rank.name);
  if (expiresAt != null) {
    await prefs.setInt(
        AppConstants.keyLicenseExpires, expiresAt.millisecondsSinceEpoch);
  } else if (rank == UserRank.genin) {
    await prefs.remove(AppConstants.keyLicenseExpires);
  }
  _setStoredRank(rank);
  _providerContainer
      .read(userProfileProvider.notifier)
      .updateIdentity(rank: rank.name);
}
