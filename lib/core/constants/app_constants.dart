class AppConstants {
  AppConstants._();

  // SharedPreferences keys
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyUserRank = 'user_rank';

  // Ranks
  static const String rankGenin = 'genin';
  static const String rankJonin = 'jonin';
  static const String rankKage = 'kage';

  // Splash
  static const Duration splashDuration = Duration(milliseconds: 2500);

  // App info
  static const String appName = 'OTADEX';
  static const String appTagline = 'The Ultimate Anime Character Encyclopedia';
}
