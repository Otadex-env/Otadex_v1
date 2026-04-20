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
    noWatermark: 'Sans watermark',
    exclusiveThemes: 'Thèmes exclusifs 👑',
    accountSection: 'COMPTE',
    preferencesSection: 'PRÉFÉRENCES',
    contentSection: 'CONTENU',
    aboutSection: 'À PROPOS',
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
    logout: 'Se déconnecter',
    appVersion: 'OTADEX · v1.0.0',
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
    logout: 'Log out',
    appVersion: 'OTADEX · v1.0.0',
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

  static const AppStrings _ja = AppStrings(
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
    email: 'メール',
    theme: 'テーマ',
    darkTheme: 'ダーク',
    notifications: '通知',
    language: '言語',
    languageValue: '日本語',
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
    appVersion: 'OTADEX · v1.0.0',
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
  );

  static const AppStrings _zh = AppStrings(
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
    email: '邮箱',
    theme: '主题',
    darkTheme: '深色',
    notifications: '通知',
    language: '语言',
    languageValue: '中文',
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
    appVersion: 'OTADEX · v1.0.0',
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
  );
}
