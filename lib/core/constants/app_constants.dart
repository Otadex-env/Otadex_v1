class AppConstants {
  AppConstants._();

  // SharedPreferences keys
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserRank = 'user_rank';

  // Post-login onboarding keys
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyBirthDate = 'user_birth_date';
  static const String keyUserAge = 'user_age';
  static const String keyUserInterests = 'user_interests';

  // Ranks
  static const String rankGenin = 'genin';
  static const String rankJonin = 'jonin';
  static const String rankKage = 'kage';

  // Splash
  static const Duration splashDuration = Duration(milliseconds: 3500);

  // App info
  static const String appName = 'OTADEX';
  static const String appTagline = 'The Ultimate Anime Character Encyclopedia';
}
