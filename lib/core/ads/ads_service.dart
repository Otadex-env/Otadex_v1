import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Consentement RGPD (SDK UMP de Google) puis démarrage du SDK publicitaire.
///
/// Rien ici n'est appelé au lancement de l'app : seule une bannière réellement
/// affichée (donc un rang Genin) déclenche [ensureStarted]. Un abonné Jonin ou
/// Kage ne voit ni formulaire de consentement ni requête publicitaire.
class AdsService {
  AdsService._();

  /// `true` dès que le SDK est démarré ET que le consentement autorise les
  /// requêtes.
  static final ValueNotifier<bool> ready = ValueNotifier(false);

  /// `true` quand le RGPD impose un accès permanent aux choix de consentement.
  static final ValueNotifier<bool> privacyOptionsRequired =
      ValueNotifier(false);

  static Future<void>? _starting;
  static bool _sdkInitialized = false;

  static Future<void> ensureStarted() =>
      _starting ??= _start().catchError((Object e) {
        // Best-effort : sans publicité l'app fonctionne ; on retentera à la
        // prochaine bannière.
        debugPrint('AdsService: $e');
        _starting = null;
      });

  static Future<void> _start() async {
    final prefs = await SharedPreferences.getInstance();
    final age = prefs.getInt(AppConstants.keyUserAge);
    // 16 ans : âge du consentement RGPD le plus strict.
    final underAge = age != null && age < 16;

    await _gatherConsent(underAge);
    await _refreshPrivacyOptions();
    // Hors ligne, `canRequestAds` reprend le choix d'une session précédente.
    if (!await ConsentInformation.instance.canRequestAds()) {
      _starting = null;
      return;
    }
    await _initializeSdk(underAge);
  }

  static Future<void> _initializeSdk(bool underAge) async {
    if (!_sdkInitialized) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          // Public à partir de 13 ans.
          maxAdContentRating: MaxAdContentRating.t,
          ageRestrictedTreatment: underAge ? AgeRestrictedTreatment.teen : null,
        ),
      );
      await MobileAds.instance.initialize();
      _sdkInitialized = true;
    }
    ready.value = true;
  }

  static Future<void> _gatherConsent(bool underAge) {
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(tagForUnderAgeOfConsent: underAge),
      () => ConsentForm.loadAndShowConsentFormIfRequired((error) {
        if (error != null) debugPrint('UMP: ${error.message}');
        done.complete();
      }),
      (error) {
        debugPrint('UMP: ${error.message}');
        done.complete();
      },
    );
    return done.future;
  }

  static Future<void> _refreshPrivacyOptions() async {
    privacyOptionsRequired.value = await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  }

  /// Rouvre le formulaire de choix (réglages du profil).
  static Future<void> showPrivacyOptions() async {
    await ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) debugPrint('UMP: ${error.message}');
    });
    // Le choix a pu changer : on recrée les bannières.
    ready.value = false;
    _starting = null;
    await ensureStarted();
  }
}
