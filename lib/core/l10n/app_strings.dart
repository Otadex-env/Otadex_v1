import 'package:flutter/material.dart';
import 'app_locale.dart';

class AppStrings {
  const AppStrings({
    // ── Auth gate ──────────────────────────────────────────────────────────
    required this.authGateTitle,
    required this.authGateMessage,
    required this.login,
    required this.signUpFree,
    required this.continueAsGuest,
    // ── Login screen ───────────────────────────────────────────────────────
    required this.welcomeBack,
    required this.loginSubtitle,
    required this.emailLabel,
    required this.emailAddressLabel,
    required this.emailRequired,
    required this.emailInvalid,
    required this.passwordLabel,
    required this.confirmPasswordLabel,
    required this.passwordRequired,
    required this.passwordMinLength,
    required this.passwordsMismatch,
    required this.forgotPassword,
    required this.orSeparator,
    required this.continueWithGoogle,
    required this.noAccountYet,
    required this.becomeGenin,
    required this.googleAuthCancelled,
    // ── Register screen ────────────────────────────────────────────────────
    required this.createAccount,
    required this.joinFansSubtitle,
    required this.pseudoLabel,
    required this.pseudoRequired,
    required this.pseudoMinLength,
    required this.chooseStartingRank,
    required this.canChangeLater,
    required this.acceptTermsPrefix,
    required this.termsWord,
    required this.acceptTermsConjunction,
    required this.privacyWord,
    required this.acceptTermsError,
    required this.createAccountButton,
    required this.alreadyHaveAccount,
    required this.googleLinked,
    // ── Onboarding ─────────────────────────────────────────────────────────
    required this.skip,
    required this.slide1TitleUniverse,
    required this.slide1TitleAnime,
    required this.slide1TitlePocket,
    required this.slide1Subtitle,
    required this.slide2TitleExplore,
    required this.slide2TitleCount,
    required this.slide2TitleCharacters,
    required this.slide2Subtitle,
    required this.slide2Button,
    required this.slide3Title,
    required this.slide3Subtitle,
    required this.rankGeninFreeLabel,
    required this.rankGeninDesc,
    required this.rankJoninDesc,
    required this.rankKageDesc,
    required this.premiumBadgeLabel,
    required this.startAdventureButton,
    required this.canChangeRankLater,
    // ── Subscription modal ─────────────────────────────────────────────────
    required this.subscriptionRankUpgradeTitle,
    required this.subscriptionRankUpgradeDesc,
    required this.subscriptionBillingMonthly,
    required this.subscriptionBillingAnnual,
    required this.subscriptionSave10,
    required this.subscriptionAllDevices,
    required this.subscriptionObtainPass,
    required this.subscriptionAlreadyLicense,
    required this.subscriptionFeaturesTitle,
    required this.joninFeature1Title,
    required this.joninFeature1Desc,
    required this.joninFeature2Title,
    required this.joninFeature2Desc,
    required this.joninFeature3Title,
    required this.joninFeature3Desc,
    required this.joninFeature4Title,
    required this.joninFeature4Desc,
    required this.kageFeature1Title,
    required this.kageFeature1Desc,
    required this.kageFeature2Title,
    required this.kageFeature2Desc,
    required this.kageFeature3Title,
    required this.kageFeature3Desc,
    required this.kageFeature4Title,
    required this.kageFeature4Desc,
    // ── Profile tabs ───────────────────────────────────────────────────────
    required this.collection,
    required this.badges,
    required this.activity,
    required this.myCollection,
    required this.manage,
    required this.level,
    required this.ptsForKageSupreme,
    required this.noBadgesYet,
    required this.recentActivityHere,
    // ── Subscription card ──────────────────────────────────────────────────
    required this.settingsAndSubscription,
    required this.geninPlanLabel,
    required this.freeLabel,
    required this.basicPlanNoRenewal,
    required this.upgradeToJonin,
    required this.manageSubscription,
    required this.active,
    // ── Kage banner ────────────────────────────────────────────────────────
    required this.kageBannerText,
    required this.seeOffer,
    // ── Plan section ───────────────────────────────────────────────────────
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
    // ── Plan features (comparison cards) ──────────────────────────────────
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
    // ── Settings sections ──────────────────────────────────────────────────
    required this.accountSection,
    required this.preferencesSection,
    required this.contentSection,
    required this.aboutSection,
    // ── Settings rows ──────────────────────────────────────────────────────
    required this.editProfile,
    required this.changePassword,
    required this.theme,
    required this.darkTheme,
    required this.lightTheme,
    required this.notifications,
    required this.language,
    required this.languageValue,
    required this.selectLanguage,
    required this.apply,
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
    // ── Logout ─────────────────────────────────────────────────────────────
    required this.logout,
    required this.appVersion,
    // ── Search ─────────────────────────────────────────────────────────────
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
    required this.placeholdertext1,
    required this.saveChanges,
    required this.currentPassword,
    required this.bioLabel,
    required this.profileUpdated,
    required this.passwordChanged,
  });

  // ── Auth gate ──────────────────────────────────────────────────────────────
  final String authGateTitle;
  final String authGateMessage;
  final String login;
  final String signUpFree;
  final String continueAsGuest;
  // ── Login screen ───────────────────────────────────────────────────────────
  final String welcomeBack;
  final String loginSubtitle;
  final String emailLabel;
  final String emailAddressLabel;
  final String emailRequired;
  final String emailInvalid;
  final String passwordLabel;
  final String confirmPasswordLabel;
  final String passwordRequired;
  final String passwordMinLength;
  final String passwordsMismatch;
  final String forgotPassword;
  final String orSeparator;
  final String continueWithGoogle;
  final String noAccountYet;
  final String becomeGenin;
  final String googleAuthCancelled;
  // ── Register screen ────────────────────────────────────────────────────────
  final String createAccount;
  final String joinFansSubtitle;
  final String pseudoLabel;
  final String pseudoRequired;
  final String pseudoMinLength;
  final String chooseStartingRank;
  final String canChangeLater;
  final String acceptTermsPrefix;
  final String termsWord;
  final String acceptTermsConjunction;
  final String privacyWord;
  final String acceptTermsError;
  final String createAccountButton;
  final String alreadyHaveAccount;
  final String googleLinked;
  // ── Onboarding ─────────────────────────────────────────────────────────────
  final String skip;
  final String slide1TitleUniverse;
  final String slide1TitleAnime;
  final String slide1TitlePocket;
  final String slide1Subtitle;
  final String slide2TitleExplore;
  final String slide2TitleCount;
  final String slide2TitleCharacters;
  final String slide2Subtitle;
  final String slide2Button;
  final String slide3Title;
  final String slide3Subtitle;
  final String rankGeninFreeLabel;
  final String rankGeninDesc;
  final String rankJoninDesc;
  final String rankKageDesc;
  final String premiumBadgeLabel;
  final String startAdventureButton;
  final String canChangeRankLater;
  // ── Subscription modal ─────────────────────────────────────────────────────
  final String subscriptionRankUpgradeTitle;
  final String subscriptionRankUpgradeDesc;
  final String subscriptionBillingMonthly;
  final String subscriptionBillingAnnual;
  final String subscriptionSave10;
  final String subscriptionAllDevices;
  final String subscriptionObtainPass;
  final String subscriptionAlreadyLicense;
  final String subscriptionFeaturesTitle;
  final String joninFeature1Title;
  final String joninFeature1Desc;
  final String joninFeature2Title;
  final String joninFeature2Desc;
  final String joninFeature3Title;
  final String joninFeature3Desc;
  final String joninFeature4Title;
  final String joninFeature4Desc;
  final String kageFeature1Title;
  final String kageFeature1Desc;
  final String kageFeature2Title;
  final String kageFeature2Desc;
  final String kageFeature3Title;
  final String kageFeature3Desc;
  final String kageFeature4Title;
  final String kageFeature4Desc;
  // ── Profile tabs ───────────────────────────────────────────────────────────
  final String collection;
  final String badges;
  final String activity;
  final String myCollection;
  final String manage;
  final String level;
  final String ptsForKageSupreme;
  final String noBadgesYet;
  final String recentActivityHere;
  // ── Subscription card ──────────────────────────────────────────────────────
  final String settingsAndSubscription;
  final String geninPlanLabel;
  final String freeLabel;
  final String basicPlanNoRenewal;
  final String upgradeToJonin;
  final String manageSubscription;
  final String active;
  // ── Kage banner ────────────────────────────────────────────────────────────
  final String kageBannerText;
  final String seeOffer;
  // ── Plan section ───────────────────────────────────────────────────────────
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
  // ── Plan features (comparison cards) ──────────────────────────────────────
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
  // ── Settings sections ──────────────────────────────────────────────────────
  final String accountSection;
  final String preferencesSection;
  final String contentSection;
  final String aboutSection;
  // ── Settings rows ──────────────────────────────────────────────────────────
  final String editProfile;
  final String changePassword;
  final String theme;
  final String darkTheme;
  final String lightTheme;
  final String notifications;
  final String language;
  final String languageValue;
  final String selectLanguage;
  final String apply;
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
  // ── Logout ─────────────────────────────────────────────────────────────────
  final String logout;
  final String appVersion;
  // ── Search ─────────────────────────────────────────────────────────────────
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
  final String placeholdertext1;
  final String saveChanges;
  final String currentPassword;
  final String bioLabel;
  final String profileUpdated;
  final String passwordChanged;

  static AppStrings of(BuildContext context) => AppLocale.of(context);

  static AppStrings forLocale(String locale) => switch (locale) {
        'en' => _en,
        'ja' => _ja,
        'zh' => _zh,
        _ => _fr,
      };

  // Annual prices = monthly × 0.9 × 12
  // Jonin: 2000 × 0.9 × 12 = 21 600 FCFA/an
  // Kage:  5000 × 0.9 × 12 = 54 000 FCFA/an

  static const AppStrings _fr = AppStrings(
      // Auth gate
      authGateTitle: 'Connecte-toi pour continuer',
      authGateMessage:
          'Crée un compte gratuit pour accéder au profil,\nta collection et bien plus.',
      login: 'Se connecter',
      signUpFree: "S'inscrire gratuitement",
      continueAsGuest: 'Continuer sans compte',
      // Login screen
      welcomeBack: 'Bon retour, ninja 🥷',
      loginSubtitle: 'Connecte-toi pour continuer ta quête',
      emailLabel: 'Email',
      emailAddressLabel: 'Adresse e-mail',
      emailRequired: 'Email requis',
      emailInvalid: 'Email invalide',
      passwordLabel: 'Mot de passe',
      confirmPasswordLabel: 'Confirmer mot de passe',
      passwordRequired: 'Mot de passe requis',
      passwordMinLength: 'Minimum 6 caractères',
      passwordsMismatch: 'Les mots de passe ne correspondent pas',
      forgotPassword: 'Mot de passe oublié ?',
      orSeparator: 'ou',
      continueWithGoogle: 'Continuer avec Google',
      noAccountYet: 'Pas encore de compte ?',
      becomeGenin: 'Deviens Genin',
      googleAuthCancelled: 'Connexion Google annulée ou non configurée',
      // Register screen
      createAccount: 'Crée ton compte',
      joinFansSubtitle: 'Rejoins des milliers de fans otaku',
      pseudoLabel: 'Pseudo / Nom de ninja',
      pseudoRequired: 'Pseudo requis',
      pseudoMinLength: 'Minimum 3 caractères',
      chooseStartingRank: 'Choisis ton rang de départ',
      canChangeLater: 'Tu pourras changer plus tard',
      acceptTermsPrefix: "J'accepte les ",
      termsWord: 'Conditions',
      acceptTermsConjunction: ' et la ',
      privacyWord: 'Confidentialité',
      acceptTermsError: 'Accepte les conditions pour continuer',
      createAccountButton: 'Créer mon compte →',
      alreadyHaveAccount: 'Déjà un compte ?',
      googleLinked: 'Compte Google lié — choisis ton rang et confirme',
      // Onboarding
      skip: 'Passer',
      slide1TitleUniverse: "L'univers",
      slide1TitleAnime: 'Animé',
      slide1TitlePocket: 'dans ta poche',
      slide1Subtitle:
          'Personnages · Séries · Univers\nTout ce que tu aimes, en un seul endroit.',
      slide2TitleExplore: 'Explore',
      slide2TitleCount: '10 000+',
      slide2TitleCharacters: 'personnages',
      slide2Subtitle:
          'Fiches complètes · Galeries images\nCitations exclusives',
      slide2Button: 'Découvrir →',
      slide3Title: 'Quel fan es-tu ?',
      slide3Subtitle: 'Choisis ta voie, grimpe les rangs',
      rankGeninFreeLabel: 'GRATUIT',
      rankGeninDesc: 'Accès gratuit · Découverte',
      rankJoninDesc: 'Sans pub · Collections avancées',
      rankKageDesc: 'Accès IA · Exclusif · Statut ultime',
      premiumBadgeLabel: 'PREMIUM',
      startAdventureButton: "Commencer l'aventure →",
      canChangeRankLater: 'Tu pourras changer de rang plus tard',
      // Subscription modal
      subscriptionRankUpgradeTitle: 'Passe au rang',
      subscriptionRankUpgradeDesc:
          'Débloque les fonctionnalités exclusives\nréservées aux ninja de rang',
      subscriptionBillingMonthly: 'Mensuel',
      subscriptionBillingAnnual: 'Annuel',
      subscriptionSave10: 'Économisez 10%',
      subscriptionAllDevices: 'Utilisable sur tous tes appareils',
      subscriptionObtainPass: 'Obtenir le Pass',
      subscriptionAlreadyLicense: 'Tu as déjà une licence ?',
      subscriptionFeaturesTitle: 'Fonctionnalités',
      joninFeature1Title: 'Collection illimitée',
      joninFeature1Desc:
          "Collectionne tous les personnages de l'encyclopédie sans aucune limite.",
      joninFeature2Title: 'Sans publicités',
      joninFeature2Desc:
          "Profite de l'expérience OTADEX sans interruption publicitaire.",
      joninFeature3Title: 'IA chatbot + quiz',
      joninFeature3Desc:
          "Pose des questions sur tes personnages préférés et teste tes connaissances avec l'IA.",
      joninFeature4Title: 'Badge Jonin 🦊',
      joninFeature4Desc:
          'Affiche ton rang Jonin sur ton profil et dans les commentaires.',
      kageFeature1Title: 'Tout le Pass Jonin inclus',
      kageFeature1Desc:
          'Toutes les fonctionnalités du rang Jonin sont incluses dans le Pass Kage.',
      kageFeature2Title: 'Génération images IA ⭐',
      kageFeature2Desc:
          "Génère des illustrations uniques de tes personnages préférés grâce à l'IA.",
      kageFeature3Title: 'Téléchargement sans watermark',
      kageFeature3Desc:
          'Télécharge toutes les illustrations en haute qualité sans filigrane OTADEX.',
      kageFeature4Title: 'Thèmes exclusifs 👑',
      kageFeature4Desc:
          'Débloque les thèmes visuels réservés aux ninja de rang Kage.',
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
      settingsAndSubscription: 'Paramètres & Abonnement',
      geninPlanLabel: 'GENIN',
      freeLabel: 'Gratuit',
      basicPlanNoRenewal: 'Plan de base · Aucun renouvellement',
      upgradeToJonin: 'Passer au Jonin 🦊',
      manageSubscription: "Gérer l'abonnement",
      active: 'ACTIF',
      kageBannerText: 'Passe Kage — IA images + téléchargement propre',
      seeOffer: 'Voir →',
      changePlan: 'Changer de plan',
      monthly: 'Mensuel',
      annual: 'Annuel',
      currentPlanTag: 'PLAN ACTUEL ✓',
      planActualButton: 'Plan actuel',
      upgradeToJoninButton: 'Passer Jonin 🦊',
      upgradeToKageButton: 'Passer Kage 👑',
      joninMonthlyPrice: '2 000 FCFA/mois',
      joninAnnualPrice: '21 600 FCFA/an',
      kageMonthlyPrice: '5 000 FCFA/mois',
      kageAnnualPrice: '54 000 FCFA/an',
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
      noWatermark: 'Sans filigrane',
      exclusiveThemes: 'Thèmes exclusifs 👑',
      accountSection: 'COMPTE',
      preferencesSection: 'PRÉFÉRENCES',
      contentSection: 'CONTENU',
      aboutSection: 'À PROPOS',
      editProfile: 'Modifier le profil',
      changePassword: 'Changer le mot de passe',
      theme: 'Thème',
      darkTheme: 'Sombre',
      lightTheme: 'Clair',
      notifications: 'Notifications',
      language: 'Langue',
      languageValue: 'Français',
      selectLanguage: 'Choisir la langue',
      apply: 'Appliquer',
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
      logout: 'Se déconnecter',
      appVersion: 'OTADEX · v1.0.0 par TilStack',
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
      placeholdertext1: 'Rechercher un personnage, un animé...',
      saveChanges: 'Enregistrer',
      currentPassword: 'Mot de passe actuel',
      bioLabel: 'Bio',
      profileUpdated: 'Profil mis à jour !',
      passwordChanged: 'Mot de passe modifié !');

  static const AppStrings _en = AppStrings(
    // Auth gate
    authGateTitle: 'Log in to continue',
    authGateMessage:
        'Create a free account to access your profile,\nyour collection and much more.',
    login: 'Log in',
    signUpFree: 'Sign up for free',
    continueAsGuest: 'Continue without account',
    // Login screen
    welcomeBack: 'Welcome back, ninja 🥷',
    loginSubtitle: 'Log in to continue your quest',
    emailLabel: 'Email',
    emailAddressLabel: 'E-mail address',
    emailRequired: 'Email required',
    emailInvalid: 'Invalid email',
    passwordLabel: 'Password',
    confirmPasswordLabel: 'Confirm password',
    passwordRequired: 'Password required',
    passwordMinLength: 'Minimum 6 characters',
    passwordsMismatch: 'Passwords do not match',
    forgotPassword: 'Forgot password?',
    orSeparator: 'or',
    continueWithGoogle: 'Continue with Google',
    noAccountYet: 'No account yet?',
    becomeGenin: 'Become a Genin',
    googleAuthCancelled: 'Google login cancelled or not configured',
    // Register screen
    createAccount: 'Create your account',
    joinFansSubtitle: 'Join thousands of otaku fans',
    pseudoLabel: 'Username / Ninja name',
    pseudoRequired: 'Username required',
    pseudoMinLength: 'Minimum 3 characters',
    chooseStartingRank: 'Choose your starting rank',
    canChangeLater: 'You can change it later',
    acceptTermsPrefix: 'I accept the ',
    termsWord: 'Terms',
    acceptTermsConjunction: ' and ',
    privacyWord: 'Privacy',
    acceptTermsError: 'Accept the terms to continue',
    createAccountButton: 'Create my account →',
    alreadyHaveAccount: 'Already have an account?',
    googleLinked: 'Google account linked — choose your rank and confirm',
    // Onboarding
    skip: 'Skip',
    slide1TitleUniverse: 'The anime',
    slide1TitleAnime: 'universe',
    slide1TitlePocket: 'in your pocket',
    slide1Subtitle:
        'Characters · Series · Universes\nEverything you love, in one place.',
    slide2TitleExplore: 'Explore',
    slide2TitleCount: '10,000+',
    slide2TitleCharacters: 'characters',
    slide2Subtitle: 'Complete profiles · Image galleries\nExclusive quotes',
    slide2Button: 'Discover →',
    slide3Title: 'What kind of fan are you?',
    slide3Subtitle: 'Choose your path, climb the ranks',
    rankGeninFreeLabel: 'FREE',
    rankGeninDesc: 'Free access · Discovery',
    rankJoninDesc: 'No ads · Advanced collections',
    rankKageDesc: 'AI access · Exclusive · Ultimate status',
    premiumBadgeLabel: 'PREMIUM',
    startAdventureButton: 'Start the adventure →',
    canChangeRankLater: 'You can change your rank later',
    // Subscription modal
    subscriptionRankUpgradeTitle: 'Upgrade to rank',
    subscriptionRankUpgradeDesc:
        'Unlock exclusive features\nreserved for ninja of rank',
    subscriptionBillingMonthly: 'Monthly',
    subscriptionBillingAnnual: 'Annual',
    subscriptionSave10: 'Save 10%',
    subscriptionAllDevices: 'Available on all your devices',
    subscriptionObtainPass: 'Get the Pass',
    subscriptionAlreadyLicense: 'Already have a license?',
    subscriptionFeaturesTitle: 'Features',
    joninFeature1Title: 'Unlimited collection',
    joninFeature1Desc:
        'Collect all characters from the encyclopedia without any limit.',
    joninFeature2Title: 'No ads',
    joninFeature2Desc:
        'Enjoy the OTADEX experience without any ad interruptions.',
    joninFeature3Title: 'AI chatbot + quiz',
    joninFeature3Desc:
        'Ask questions about your favourite characters and test your knowledge with AI.',
    joninFeature4Title: 'Jonin Badge 🦊',
    joninFeature4Desc:
        'Display your Jonin rank on your profile and in comments.',
    kageFeature1Title: 'Full Jonin Pass included',
    kageFeature1Desc: 'All Jonin rank features are included in the Kage Pass.',
    kageFeature2Title: 'AI image generation ⭐',
    kageFeature2Desc:
        'Generate unique illustrations of your favourite characters with AI.',
    kageFeature3Title: 'Watermark-free download',
    kageFeature3Desc:
        'Download all illustrations in high quality without the OTADEX watermark.',
    kageFeature4Title: 'Exclusive themes 👑',
    kageFeature4Desc: 'Unlock visual themes reserved for Kage rank ninjas.',
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
    settingsAndSubscription: 'Settings & Subscription',
    geninPlanLabel: 'GENIN',
    freeLabel: 'Free',
    basicPlanNoRenewal: 'Basic plan · No renewal',
    upgradeToJonin: 'Upgrade to Jonin 🦊',
    manageSubscription: 'Manage subscription',
    active: 'ACTIVE',
    kageBannerText: 'Kage Pass — AI images + clean download',
    seeOffer: 'See →',
    changePlan: 'Change plan',
    monthly: 'Monthly',
    annual: 'Annual',
    currentPlanTag: 'CURRENT PLAN ✓',
    planActualButton: 'Current plan',
    upgradeToJoninButton: 'Get Jonin 🦊',
    upgradeToKageButton: 'Get Kage 👑',
    joninMonthlyPrice: '2,000 FCFA/mo',
    joninAnnualPrice: '21,600 FCFA/yr',
    kageMonthlyPrice: '5,000 FCFA/mo',
    kageAnnualPrice: '54,000 FCFA/yr',
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
    accountSection: 'ACCOUNT',
    preferencesSection: 'PREFERENCES',
    contentSection: 'CONTENT',
    aboutSection: 'ABOUT',
    editProfile: 'Edit profile',
    changePassword: 'Change password',
    theme: 'Theme',
    darkTheme: 'Dark',
    lightTheme: 'Light',
    notifications: 'Notifications',
    language: 'Language',
    languageValue: 'English',
    selectLanguage: 'Select language',
    apply: 'Apply',
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
    logout: 'Log out',
    appVersion: 'OTADEX · v1.0.0 By TilStack',
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
    placeholdertext1: 'Search a character, an anime...',
    saveChanges: 'Save',
    currentPassword: 'Current password',
    bioLabel: 'Bio',
    profileUpdated: 'Profile updated!',
    passwordChanged: 'Password changed!',
  );

  static const AppStrings _ja = AppStrings(
    // Auth gate
    authGateTitle: 'ログインして続ける',
    authGateMessage: 'プロフィール、コレクションなどにアクセスするために\n無料アカウントを作成してください。',
    login: 'ログイン',
    signUpFree: '無料登録',
    continueAsGuest: 'アカウントなしで続ける',
    // Login screen
    welcomeBack: 'おかえり、ninja 🥷',
    loginSubtitle: 'クエストを続けるためにログインしよう',
    emailLabel: 'メール',
    emailAddressLabel: 'メールアドレス',
    emailRequired: 'メールは必須です',
    emailInvalid: '無効なメールアドレスです',
    passwordLabel: 'パスワード',
    confirmPasswordLabel: 'パスワードの確認',
    passwordRequired: 'パスワードは必須です',
    passwordMinLength: '6文字以上必要です',
    passwordsMismatch: 'パスワードが一致しません',
    forgotPassword: 'パスワードを忘れた？',
    orSeparator: 'または',
    continueWithGoogle: 'Googleで続ける',
    noAccountYet: 'まだアカウントがない？',
    becomeGenin: '下忍になる',
    googleAuthCancelled: 'Googleログインがキャンセルされたか設定されていません',
    // Register screen
    createAccount: 'アカウントを作成',
    joinFansSubtitle: '何千人ものオタクファンと一緒に',
    pseudoLabel: 'ユーザー名 / 忍者名',
    pseudoRequired: 'ユーザー名は必須です',
    pseudoMinLength: '3文字以上必要です',
    chooseStartingRank: 'スタートランクを選ぼう',
    canChangeLater: '後で変更できます',
    acceptTermsPrefix: '私は',
    termsWord: '利用規約',
    acceptTermsConjunction: 'と',
    privacyWord: 'プライバシーポリシー',
    acceptTermsError: '続けるには規約に同意してください',
    createAccountButton: 'アカウントを作成 →',
    alreadyHaveAccount: 'すでにアカウントをお持ちですか？',
    googleLinked: 'Googleアカウント連携済み — ランクを選んで確認してください',
    // Onboarding
    skip: 'スキップ',
    slide1TitleUniverse: 'アニメの',
    slide1TitleAnime: '世界',
    slide1TitlePocket: 'ポケットの中に',
    slide1Subtitle: 'キャラクター · シリーズ · 世界観\nあなたの好きなすべてが、一か所に。',
    slide2TitleExplore: '探索する',
    slide2TitleCount: '10,000+',
    slide2TitleCharacters: 'キャラクター',
    slide2Subtitle: '完全プロフィール · 画像ギャラリー\n限定名言',
    slide2Button: '発見する →',
    slide3Title: 'あなたはどんなファン？',
    slide3Subtitle: '道を選び、ランクを上げよう',
    rankGeninFreeLabel: '無料',
    rankGeninDesc: '無料アクセス · 発見',
    rankJoninDesc: '広告なし · 高度なコレクション',
    rankKageDesc: 'AIアクセス · 限定 · 最高ステータス',
    premiumBadgeLabel: 'プレミアム',
    startAdventureButton: '冒険を始める →',
    canChangeRankLater: 'ランクは後で変更できます',
    // Subscription modal
    subscriptionRankUpgradeTitle: 'ランクにアップグレード',
    subscriptionRankUpgradeDesc: 'ランクの忍者専用の\n限定機能をアンロックしよう',
    subscriptionBillingMonthly: '月払い',
    subscriptionBillingAnnual: '年払い',
    subscriptionSave10: '10%お得',
    subscriptionAllDevices: '全デバイスで使用可能',
    subscriptionObtainPass: 'パスを取得',
    subscriptionAlreadyLicense: 'すでにライセンスをお持ちですか？',
    subscriptionFeaturesTitle: '機能',
    joninFeature1Title: '無制限コレクション',
    joninFeature1Desc: '百科事典のすべてのキャラクターを制限なく収集できます。',
    joninFeature2Title: '広告なし',
    joninFeature2Desc: '広告なしでOTADEX体験をお楽しみください。',
    joninFeature3Title: 'AIチャット + クイズ',
    joninFeature3Desc: 'お気に入りのキャラクターについて質問し、AIで知識をテストしよう。',
    joninFeature4Title: 'ジョニンバッジ 🦊',
    joninFeature4Desc: 'プロフィールとコメントにジョニンランクを表示しよう。',
    kageFeature1Title: 'ジョニンパスすべて含む',
    kageFeature1Desc: 'ジョニンランクのすべての機能がカゲパスに含まれています。',
    kageFeature2Title: 'AI画像生成 ⭐',
    kageFeature2Desc: 'AIを使って好きなキャラクターのユニークなイラストを生成しよう。',
    kageFeature3Title: 'ウォーターマークなしダウンロード',
    kageFeature3Desc: 'OTADEXウォーターマークなしですべてのイラストを高品質でダウンロードできます。',
    kageFeature4Title: '限定テーマ 👑',
    kageFeature4Desc: 'カゲランクの忍者専用のビジュアルテーマをアンロックしよう。',
    // Profile tabs
    collection: 'コレクション',
    badges: 'バッジ',
    activity: 'アクティビティ',
    myCollection: 'マイコレクション',
    manage: '管理',
    level: 'レベル',
    ptsForKageSupreme: 'pts でカゲ最高位へ',
    noBadgesYet: 'まだバッジはありません',
    recentActivityHere: '最近のアクティビティがここに表示されます',
    settingsAndSubscription: '設定 & サブスクリプション',
    geninPlanLabel: 'GENIN',
    freeLabel: '無料',
    basicPlanNoRenewal: 'ベーシックプラン · 更新なし',
    upgradeToJonin: 'ジョニンにアップグレード 🦊',
    manageSubscription: 'サブスクリプション管理',
    active: 'アクティブ',
    kageBannerText: 'カゲパス — AIイメージ + ウォーターマークなし',
    seeOffer: '見る →',
    changePlan: 'プランを変更',
    monthly: '月払い',
    annual: '年払い',
    currentPlanTag: '現在のプラン ✓',
    planActualButton: '現在のプラン',
    upgradeToJoninButton: 'ジョニンへ 🦊',
    upgradeToKageButton: 'カゲへ 👑',
    joninMonthlyPrice: '2,000 FCFA/月',
    joninAnnualPrice: '21,600 FCFA/年',
    kageMonthlyPrice: '5,000 FCFA/月',
    kageAnnualPrice: '54,000 FCFA/年',
    sheetsNavigation: 'プロフィール & ナビ',
    likesComments: 'いいね & コメント',
    adsShown: '広告あり',
    aiDisabled: 'AI無効',
    unlimitedCollection: '無制限コレクション',
    noAds: '広告なし',
    aiChatbot: 'AIチャット + クイズ',
    joninBadge: 'ジョニンバッジ 🦊',
    joninIncluded: 'ジョニン全機能含む',
    aiImageGen: 'AI画像生成 ⭐',
    noWatermark: 'ウォーターマークなし',
    exclusiveThemes: '限定テーマ 👑',
    accountSection: 'アカウント',
    preferencesSection: '設定',
    contentSection: 'コンテンツ',
    aboutSection: '情報',
    editProfile: 'プロフィール編集',
    changePassword: 'パスワード変更',
    theme: 'テーマ',
    darkTheme: 'ダーク',
    lightTheme: 'ライト',
    notifications: '通知',
    language: '言語',
    languageValue: '日本語',
    selectLanguage: '言語を選択',
    apply: '適用',
    kageTheme: 'カゲテーマ',
    locked: 'ロック中 🔒',
    hiddenCategories: '非表示カテゴリ',
    hiddenCount: '0 件非表示',
    myHistory: '履歴',
    clearCache: 'キャッシュをクリア',
    cacheSize: '24 MB',
    otadexVersion: 'OTADEXバージョン',
    termsOfService: '利用規約',
    privacyPolicy: 'プライバシーポリシー',
    rateApp: 'アプリを評価',
    logout: 'ログアウト',
    appVersion: 'OTADEX · v1.0.0 By TilStack',
    searchHint: 'キャラクター、アニメ、クリエイター...',
    recentSearches: '最近の検索',
    clearAll: 'すべてクリア',
    exploreByCategory: 'カテゴリで探す',
    trendingNow: '🔥 今のトレンド',
    cancel: 'キャンセル',
    youMightAlsoLike: 'こちらもおすすめ',
    characters: 'キャラクター',
    animes: 'アニメ',
    creators: 'クリエイター',
    all: 'すべて',
    placeholdertext1: 'キャラクター、アニメ、クリエイター...',
    saveChanges: '保存',
    currentPassword: '現在のパスワード',
    bioLabel: '自己紹介',
    profileUpdated: 'プロフィールを更新しました！',
    passwordChanged: 'パスワードを変更しました！',
  );

  static const AppStrings _zh = AppStrings(
    // Auth gate
    authGateTitle: '登录以继续',
    authGateMessage: '创建免费账号以访问你的个人资料、\n收藏和更多内容。',
    login: '登录',
    signUpFree: '免费注册',
    continueAsGuest: '不登录继续',
    // Login screen
    welcomeBack: '欢迎回来，ninja 🥷',
    loginSubtitle: '登录以继续你的旅程',
    emailLabel: '邮箱',
    emailAddressLabel: '电子邮箱地址',
    emailRequired: '邮箱为必填项',
    emailInvalid: '邮箱格式无效',
    passwordLabel: '密码',
    confirmPasswordLabel: '确认密码',
    passwordRequired: '密码为必填项',
    passwordMinLength: '最少 6 个字符',
    passwordsMismatch: '两次密码不一致',
    forgotPassword: '忘记密码？',
    orSeparator: '或',
    continueWithGoogle: '使用 Google 继续',
    noAccountYet: '还没有账号？',
    becomeGenin: '成为下忍',
    googleAuthCancelled: 'Google 登录已取消或未配置',
    // Register screen
    createAccount: '创建你的账号',
    joinFansSubtitle: '加入数千名宅文化爱好者',
    pseudoLabel: '昵称 / 忍者名',
    pseudoRequired: '昵称为必填项',
    pseudoMinLength: '最少 3 个字符',
    chooseStartingRank: '选择你的起始等级',
    canChangeLater: '之后可以更改',
    acceptTermsPrefix: '我接受',
    termsWord: '条款',
    acceptTermsConjunction: '和',
    privacyWord: '隐私政策',
    acceptTermsError: '请同意条款以继续',
    createAccountButton: '创建账号 →',
    alreadyHaveAccount: '已有账号？',
    googleLinked: 'Google 账号已关联 — 选择等级并确认',
    // Onboarding
    skip: '跳过',
    slide1TitleUniverse: '动漫世界',
    slide1TitleAnime: '尽在',
    slide1TitlePocket: '你的口袋',
    slide1Subtitle: '角色 · 系列 · 宇宙观\n你所热爱的一切，尽在一处。',
    slide2TitleExplore: '探索',
    slide2TitleCount: '10,000+',
    slide2TitleCharacters: '个角色',
    slide2Subtitle: '完整档案 · 图片画廊\n独家语录',
    slide2Button: '探索 →',
    slide3Title: '你是什么样的粉丝？',
    slide3Subtitle: '选择你的道路，晋升等级',
    rankGeninFreeLabel: '免费',
    rankGeninDesc: '免费访问 · 探索',
    rankJoninDesc: '无广告 · 高级收藏',
    rankKageDesc: 'AI 访问 · 专属 · 终极地位',
    premiumBadgeLabel: '高级',
    startAdventureButton: '开始冒险 →',
    canChangeRankLater: '之后可以更换等级',
    // Subscription modal
    subscriptionRankUpgradeTitle: '升级至',
    subscriptionRankUpgradeDesc: '解锁专为该等级忍者\n保留的专属功能',
    subscriptionBillingMonthly: '月付',
    subscriptionBillingAnnual: '年付',
    subscriptionSave10: '节省 10%',
    subscriptionAllDevices: '可在所有设备上使用',
    subscriptionObtainPass: '获取通行证',
    subscriptionAlreadyLicense: '已有许可证？',
    subscriptionFeaturesTitle: '功能',
    joninFeature1Title: '无限收藏',
    joninFeature1Desc: '无限制地收藏百科全书中的所有角色。',
    joninFeature2Title: '无广告',
    joninFeature2Desc: '无广告打扰地享受 OTADEX 体验。',
    joninFeature3Title: 'AI 聊天 + 测验',
    joninFeature3Desc: '向 AI 提问你最喜爱的角色，并测试你的知识。',
    joninFeature4Title: '上忍徽章 🦊',
    joninFeature4Desc: '在个人资料和评论中展示你的上忍等级。',
    kageFeature1Title: '包含完整上忍通行证',
    kageFeature1Desc: '影通行证包含所有上忍等级功能。',
    kageFeature2Title: 'AI 图像生成 ⭐',
    kageFeature2Desc: '利用 AI 生成你最喜爱角色的独特插画。',
    kageFeature3Title: '无水印下载',
    kageFeature3Desc: '下载所有高质量插画，无 OTADEX 水印。',
    kageFeature4Title: '专属主题 👑',
    kageFeature4Desc: '解锁专为影等级忍者保留的视觉主题。',
    // Profile tabs
    collection: '收藏',
    badges: '徽章',
    activity: '动态',
    myCollection: '我的收藏',
    manage: '管理',
    level: '等级',
    ptsForKageSupreme: 'pts 至影最高位',
    noBadgesYet: '暂无徽章',
    recentActivityHere: '最近的动态将显示在这里',
    settingsAndSubscription: '设置 & 订阅',
    geninPlanLabel: 'GENIN',
    freeLabel: '免费',
    basicPlanNoRenewal: '基础计划 · 无续费',
    upgradeToJonin: '升级至上忍 🦊',
    manageSubscription: '管理订阅',
    active: '活跃',
    kageBannerText: '影通行证 — AI图像 + 无水印下载',
    seeOffer: '查看 →',
    changePlan: '更改计划',
    monthly: '月付',
    annual: '年付',
    currentPlanTag: '当前计划 ✓',
    planActualButton: '当前计划',
    upgradeToJoninButton: '升至上忍 🦊',
    upgradeToKageButton: '升至影 👑',
    joninMonthlyPrice: '2,000 FCFA/月',
    joninAnnualPrice: '21,600 FCFA/年',
    kageMonthlyPrice: '5,000 FCFA/月',
    kageAnnualPrice: '54,000 FCFA/年',
    sheetsNavigation: '档案 & 导航',
    likesComments: '点赞 & 评论',
    adsShown: '显示广告',
    aiDisabled: 'AI 已禁用',
    unlimitedCollection: '无限收藏',
    noAds: '无广告',
    aiChatbot: 'AI 聊天 + 测验',
    joninBadge: '上忍徽章 🦊',
    joninIncluded: '包含所有上忍功能',
    aiImageGen: 'AI 图像生成 ⭐',
    noWatermark: '无水印',
    exclusiveThemes: '专属主题 👑',
    accountSection: '账号',
    preferencesSection: '偏好设置',
    contentSection: '内容',
    aboutSection: '关于',
    editProfile: '编辑资料',
    changePassword: '修改密码',
    theme: '主题',
    darkTheme: '深色',
    lightTheme: '浅色',
    notifications: '通知',
    language: '语言',
    languageValue: '中文',
    selectLanguage: '选择语言',
    apply: '应用',
    kageTheme: '影主题',
    locked: '已锁定 🔒',
    hiddenCategories: '隐藏分类',
    hiddenCount: '0 个隐藏',
    myHistory: '我的历史',
    clearCache: '清除缓存',
    cacheSize: '24 MB',
    otadexVersion: 'OTADEX 版本',
    termsOfService: '服务条款',
    privacyPolicy: '隐私政策',
    rateApp: '评价应用',
    logout: '退出登录',
    appVersion: 'OTADEX · v1.0.0 By TilStack',
    searchHint: '角色、动漫、创作者...',
    recentSearches: '最近搜索',
    clearAll: '清除全部',
    exploreByCategory: '按分类探索',
    trendingNow: '🔥 当前热门',
    cancel: '取消',
    youMightAlsoLike: '你可能也喜欢',
    characters: '角色',
    animes: '动漫',
    creators: '创作者',
    all: '全部',

    placeholdertext1: '角色、动漫、创作者...',
    saveChanges: '保存',
    currentPassword: '当前密码',
    bioLabel: '简介',
    profileUpdated: '个人资料已更新！',
    passwordChanged: '密码已更改！',
  );
}
