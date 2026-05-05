# OTADEX — Suivi d'avancement

## État actuel du projet
- Flutter SDK : `>=3.0.0 <4.0.0` (Flutter 3.x)
- App version : `1.0.0+1`
- Firebase configuré : **NON** — `google-services.json` absent, auth est encore mockée via SharedPreferences
- Dernier écran complété : **ProfileScreen** (avatar picker + Jonin gate, mai 2026)

## Dépendances installées (`pubspec.yaml`)

| Package | Version | Usage |
|---|---|---|
| go_router | ^13.0.0 | Navigation |
| google_fonts | ^6.1.0 | Typographie |
| flutter_riverpod | ^2.4.0 | State management |
| riverpod_annotation | ^2.3.0 | Codegen Riverpod |
| shared_preferences | ^2.2.0 | Persistance locale |
| flutter_secure_storage | ^9.0.0 | Token sécurisé |
| smooth_page_indicator | ^1.1.0 | Onboarding dots |
| flutter_animate | ^4.3.0 | Animations |
| shimmer | ^3.0.0 | Skeleton loaders |
| cached_network_image | ^3.3.0 | Images réseau |
| flutter_svg | ^2.0.0 | Icônes SVG |
| google_sign_in | ^6.2.0 | OAuth Google |
| gap | ^3.0.1 | Espacement |
| image_picker | ^1.1.0 | Avatar picker |

> ⚠️ Après ajout de `image_picker`, lancer `flutter pub get` si pas encore fait.

---

## Fichiers créés

### Core — Thème

| Fichier | Statut | Notes |
|---|---|---|
| `lib/core/theme/app_colors.dart` | ✅ Fait | Tokens couleurs complets |
| `lib/core/theme/app_typography.dart` | ✅ Fait | Styles texte (DM Sans + Rajdhani + NunitoSans) |
| `lib/core/theme/app_theme.dart` | ✅ Fait | ThemeData Flutter |
| `lib/core/theme/app_spacing.dart` | ✅ Fait | Constantes de spacing |
| `lib/core/theme/otadex_theme.dart` | ✅ Fait | Système de thème par rang (Genin/Jonin/Kage) |
| `lib/core/theme/otadex_theme_wrapper.dart` | ✅ Fait | InheritedWidget wrapper |
| `lib/core/theme/rank_theme.dart` | ✅ Fait | Définitions visuelles par rang |
| `lib/core/theme/theme_mode_provider.dart` | ✅ Fait | Provider toggle dark/light |

### Core — Widgets

| Fichier | Statut | Notes |
|---|---|---|
| `lib/core/widgets/auth_gate_modal.dart` | ✅ Fait | Modale d'authentification requise |
| `lib/core/widgets/character_avatar.dart` | ✅ Fait | Avatar personnage réutilisable |
| `lib/core/widgets/otadex_button.dart` | ✅ Fait | Bouton stylisé branded |
| `lib/core/widgets/otadex_text_field.dart` | ✅ Fait | Champ texte stylisé |
| `lib/core/widgets/rank_badge.dart` | ✅ Fait | Badge Genin/Jonin/Kage |
| `lib/core/widgets/subscription_billing_card.dart` | ✅ Fait | Card cycle de facturation |
| `lib/core/widgets/subscription_feature_item.dart` | ✅ Fait | Item liste fonctionnalités plan |
| `lib/core/widgets/subscription_modal.dart` | ✅ Fait | Modale upgrade plan (premium gate) |
| `lib/core/widgets/bottom_nav_bar.dart` | ❌ À faire | Existe dans features/home/widgets — à extraire |
| `lib/core/widgets/character_card.dart` | ❌ À faire | Existe en tant que character_grid_card dans home — à extraire |
| `lib/core/widgets/section_header.dart` | ❌ À faire | Existe dans features/home/widgets — à extraire |
| `lib/core/widgets/category_pill.dart` | ❌ À faire | Existe en tant que category_chips dans home — à extraire |
| `lib/core/widgets/skeleton_loader.dart` | ❌ À faire | Package shimmer disponible |
| `lib/core/widgets/toast_widget.dart` | ❌ À faire | SnackBar custom |
| `lib/core/widgets/premium_gate_sheet.dart` | ❌ À faire | Couvert par subscription_modal.dart |

### Core — Providers

| Fichier | Statut | Notes |
|---|---|---|
| `lib/core/providers/auth_provider.dart` | ✅ Fait | `isLoggedInProvider` (StateProvider<bool>) |
| `lib/core/providers/user_profile_provider.dart` | ✅ Fait | `UserProfileNotifier` + `updateProfile` + `updateAvatar` |
| `lib/core/providers/otadex_providers.dart` | ✅ Fait | Providers données (personnages, animés, créateurs) |
| `lib/core/providers/recommendation_provider.dart` | ✅ Fait | Provider recommandations |

### Core — Router / Services / Models

| Fichier | Statut | Notes |
|---|---|---|
| `lib/core/router/app_router.dart` | ✅ Fait | GoRouter complet |
| `lib/core/services/otadex_data_service.dart` | ✅ Fait | Service données mockées |
| `lib/core/services/google_sign_in_service.dart` | ✅ Fait | Google OAuth wrapper |
| `lib/core/models/character.dart` | ✅ Fait | Modèle personnage |
| `lib/core/models/anime_entry.dart` | ✅ Fait | Modèle animé |
| `lib/core/models/creator_entry.dart` | ✅ Fait | Modèle créateur |
| `lib/core/models/user_profile.dart` | ✅ Fait | Modèle profil utilisateur |
| `lib/core/models/user_rank.dart` | ✅ Fait | Enum UserRank (genin/jonin/kage) |
| `lib/core/models/featured_slide.dart` | ✅ Fait | Modèle slide hero carousel |
| `lib/core/data/mock_data.dart` | ✅ Fait | Données mockées |
| `lib/core/constants/app_constants.dart` | ✅ Fait | Clés, plans, constantes |

### Features — Auth

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/auth/presentation/login_screen.dart` | ✅ Fait | ConsumerStatefulWidget, écrit isLoggedInProvider |
| `lib/features/auth/presentation/register_screen.dart` | ✅ Fait | Écran d'inscription |
| `lib/features/auth/presentation/widgets/rank_selector.dart` | ✅ Fait | Widget sélection rang à l'inscription |

### Features — Onboarding

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/onboarding/presentation/onboarding_screen.dart` | ✅ Fait | 3 slides animées |
| `lib/features/onboarding/presentation/age_verification_screen.dart` | ✅ Fait | Vérification âge |
| `lib/features/onboarding/presentation/interests_screen.dart` | ✅ Fait | Sélection intérêts |
| `lib/features/onboarding/presentation/widgets/onboarding_page.dart` | ✅ Fait | |
| `lib/features/onboarding/presentation/widgets/onboarding_rank_card.dart` | ✅ Fait | |
| `lib/features/onboarding/presentation/widgets/slide_one_content.dart` | ✅ Fait | |
| `lib/features/onboarding/presentation/widgets/slide_two_content.dart` | ✅ Fait | |
| `lib/features/onboarding/presentation/widgets/slide_three_content.dart` | ✅ Fait | |

### Features — Splash

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/splash/presentation/splash_screen.dart` | ✅ Fait | Animation splash |

### Features — Home

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/home/presentation/home_screen.dart` | ✅ Fait | ConsumerStatefulWidget, watch isLoggedInProvider |
| `lib/features/home/presentation/widgets/bottom_nav_bar.dart` | ✅ Fait | Nav bar 4 onglets |
| `lib/features/home/presentation/widgets/home_app_bar.dart` | ✅ Fait | AppBar avec badge rang |
| `lib/features/home/presentation/widgets/hero_featured_slider.dart` | ✅ Fait | Carousel hero animé |
| `lib/features/home/presentation/widgets/trending_section.dart` | ✅ Fait | Section tendances |
| `lib/features/home/presentation/widgets/trending_character_card.dart` | ✅ Fait | Card tendance |
| `lib/features/home/presentation/widgets/character_grid_section.dart` | ✅ Fait | Grille personnages |
| `lib/features/home/presentation/widgets/character_grid_card.dart` | ✅ Fait | Card grille |
| `lib/features/home/presentation/widgets/category_chips.dart` | ✅ Fait | Chips de catégories |
| `lib/features/home/presentation/widgets/section_header.dart` | ✅ Fait | Header de section |
| `lib/features/home/presentation/widgets/search_bar_widget.dart` | ✅ Fait | Barre de recherche |
| `lib/features/home/presentation/widgets/upsell_banner.dart` | ✅ Fait | Bannière upgrade Jonin |

### Features — Character

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/character/presentation/character_detail_screen.dart` | ✅ Fait | Fiche personnage complète |
| `lib/features/character/presentation/character_list_screen.dart` | ✅ Fait | Liste de personnages |
| `lib/features/character/presentation/widgets/char_ai_card.dart` | ✅ Fait | Card IA chatbot |
| `lib/features/character/presentation/widgets/char_comment_card.dart` | ✅ Fait | Card commentaire |
| `lib/features/character/presentation/widgets/char_circle_button.dart` | ✅ Fait | Bouton circulaire action |
| `lib/features/character/presentation/widgets/char_pill.dart` | ✅ Fait | Pill tag (pouvoir, genre) |
| `lib/features/character/presentation/widgets/char_section_header.dart` | ✅ Fait | Header section fiche |
| `lib/features/character/presentation/widgets/char_tab_delegate.dart` | ✅ Fait | Delegate onglets fiche |
| `features/character/presentation/gallery_screen.dart` | ❌ À faire | Galerie plein écran |

### Features — Search

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/search/presentation/search_screen.dart` | ✅ Fait | Écran recherche |

### Features — Profile

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/profile/presentation/profile_screen.dart` | ✅ Fait | Écran profil complet |
| `lib/features/profile/presentation/widgets/profile_hero.dart` | ✅ Fait | Hero avatar + rang + pseudo + bio |
| `lib/features/profile/presentation/widgets/edit_profile_sheet.dart` | ✅ Fait | Sheet édition + image picker + Jonin gate |
| `lib/features/profile/presentation/widgets/avatar_picker.dart` | ✅ Fait | Widget picker avatar |
| `lib/features/profile/presentation/widgets/profile_stat_row.dart` | ✅ Fait | Ligne stats (collectés, score, rang) |
| `lib/features/profile/presentation/widgets/profile_tab_bar.dart` | ✅ Fait | Barre d'onglets profil |
| `lib/features/profile/presentation/widgets/profile_tab_content.dart` | ✅ Fait | Contenu onglets profil |
| `lib/features/profile/presentation/widgets/plan_section.dart` | ✅ Fait | Section plans |
| `lib/features/profile/presentation/widgets/plan_card.dart` | ✅ Fait | Card plan individuel |
| `lib/features/profile/presentation/widgets/subscription_card.dart` | ✅ Fait | Card abonnement actuel |
| `lib/features/profile/presentation/widgets/kage_banner.dart` | ✅ Fait | Bannière promo Kage |
| `lib/features/profile/presentation/widgets/billing_toggle.dart` | ✅ Fait | Toggle mensuel/annuel |
| `lib/features/profile/presentation/widgets/settings_section.dart` | ✅ Fait | Section paramètres |
| `lib/features/profile/presentation/widgets/change_password_sheet.dart` | ✅ Fait | Sheet changement mot de passe |
| `lib/features/profile/presentation/widgets/profile_logout_footer.dart` | ✅ Fait | Footer déconnexion |

### Features — Manquants (prochaines tâches)

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/anime/presentation/anime_detail_screen.dart` | ❌ À faire | Fiche animé |
| `lib/features/creator/presentation/creator_screen.dart` | ❌ À faire | Fiche créateur |
| `lib/features/subscription/presentation/plans_screen.dart` | ❌ À faire | Page plans + CinetPay |

### Features — Legal

| Fichier | Statut | Notes |
|---|---|---|
| `lib/features/legal/presentation/privacy_policy_screen.dart` | ✅ Fait | Politique de confidentialité |
| `lib/features/legal/presentation/terms_screen.dart` | ✅ Fait | CGU |

---

## Bugs connus

| Bug | Priorité | Description |
|---|---|---|
| Auth persistance | 🔴 Haute | `isLoggedInProvider` initialisé à `false` au démarrage — si l'app est relancée, l'utilisateur est déconnecté même si prefs = true. À régler en lisant SharedPreferences dans `main.dart` avant `runApp()` |
| Avatar non persistant | 🟡 Moyenne | L'avatar sélectionné via image_picker est un chemin temp/cache → perdu au redémarrage. Nécessite Firebase Storage pour persistance réelle |
| `flutter pub get` | 🟡 Moyenne | À relancer après ajout de `image_picker: ^1.1.0` si pas encore fait |

---

## Prochaine tâche recommandée

**Task 03 — AnimeDetailScreen + CreatorScreen**
- Fiche animé complète (synopsis, personnages, galerie)
- Fiche créateur (bio, œuvres)
- Navigation depuis les cards personnage (`/anime/:id`, `/creator/:id`)

**Ou Task 03 alternative — Firebase Auth réelle**
- Connecter `login_screen.dart` + `register_screen.dart` à Firebase Authentication
- Remplacer SharedPreferences mock par `FirebaseAuth.instance`
- Configurer `android/app/google-services.json`

---

## Historique des sessions

| Date | Travail effectué |
|---|---|
| Mai 2026 | Initialisation projet — Task 01 : Splash, Onboarding, Auth (mock) |
| Mai 2026 | Task 02 : HomeScreen réactif (isLoggedInProvider), ProfileScreen complet, avatar picker avec Jonin gate, permissions Android image_picker |

---
*À mettre à jour par Claude Code à la fin de chaque session.*
*Dernière mise à jour : mai 2026*
