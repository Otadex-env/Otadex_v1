import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Identifiants AdMob.
///
/// - Debug / profile : TOUJOURS le bloc de test officiel Google. Cliquer sur
///   ses propres vraies annonces peut faire suspendre le compte AdMob.
/// - Release : `ADMOB_BANNER_ID` du fichier `.env` (identifiant public). Vide
///   ou absent → aucune publicité, jamais d'annonce de test chez un testeur.
///
/// L'« App ID » AdMob est, lui, lu par Gradle (voir `android/app/build.gradle.kts`).
class AdConfig {
  AdConfig._();

  static const String _testBannerId = 'ca-app-pub-3940256099942544/9214589741';

  static String get bannerUnitId {
    if (!kReleaseMode) return _testBannerId;
    if (!dotenv.isInitialized) return '';
    return (dotenv.maybeGet('ADMOB_BANNER_ID') ?? '').trim();
  }
}
