class AppConstants {
  AppConstants._();

  // SharedPreferences keys — auth
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyIsLoggedIn = 'is_logged_in';
  static const String keyOnboardingCompleted = 'onboarding_completed';

  // SharedPreferences keys — user identity
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserPseudo = 'user_pseudo';
  static const String keyUserDisplayName = 'user_display_name';
  static const String keyUserAvatarUrl = 'user_avatar_url';
  static const String keyUserRank = 'user_rank';
  static const String keyUserCurrency = 'user_currency';
  static const String keySubscriptionPlan = 'subscription_plan';
  static const String keyLicenseExpires = 'license_expires';
  static const String keyLicenseKey = 'license_key';

  // SharedPreferences keys — onboarding data
  static const String keyBirthDate = 'user_birth_date';
  static const String keyUserAge = 'user_age';
  static const String keyUserInterests = 'user_interests';

  // Ranks
  static const String rankGenin = 'genin';
  static const String rankJonin = 'jonin';
  static const String rankKage = 'kage';

  // Subscription plans
  static const String planFree = 'free';
  static const String planJonin = 'jonin';
  static const String planKage = 'kage';

  // Splash
  static const Duration splashDuration = Duration(milliseconds: 3500);

  // App info
  static const String appName = 'OTADEX';
  static const String appVersion = '1.5.0';
  static const String appTagline = 'The Ultimate Anime Character Encyclopedia';
}
