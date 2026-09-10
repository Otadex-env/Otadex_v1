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
  // Override rang du menu développeur — n'influence JAMAIS le rang réel.
  static const String keyDevRankOverride = 'dev_rank_override';
  static const String keySubscriptionPlan = 'subscription_plan';
  static const String keyLicenseExpires = 'license_expires';
  static const String keyLicenseKey = 'license_key';
  /// Dernière revalidation licence auprès du Worker (epoch ms). Sert à limiter
  /// les appels `/refresh` sur les `resume` rapprochés.
  static const String keyLastLicenseRefresh = 'last_license_refresh';

  // SharedPreferences keys — notifications
  static const String keyNotificationsEnabled = 'notifications_enabled';

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
  static const String appVersion = '1.0.0';
  static const String appTagline = 'The Ultimate Anime Character Encyclopedia';
}

// ── Firestore ────────────────────────────────────────────────────────────────
/// Champ `users/{uid}` portant le rang réel de l'utilisateur.
/// Écrit UNIQUEMENT côté serveur / activation licence — jamais par un widget.
const String kFieldAbonnement = 'abonnement';

// ── Plans payants ────────────────────────────────────────────────────────────
/// Active les parcours d'ACHAT hors Google Play Billing : liens store Chariow,
/// prix affichés dans un contexte d'achat, boutons « Passer Jonin/Kage » et
/// « Passer au premium », `showSubscriptionModal`, bandeau « Passe Kage » du
/// profil, section Support de la page Profil.
///
/// `false` par défaut : la soumission Play Store interdit de rediriger vers un
/// paiement externe pour du contenu numérique.
///
/// Ne contrôle PAS l'activation de licence par clé — voir [kEnableLicenseEntry].
/// N'affecte NI le menu développeur NI l'override de rang (`devRankOverrideProvider`).
/// Les cartes de plan restent visibles et informatives (features + prix FCFA)
/// quelle que soit la valeur du flag.
const bool kEnablePaidPlans = false;

/// Active le point d'entrée d'activation de licence par clé (champ de saisie
/// + bouton « Activer »).
///
/// Indépendant de [kEnablePaidPlans] : un champ de saisie de clé, SANS prix,
/// lien store ni CTA d'achat, est conforme Play Store (modèle des apps de
/// streaming dont l'abonnement se souscrit ailleurs). La redirection vers un
/// paiement externe — le seul point bloquant — reste gouvernée par
/// [kEnablePaidPlans].
///
/// `true` débloque : la route `/activate-license`, le bouton discret
/// « J'ai une clé de licence » en bas de l'écran Plans, l'entrée
/// Profil > Compte, le bouton de la carte Abonnement (Genin), et l'écran
/// d'activation lui-même (champ + bouton Activer, aucun texte d'achat).
const bool kEnableLicenseEntry = true;
