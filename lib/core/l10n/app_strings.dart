import 'package:flutter/material.dart';
import 'app_locale.dart';

class AppStrings {
  const AppStrings({
    // Profile tabs
    required this.collection,
    required this.badges,
    required this.activity,
    required this.myCollection,
    required this.manage,
    required this.level,
    required this.ptsForKageSupreme,
    required this.noBadgesYet,
    required this.recentActivityHere,
    // Subscription card
    required this.settingsAndSubscription,
    required this.geninPlanLabel,
    required this.freeLabel,
    required this.basicPlanNoRenewal,
    required this.upgradeToJonin,
    required this.manageSubscription,
    required this.active,
    // Kage banner
    required this.kageBannerText,
    required this.seeOffer,
    // Plan section
    required this.changePlan,
    required this.monthly,
    required this.annual,
    required this.currentPlanTag,
    required this.planActualButton,
    required this.upgradeToJoninButton,
    required this.upgradeToKageButton,
    required this.joninMonthlyPrice,
    required this.joninAnnualPrice,
    required this.kageMonthlyPrice,
    required this.kageAnnualPrice,
    // Plan features
    required this.sheetsNavigation,
    required this.likesComments,
    required this.adsShown,
    required this.aiDisabled,
    required this.unlimitedCollection,
    required this.noAds,
    required this.aiChatbot,
    required this.joninBadge,
    required this.joninIncluded,
    required this.aiImageGen,
    required this.noWatermark,
    required this.exclusiveThemes,
    // Settings sections
    required this.accountSection,
    required this.preferencesSection,
    required this.contentSection,
    required this.aboutSection,
    // Settings rows
    required this.editProfile,
    required this.changePassword,
    required this.email,
    required this.theme,
    required this.darkTheme,
    required this.notifications,
    required this.language,
    required this.languageValue,
    required this.kageTheme,
    required this.locked,
    required this.hiddenCategories,
    required this.hiddenCount,
    required this.myHistory,
    required this.clearCache,
    required this.cacheSize,
    required this.otadexVersion,
    required this.termsOfService,
    required this.privacyPolicy,
    required this.rateApp,
    // Logout
    required this.logout,
    required this.appVersion,
    // Search
    required this.searchHint,
    required this.recentSearches,
    required this.clearAll,
    required this.exploreByCategory,
    required this.trendingNow,
    required this.cancel,
    required this.youMightAlsoLike,
    required this.characters,
    required this.animes,
    required this.creators,
    required this.all,
  });

  // Profile tabs
  final String collection;
  final String badges;
  final String activity;
  final String myCollection;
  final String manage;
  final String level;
  final String ptsForKageSupreme;
  final String noBadgesYet;
  final String recentActivityHere;
  // Subscription card
  final String settingsAndSubscription;
  final String geninPlanLabel;
  final String freeLabel;
  final String basicPlanNoRenewal;
  final String upgradeToJonin;
  final String manageSubscription;
  final String active;
  // Kage banner
  final String kageBannerText;
  final String seeOffer;
  // Plan section
  final String changePlan;
  final String monthly;
  final String annual;
  final String currentPlanTag;
  final String planActualButton;
  final String upgradeToJoninButton;
  final String upgradeToKageButton;
  final String joninMonthlyPrice;
  final String joninAnnualPrice;
  final String kageMonthlyPrice;
  final String kageAnnualPrice;
  // Plan features
  final String sheetsNavigation;
  final String likesComments;
  final String adsShown;
  final String aiDisabled;
  final String unlimitedCollection;
  final String noAds;
  final String aiChatbot;
  final String joninBadge;
  final String joninIncluded;
  final String aiImageGen;
  final String noWatermark;
  final String exclusiveThemes;
  // Settings sections
  final String accountSection;
  final String preferencesSection;
  final String contentSection;
  final String aboutSection;
  // Settings rows
  final String editProfile;
  final String changePassword;
  final String email;
  final String theme;
  final String darkTheme;
  final String notifications;
  final String language;
  final String languageValue;
  final String kageTheme;
  final String locked;
  final String hiddenCategories;
  final String hiddenCount;
  final String myHistory;
  final String clearCache;
  final String cacheSize;
  final String otadexVersion;
  final String termsOfService;
  final String privacyPolicy;
  final String rateApp;
  // Logout
  final String logout;
  final String appVersion;
  // Search
  final String searchHint;
  final String recentSearches;
  final String clearAll;
  final String exploreByCategory;
  final String trendingNow;
  final String cancel;
  final String youMightAlsoLike;
  final String characters;
  final String animes;
  final String creators;
  final String all;

  static AppStrings of(BuildContext context) => AppLocale.of(context);

  static AppStrings forLocale(String locale) => locale == 'en' ? _en : _fr;

  static const AppStrings _fr = AppStrings(
    // Profile tabs
    collection: 'Collection',
    badges: 'Badges',
    activity: 'Activité',
    myCollection: 'Ma Collection',
    manage: 'Gérer',
    level: 'Niveau',
    ptsForKageSupreme: 'pts pour Kage Suprême',
    noBadgesYet: "Aucun badge pour l'instant",
    recentActivityHere: 'Ton activité récente apparaîtra ici',
    // Subscription card
    settingsAndSubscription: 'Paramètres & Abonnement',
    geninPlanLabel: 'GENIN',
    freeLabel: 'Gratuit',
    basicPlanNoRenewal: 'Plan de base · Aucun renouvellement',
    upgradeToJonin: 'Passer au Jonin 🦊',
    manageSubscription: "Gérer l'abonnement",
    active: 'ACTIF',
    // Kage banner
    kageBannerText: 'Passe Kage — IA images + téléchargement propre',
    seeOffer: 'Voir →',
    // Plan section
    changePlan: 'Changer de plan',
    monthly: 'Mensuel',
    annual: 'Annuel',
    currentPlanTag: 'PLAN ACTUEL ✓',
    planActualButton: 'Plan actuel',
    upgradeToJoninButton: 'Passer Jonin 🦊',
    upgradeToKageButton: 'Passer Kage 👑',
    joninMonthlyPrice: '2 000 FCFA/mois',
    joninAnnualPrice: '1 800 FCFA/mois',
    kageMonthlyPrice: '5 000 FCFA/mois',
    kageAnnualPrice: '4 500 FCFA/mois',
    // Plan features
    sheetsNavigation: 'Fiches & navigation',
    likesComments: 'Likes & commentaires',
    adsShown: 'Publicités affichées',
    aiDisabled: 'IA désactivée',
    unlimitedCollection: 'Collection illimitée',
    noAds: 'Sans publicités',
    aiChatbot: 'IA chatbot + quiz',
    joninBadge: 'Badge Jonin 🦊',
    joninIncluded: 'Tout Jonin inclus',
    aiImageGen: 'Génération images IA ⭐',
    noWatermark: 'Sans watermark',
    exclusiveThemes: 'Thèmes exclusifs 👑',
    // Settings sections
    accountSection: 'COMPTE',
    preferencesSection: 'PRÉFÉRENCES',
    contentSection: 'CONTENU',
    aboutSection: 'À PROPOS',
    // Settings rows
    editProfile: 'Modifier le profil',
    changePassword: 'Changer le mot de passe',
    email: 'Email',
    theme: 'Thème',
    darkTheme: 'Sombre',
    notifications: 'Notifications',
    language: 'Langue',
    languageValue: 'Français',
    kageTheme: 'Thème Kage',
    locked: 'Verrouillé 🔒',
    hiddenCategories: 'Catégories masquées',
    hiddenCount: '0 masquées',
    myHistory: 'Mon historique',
    clearCache: 'Vider le cache',
    cacheSize: '24 MB',
    otadexVersion: 'Version OTADEX',
    termsOfService: "Conditions d'utilisation",
    privacyPolicy: 'Politique de confidentialité',
    rateApp: "Noter l'app",
    // Logout
    logout: 'Se déconnecter',
    appVersion: 'OTADEX · v1.0.0',
    // Search
    searchHint: 'Personnage, animé, créateur...',
    recentSearches: 'RECHERCHES RÉCENTES',
    clearAll: 'Effacer tout',
    exploreByCategory: 'Explorer par catégorie',
    trendingNow: '🔥 Tendances du moment',
    cancel: 'Annuler',
    youMightAlsoLike: 'Tu pourrais aussi aimer',
    characters: 'Personnages',
    animes: 'Animés',
    creators: 'Créateurs',
    all: 'Tous',
  );

  static const AppStrings _en = AppStrings(
    // Profile tabs
    collection: 'Collection',
    badges: 'Badges',
    activity: 'Activity',
    myCollection: 'My Collection',
    manage: 'Manage',
    level: 'Level',
    ptsForKageSupreme: 'pts to Kage Supreme',
    noBadgesYet: 'No badges yet',
    recentActivityHere: 'Your recent activity will appear here',
    // Subscription card
    settingsAndSubscription: 'Settings & Subscription',
    geninPlanLabel: 'GENIN',
    freeLabel: 'Free',
    basicPlanNoRenewal: 'Basic plan · No renewal',
    upgradeToJonin: 'Upgrade to Jonin 🦊',
    manageSubscription: 'Manage subscription',
    active: 'ACTIVE',
    // Kage banner
    kageBannerText: 'Kage Pass — AI images + clean download',
    seeOffer: 'See →',
    // Plan section
    changePlan: 'Change plan',
    monthly: 'Monthly',
    annual: 'Annual',
    currentPlanTag: 'CURRENT PLAN ✓',
    planActualButton: 'Current plan',
    upgradeToJoninButton: 'Get Jonin 🦊',
    upgradeToKageButton: 'Get Kage 👑',
    joninMonthlyPrice: '2,000 FCFA/mo',
    joninAnnualPrice: '1,800 FCFA/mo',
    kageMonthlyPrice: '5,000 FCFA/mo',
    kageAnnualPrice: '4,500 FCFA/mo',
    // Plan features
    sheetsNavigation: 'Profiles & navigation',
    likesComments: 'Likes & comments',
    adsShown: 'Ads displayed',
    aiDisabled: 'AI disabled',
    unlimitedCollection: 'Unlimited collection',
    noAds: 'No ads',
    aiChatbot: 'AI chatbot + quiz',
    joninBadge: 'Jonin Badge 🦊',
    joninIncluded: 'All Jonin features',
    aiImageGen: 'AI image generation ⭐',
    noWatermark: 'No watermark',
    exclusiveThemes: 'Exclusive themes 👑',
    // Settings sections
    accountSection: 'ACCOUNT',
    preferencesSection: 'PREFERENCES',
    contentSection: 'CONTENT',
    aboutSection: 'ABOUT',
    // Settings rows
    editProfile: 'Edit profile',
    changePassword: 'Change password',
    email: 'Email',
    theme: 'Theme',
    darkTheme: 'Dark',
    notifications: 'Notifications',
    language: 'Language',
    languageValue: 'English',
    kageTheme: 'Kage Theme',
    locked: 'Locked 🔒',
    hiddenCategories: 'Hidden categories',
    hiddenCount: '0 hidden',
    myHistory: 'My history',
    clearCache: 'Clear cache',
    cacheSize: '24 MB',
    otadexVersion: 'OTADEX Version',
    termsOfService: 'Terms of service',
    privacyPolicy: 'Privacy policy',
    rateApp: 'Rate the app',
    // Logout
    logout: 'Log out',
    appVersion: 'OTADEX · v1.0.0',
    // Search
    searchHint: 'Character, anime, creator...',
    recentSearches: 'RECENT SEARCHES',
    clearAll: 'Clear all',
    exploreByCategory: 'Explore by category',
    trendingNow: '🔥 Trending now',
    cancel: 'Cancel',
    youMightAlsoLike: 'You might also like',
    characters: 'Characters',
    animes: 'Animes',
    creators: 'Creators',
    all: 'All',
  );
}
