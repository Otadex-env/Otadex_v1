# OTADEX — Suivi d'avancement

## État actuel du projet

- Flutter SDK : `>=3.0.0 <4.0.0` (Flutter 3.x)
- App version : `1.0.0+1`
- Firebase configuré : **OUI (Storage inclus)** — FlutterFire Android + Firebase Auth email/Google + Firestore profil utilisateur + Functions + Storage initialisés
- Dernier écran complété : **PlansScreen + ProfileScreen** (licence Chariow, préférence monnaie, mai 2026)
- Dernière mise à jour : **Task 29 — Import Naruto Shippuden**, 22 May 2026

## Dépendances installées (`pubspec.yaml`)

| Package                | Version | Usage                        |
| ---------------------- | ------- | ---------------------------- |
| go_router              | ^13.0.0 | Navigation                   |
| google_fonts           | ^6.1.0  | Typographie                  |
| flutter_riverpod       | ^2.4.0  | State management             |
| riverpod_annotation    | ^2.3.0  | Codegen Riverpod             |
| shared_preferences     | ^2.2.0  | Persistance locale           |
| flutter_secure_storage | ^9.0.0  | Token sécurisé               |
| smooth_page_indicator  | ^1.1.0  | Onboarding dots              |
| flutter_animate        | ^4.3.0  | Animations                   |
| shimmer                | ^3.0.0  | Skeleton loaders             |
| cached_network_image   | ^3.3.0  | Images réseau                |
| flutter_svg            | ^2.0.0  | Icônes SVG                   |
| google_sign_in         | ^6.2.0  | OAuth Google                 |
| firebase_core          | ^2.27.0 | Initialisation Firebase      |
| firebase_auth          | ^4.17.0 | Auth email/password + Google |
| cloud_firestore        | ^4.15.0 | Profil utilisateur Firestore |
| firebase_storage       | ^11.6.0 | Images personnages Storage   |
| gap                    | ^3.0.1  | Espacement                   |
| image_picker           | ^1.1.0  | Avatar picker                |

> ⚠️ Après ajout de `image_picker`, lancer `flutter pub get` si pas encore fait.

---

## Fichiers créés

### Core — Thème

| Fichier                                    | Statut  | Notes                                          |
| ------------------------------------------ | ------- | ---------------------------------------------- |
| `lib/core/theme/app_colors.dart`           | ✅ Fait | Tokens couleurs complets                       |
| `lib/core/theme/app_typography.dart`       | ✅ Fait | Styles texte (DM Sans + Rajdhani + NunitoSans) |
| `lib/core/theme/app_theme.dart`            | ✅ Fait | ThemeData Flutter                              |
| `lib/core/theme/app_spacing.dart`          | ✅ Fait | Constantes de spacing                          |
| `lib/core/theme/otadex_theme.dart`         | ✅ Fait | Système de thème par rang (Genin/Jonin/Kage)   |
| `lib/core/theme/otadex_theme_wrapper.dart` | ✅ Fait | InheritedWidget wrapper                        |
| `lib/core/theme/rank_theme.dart`           | ✅ Fait | Définitions visuelles par rang                 |
| `lib/core/theme/theme_mode_provider.dart`  | ✅ Fait | Provider toggle dark/light                     |

### Core — Widgets

| Fichier                                           | Statut     | Notes                                                         |
| ------------------------------------------------- | ---------- | ------------------------------------------------------------- |
| `lib/core/widgets/auth_gate_modal.dart`           | ✅ Fait    | Modale d'authentification requise                             |
| `lib/core/widgets/character_avatar.dart`          | ✅ Fait    | Avatar personnage réutilisable                                |
| `lib/core/widgets/otadex_button.dart`             | ✅ Fait    | Bouton stylisé branded                                        |
| `lib/core/widgets/otadex_text_field.dart`         | ✅ Fait    | Champ texte stylisé                                           |
| `lib/core/widgets/auth_required_screen.dart`      | ✅ Fait    | Guard UI pour routes personnalisées nécessitant connexion     |
| `lib/core/widgets/rank_badge.dart`                | ✅ Fait    | Badge Genin/Jonin/Kage                                        |
| `lib/core/widgets/subscription_billing_card.dart` | ✅ Fait    | Card cycle de facturation                                     |
| `lib/core/widgets/subscription_feature_item.dart` | ✅ Fait    | Item liste fonctionnalités plan                               |
| `lib/core/widgets/subscription_modal.dart`        | ✅ Fait    | Modale upgrade plan (premium gate)                            |
| `lib/core/widgets/bottom_nav_bar.dart`            | ❌ À faire | Existe dans features/home/widgets — à extraire                |
| `lib/core/widgets/character_card.dart`            | ❌ À faire | Existe en tant que character_grid_card dans home — à extraire |
| `lib/core/widgets/section_header.dart`            | ❌ À faire | Existe dans features/home/widgets — à extraire                |
| `lib/core/widgets/category_pill.dart`             | ❌ À faire | Existe en tant que category_chips dans home — à extraire      |
| `lib/core/widgets/skeleton_loader.dart`           | ❌ À faire | Package shimmer disponible                                    |
| `lib/core/widgets/toast_widget.dart`              | ❌ À faire | SnackBar custom                                               |
| `lib/core/widgets/premium_gate_sheet.dart`        | ❌ À faire | Couvert par subscription_modal.dart                           |

### Core — Providers

| Fichier                                           | Statut  | Notes                                                                      |
| ------------------------------------------------- | ------- | -------------------------------------------------------------------------- |
| `lib/core/providers/auth_provider.dart`           | ✅ Fait | `isLoggedInProvider` (StateProvider<bool>)                                 |
| `lib/core/providers/user_profile_provider.dart`   | ✅ Fait | `UserProfileNotifier` + `updateProfile` + `updateAvatar`                   |
| `lib/core/providers/currency_provider.dart`       | ✅ Fait | Préférence monnaie utilisateur (XAF/USD/EUR/GBP/CAD/NGN)                   |
| `lib/core/providers/otadex_providers.dart`        | ✅ Fait | Providers données mock (allCharacters, animes, creators)                   |
| `lib/core/providers/anilist_providers.dart`       | ✅ Fait | Providers AniList live (trending, search, featuredSlides, characterDetail) |
| `lib/core/providers/recommendation_provider.dart` | ✅ Fait | Provider recommandations                                                   |

### Core — Router / Services / Models

| Fichier                                         | Statut  | Notes                                                                                                           |
| ----------------------------------------------- | ------- | --------------------------------------------------------------------------------------------------------------- |
| `lib/core/router/app_router.dart`               | ✅ Fait | GoRouter complet                                                                                                |
| `lib/core/services/anilist_service.dart`        | ✅ Fait | Service AniList GraphQL (searchCharacters, searchAnimes, trending chars/animes, detail)                         |
| `lib/core/services/otadex_data_service.dart`    | ✅ Fait | Service données mockées (fallback local)                                                                        |
| `lib/core/services/google_sign_in_service.dart` | ✅ Fait | Google OAuth wrapper                                                                                            |
| `lib/core/services/firebase_auth_service.dart`  | ✅ Fait | Firebase Auth email + Google, signOut, reset password, updatePassword, updateProfile, création profil Firestore |
| `lib/firebase_options.dart`                     | ✅ Fait | Généré par FlutterFire pour le projet Firebase `tilqui`                                                         |
| `android/app/google-services.json`              | ✅ Fait | Config Android Firebase pour `com.otadex.otadex`                                                                |
| `firebase.json`                                 | ✅ Fait | Config Firebase CLI créée                                                                                       |
| `.firebaserc`                                   | ✅ Fait | Projet Firebase associé à `tilqui`                                                                              |
| `firestore.rules`                               | ✅ Fait | Rules Firestore téléchargées depuis la console                                                                  |
| `firestore.indexes.json`                        | ✅ Fait | Index Firestore initialisés                                                                                     |
| `functions/`                                    | ✅ Fait | Cloud Functions initialisées en TypeScript + ESLint                                                             |
| `lib/core/models/character.dart`                | ✅ Fait | Modèle personnage                                                                                               |
| `lib/core/models/anime_entry.dart`              | ✅ Fait | Modèle animé                                                                                                    |
| `lib/core/models/creator_entry.dart`            | ✅ Fait | Modèle créateur                                                                                                 |
| `lib/core/models/user_profile.dart`             | ✅ Fait | Modèle profil utilisateur                                                                                       |
| `lib/core/models/user_rank.dart`                | ✅ Fait | Enum UserRank (genin/jonin/kage)                                                                                |
| `lib/core/models/featured_slide.dart`           | ✅ Fait | Modèle slide hero carousel                                                                                      |
| `lib/core/data/mock_data.dart`                  | ✅ Fait | Données mockées — tous imagePath → URLs AniList CDN                                                             |
| `lib/core/constants/app_constants.dart`         | ✅ Fait | Clés, plans, constantes                                                                                         |

### Features — Auth

| Fichier                                                            | Statut  | Notes                                                                              |
| ------------------------------------------------------------------ | ------- | ---------------------------------------------------------------------------------- |
| `lib/features/auth/presentation/login_screen.dart`                 | ✅ Fait | FirebaseAuthService email + Google, écrit isLoggedInProvider, affiche erreurs auth |
| `lib/features/auth/presentation/register_screen.dart`              | ✅ Fait | FirebaseAuthService email + Google, création profil Firestore                      |
| `lib/features/auth/presentation/widgets/password_reset_sheet.dart` | ✅ Fait | Forgot password : email + code de réinitialisation dans l'application              |
| `lib/features/auth/presentation/widgets/rank_selector.dart`        | ✅ Fait | Widget sélection rang à l'inscription                                              |

### Features — Onboarding

| Fichier                                                                  | Statut  | Notes              |
| ------------------------------------------------------------------------ | ------- | ------------------ |
| `lib/features/onboarding/presentation/onboarding_screen.dart`            | ✅ Fait | 3 slides animées   |
| `lib/features/onboarding/presentation/age_verification_screen.dart`      | ✅ Fait | Vérification âge   |
| `lib/features/onboarding/presentation/interests_screen.dart`             | ✅ Fait | Sélection intérêts |
| `lib/features/onboarding/presentation/widgets/onboarding_page.dart`      | ✅ Fait |                    |
| `lib/features/onboarding/presentation/widgets/onboarding_rank_card.dart` | ✅ Fait |                    |
| `lib/features/onboarding/presentation/widgets/slide_one_content.dart`    | ✅ Fait |                    |
| `lib/features/onboarding/presentation/widgets/slide_two_content.dart`    | ✅ Fait |                    |
| `lib/features/onboarding/presentation/widgets/slide_three_content.dart`  | ✅ Fait |                    |

### Features — Splash

| Fichier                                               | Statut  | Notes            |
| ----------------------------------------------------- | ------- | ---------------- |
| `lib/features/splash/presentation/splash_screen.dart` | ✅ Fait | Animation splash |

### Features — Home

| Fichier                                                               | Statut  | Notes                                                                  |
| --------------------------------------------------------------------- | ------- | ---------------------------------------------------------------------- |
| `lib/features/home/presentation/home_screen.dart`                     | ✅ Fait | ConsumerStatefulWidget, watch isLoggedInProvider + userProfileProvider |
| `lib/features/home/presentation/widgets/bottom_nav_bar.dart`          | ✅ Fait | Nav bar 4 onglets                                                      |
| `lib/features/home/presentation/widgets/home_app_bar.dart`            | ✅ Fait | AppBar avec badge rang, pseudo court, boutons notification/profil      |
| `lib/features/home/presentation/notifications_screen.dart`            | ✅ Fait | Page notifications avec état vide                                      |
| `lib/features/home/presentation/widgets/hero_featured_slider.dart`    | ✅ Fait | Carousel hero animé                                                    |
| `lib/features/home/presentation/widgets/trending_section.dart`        | ✅ Fait | Section tendances                                                      |
| `lib/features/home/presentation/widgets/trending_character_card.dart` | ✅ Fait | Card tendance                                                          |
| `lib/features/home/presentation/widgets/character_grid_section.dart`  | ✅ Fait | Grille personnages                                                     |
| `lib/features/home/presentation/widgets/character_grid_card.dart`     | ✅ Fait | Card grille                                                            |
| `lib/features/home/presentation/widgets/category_chips.dart`          | ✅ Fait | Chips de catégories                                                    |
| `lib/features/home/presentation/widgets/section_header.dart`          | ✅ Fait | Header de section                                                      |
| `lib/features/home/presentation/widgets/search_bar_widget.dart`       | ✅ Fait | Barre de recherche                                                     |
| `lib/features/home/presentation/widgets/upsell_banner.dart`           | ✅ Fait | Bannière upgrade Jonin                                                 |

### Features — Character

| Fichier                                                                | Statut  | Notes                                                                                                                        |
| ---------------------------------------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `lib/features/character/presentation/character_detail_screen.dart`     | ✅ Fait | Fiche personnage complète                                                                                                    |
| `lib/features/character/presentation/character_list_screen.dart`       | ✅ Fait | Liste de personnages                                                                                                         |
| `lib/features/character/presentation/widgets/char_ai_card.dart`        | ✅ Fait | Card IA chatbot                                                                                                              |
| `lib/features/character/presentation/widgets/char_comment_card.dart`   | ✅ Fait | Card commentaire                                                                                                             |
| `lib/features/character/presentation/widgets/char_circle_button.dart`  | ✅ Fait | Bouton circulaire action                                                                                                     |
| `lib/features/character/presentation/widgets/char_pill.dart`           | ✅ Fait | Pill tag (pouvoir, genre)                                                                                                    |
| `lib/features/character/presentation/widgets/char_section_header.dart` | ✅ Fait | Header section fiche                                                                                                         |
| `lib/features/character/presentation/widgets/char_tab_delegate.dart`   | ✅ Fait | Delegate onglets fiche                                                                                                       |
| `lib/features/character/presentation/gallery_screen.dart`              | ✅ Fait | Galerie plein écran — PageView + InteractiveViewer 4×, watermark Genin/Jonin, miniatures bas, hint swipe, download gate Kage |

### Features — Search

| Fichier                                               | Statut  | Notes           |
| ----------------------------------------------------- | ------- | --------------- |
| `lib/features/search/presentation/search_screen.dart` | ✅ Fait | Écran recherche |

### Features — Profile

| Fichier                                                                | Statut  | Notes                                                                     |
| ---------------------------------------------------------------------- | ------- | ------------------------------------------------------------------------- |
| `lib/features/profile/presentation/profile_screen.dart`                | ✅ Fait | Écran profil complet                                                      |
| `lib/features/profile/presentation/widgets/profile_hero.dart`          | ✅ Fait | Hero avatar + rang + pseudo Firebase + bio/statut                         |
| `lib/features/profile/presentation/widgets/edit_profile_sheet.dart`    | ✅ Fait | Sheet édition + image picker + Jonin gate + persistance Firestore / prefs |
| `lib/features/profile/presentation/widgets/avatar_picker.dart`         | ✅ Fait | Widget picker avatar                                                      |
| `lib/features/profile/presentation/widgets/profile_stat_row.dart`      | ✅ Fait | Ligne stats (collectés, score, rang)                                      |
| `lib/features/profile/presentation/widgets/profile_tab_bar.dart`       | ✅ Fait | Barre d'onglets profil                                                    |
| `lib/features/profile/presentation/widgets/profile_tab_content.dart`   | ✅ Fait | Contenu onglets profil                                                    |
| `lib/features/profile/presentation/widgets/plan_section.dart`          | ✅ Fait | Section plans                                                             |
| `lib/features/profile/presentation/widgets/plan_card.dart`             | ✅ Fait | Card plan individuel                                                      |
| `lib/features/profile/presentation/widgets/subscription_card.dart`     | ✅ Fait | Card abonnement actuel                                                    |
| `lib/features/profile/presentation/widgets/kage_banner.dart`           | ✅ Fait | Bannière promo Kage                                                       |
| `lib/features/profile/presentation/widgets/billing_toggle.dart`        | ✅ Fait | Toggle mensuel/annuel                                                     |
| `lib/features/profile/presentation/widgets/settings_section.dart`      | ✅ Fait | Section paramètres                                                        |
| `lib/features/profile/presentation/widgets/change_password_sheet.dart` | ✅ Fait | Sheet changement mot de passe + réauth Firebase + update password         |
| `lib/features/profile/presentation/widgets/profile_logout_footer.dart` | ✅ Fait | Footer déconnexion Firebase + retour login                                |

### Features — Anime

| Fichier                                                    | Statut  | Notes                                                                            |
| ---------------------------------------------------------- | ------- | -------------------------------------------------------------------------------- |
| `lib/features/anime/presentation/anime_detail_screen.dart` | ✅ Fait | Hero gradient, stats band, personnages, synopsis expand, créateur, "aussi aimer" |

### Features — Créateur

| Fichier                                                 | Statut  | Notes                                                                              |
| ------------------------------------------------------- | ------- | ---------------------------------------------------------------------------------- |
| `lib/features/creator/presentation/creator_screen.dart` | ✅ Fait | Header initiales, bio expand, stats, bibliographie grid 2col, personnages scroll H |

### Core — Assets & Images

| Fichier                                 | Statut      | Notes                                                                    |
| --------------------------------------- | ----------- | ------------------------------------------------------------------------ |
| `lib/core/constants/app_assets.dart`    | ✅ Fait     | Assets locaux uniquement : logo, splash, onboarding, defaultAvatar       |
| `lib/core/widgets/otadex_image.dart`    | ✅ Fait     | Widget universel local + réseau (CachedNetworkImage + shimmer)           |
| `assets/images/logo/`                   | ✅ Fait     | otadex_logo.png, otadex_icon.png                                         |
| `assets/images/splash/`                 | ✅ Fait     | splash_illustration.png, rank_bg_kage.png                                |
| `assets/images/onboarding/`             | ✅ Fait     | onboarding_1.png, onboarding_2.png, onboarding_2_1.png, onboarding_3.png |
| `assets/images/characters/satoru_gojo/` | ✅ Fait     | 5 images placeholder (gojo_01–05) — defaultAvatar local                  |
| `assets/images/jujutsu_kaisen/`         | 🗑️ Supprimé | Task 07 — images animés/persos viennent du réseau                        |
| `assets/images/Animé pictures/`         | ✅ Réactivé | Task 28 — 15 dossiers JJK (120+ fichiers) déclarés dans pubspec.yaml     |
| `lib/core/constants/app_assets.dart`    | ✅ Étendu   | Task 28 — 14 personnages JJK mappés via `getByCharacterId(charId)`       |

### Features — Manquants (prochaines tâches)

| Fichier                                                    | Statut  | Notes                                                                                                                        |
| ---------------------------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------- |
| `lib/features/character/presentation/gallery_screen.dart`  | ✅ Fait | Galerie plein écran — PageView + InteractiveViewer 4×, watermark Genin/Jonin, miniatures bas, hint swipe, download gate Kage |
| `lib/features/subscription/presentation/plans_screen.dart` | ✅ Fait | Page plans créée et route `/subscription` pointant vers `PlansScreen`                                                        |
| `docs/index.html`                                          | ✅ Fait | Landing page complète — hero mockup, features, plans Genin/Jonin/Kage, section légale, footer, scroll reveal, nav mobile     |
| `docs/privacy-policy.html`                                 | ✅ Fait | Politique de confidentialité FR/EN — toggle langue, conforme Play Store                                                      |
| `docs/terms.html`                                          | ✅ Fait | Conditions d'utilisation FR/EN — tableau plans, toggle langue                                                                |
| `docs/account-deletion.html`                               | ✅ Fait | Suppression de compte FR/EN — étapes in-app + email CTA, avertissement données                                               |
| `docs/play-store/`                                         | ✅ Fait | Préparation Play Store : listing FR, Data Safety, test plan, captures                                                        |

### Features — Legal

| Fichier                                                      | Statut  | Notes                        |
| ------------------------------------------------------------ | ------- | ---------------------------- |
| `lib/features/legal/presentation/privacy_policy_screen.dart` | ✅ Fait | Politique de confidentialité |
| `lib/features/legal/presentation/terms_screen.dart`          | ✅ Fait | CGU                          |

---

## Task 28 — Assets locaux JJK + Audit sources données (22 mai 2026)

### ✅ FIX A — Sources de données
- `allCharactersProvider` : Firestore (200) OU JSON mock fallback — déjà correct (task 27)
- `trendingCharactersProvider` : Firestore-based via `isTrending` — déjà correct (task 27)

### ✅ FIX B — Images locales déclarées dans pubspec.yaml
- 15 dossiers JJK ajoutés sous `assets/images/Animé pictures/Jujutsu kaizen/`
- `app_assets.dart` étendu : 14 personnages JJK avec listes complètes de fichiers + `getByCharacterId()`

### ✅ FIX C — OtadexImage
- Ajout guard `if (imagePath.isEmpty) return _errorWidget()` avant tout traitement

### ✅ FIX D — `_effectiveImages` dans CharacterDetailScreen
- Priorité 1 : `AppAssets.getByCharacterId(c.id)` (assets locaux)
- Priorité 2 : `c.images` (Firestore)
- Priorité 3 : `c.imagePath`
- Priorité 4 : Firebase Storage

### ✅ FIX E — Cards (grid + trending)
- `character_grid_card.dart` + `trending_character_card.dart` : image résolue via `AppAssets.getByCharacterId()` en priorité

### ✅ FIX F — CollectionScreen
- Déjà correct (task 27) : `collectionStreamProvider` + `allCharactersProvider`

### ✅ FIX G — scripts/import_jjk.js
- 14 personnages mis à jour : `images[]` + `imagePath` → chemins assets locaux

---


---

## Task 29 — Import Naruto Shippuden (Automatisé)
### ✅ Scripts d'import générés
- `scripts/import_ns.js` créé à partir du fichier `.docx`
- 20 personnages ajoutés (Minato, Itachi, Sakura, etc.) avec bio, statistiques et rangs de popularité.
### ✅ Assets et Pubspec
- `app_assets.dart` mis à jour dynamiquement pour le switch `getByCharacterId()` et les tableaux de 8 images par personnage (`ns_XXXX1.jpeg` à `ns_XXXX8.jpeg`).
- Déclaration des dossiers cibles dans `pubspec.yaml` pour chaque nouveau personnage.
- Prêt pour exécution avec `node scripts/import_ns.js`

## Données mockées — Stratégie images

| Source                                   | Usage                                                                         |
| ---------------------------------------- | ----------------------------------------------------------------------------- |
| Assets locaux JJK                        | Priorité absolue pour les 14 personnages JJK — via `AppAssets.getByCharacterId` |
| Firestore `images[]`                     | Priorité 2 — URLs stockées dans Firestore                                     |
| AniList CDN (réseau)                     | Fallback pour personnages non-JJK — via `OtadexImage(imagePath: url)`        |
| `assets/images/characters/satoru_gojo/` | Placeholder local générique (5 fichiers, ~500 KB)                             |
| Logo / splash / onboarding               | Assets locaux permanents — référencés via `AppAssets.*`                       |

## Bugs connus

| Bug                               | Priorité   | Description                                                                                                                                    |
| --------------------------------- | ---------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| Auth persistance                  | ✅ Corrigé | `main.dart` lit `keyIsLoggedIn` avant `runApp()` et override `isLoggedInProvider` via `ProviderScope.overrides`                                |
| Splash initial route              | ✅ Corrigé | `getInitialRoute()` respecte maintenant l'état `isLoggedIn` et redirige vers `/login` si l'utilisateur n'est pas connecté après l'onboarding.  |
| Auth Firebase réelle              | ✅ Corrigé | Email/password + Google branchés via FirebaseAuthService, profil Firestore créé à l'inscription                                                |
| Déconnexion reste sur Home        | ✅ Corrigé | Le footer profil appelle Firebase signOut, passe isLoggedInProvider à false et redirige vers `/login`                                          |
| Profil affiche NouveauGenin       | ✅ Corrigé | Le pseudo Firebase/SharedPreferences est restauré dans userProfileProvider après login/register                                                |
| Notification Home inactive        | ✅ Corrigé | Bouton notification ouvre `/notifications` avec état vide si aucune notification                                                               |
| Pseudo absent dans Home           | ✅ Corrigé | HomeAppBar affiche un pseudo court près du bouton profil                                                                                       |
| Collection personnage persistante | ✅ Corrigé | `CharacterDetailScreen` utilise maintenant `userProfileProvider` pour stocker la collection, plus d'état local `_isCollected` non synchronisé. |
| Bookmark grille visible           | ✅ Corrigé | `character_grid_card.dart` affiche désormais une icône bookmark active/inactive et synchronise l'état avec `userProfileProvider`.              |

## Tâches par abonnement

### Genin (gratuit) — Play Store early release

- Publier la version gratuite sur le Play Store.
- Auth Firebase email + Google avec persistance de session.
- Home feed de personnages.
- Recherche de personnages fonctionnelle.
- Fiche personnage complète avec description, galerie d'images en ligne, likes, commentaires, favoris et collection.
- Galerie plein écran avec images réseau + `cached_network_image` + shimmer.
- Collection limitée à 10 personnages.
- Profil et paramètres fonctionnels.
- Données Firestore : `users`, `characters`, `comments`, `likes`, `favorites`, `collections`.
- Pages légales et confidentialité disponibles.
- Images animés non locales pour garder l'APK < 60 MB.

### Jonin — phase 2

- Collection illimitée.
- Suppression des publicités.
- IA chatbot personnage.
- Quiz IA.
- Recommandations personnalisées.
- Page d'abonnement / PlansScreen.
- Intégration paiement mobile (CinetPay / FedaPay).
- Gestion des souscriptions.
- Thèmes premium.

### Kage — phase 3

- Génération d'image IA sans watermark.
- Téléchargement d'images HD.
- Thèmes exclusifs avancés.
- Badge priorité Fan.
- Gestion complète Kage dans l'app.
- Expérience premium haut de gamme.

## Notes de priorisation

- La version gratuite doit déjà pouvoir être publiée : consultation, recherche, détail, galerie, collection/favoris, likes/comments.
- Les images doivent provenir du réseau (Firebase / CDN AniList) et non localement.
- Jonin et Kage viennent après le MVP gratuit.

- Routes personnalisées accessibles sans compte : ✅ Corrigé — `/collection` et `/notifications` passent par `AuthRequiredScreen`; Home/Search restent publics.
- Avatar non persistant : 🟡 Moyenne — L'avatar sélectionné via `image_picker` est un chemin temp/cache et peut être perdu au redémarrage ; Firebase Storage repoussée.
- Storage Firebase : 🟡 Moyenne — Non initialisé volontairement pour l'instant.
- `flutter pub get` : ✅ Corrigé — relancé après ajout de `firebase_auth` + `cloud_firestore`; `flutter analyze` + `dart analyze` → 0 issue.

---

## Prochaine tâche recommandée

**Task 13 — Play Store preparation** ✅ Fait

- Activer GitHub Pages pour les pages légales `docs/`
- Vérifier les URLs publiques Play Console : privacy policy, CGU, suppression de compte
- Préparer les textes Play Store : description courte, description complète, catégorie, tags
- Préparer Data Safety : données collectées, finalités, partage avec tiers
- Vérifier Firebase Auth providers activés dans Firebase Console : Email/Password + Google
- Tester login/register/logout sur Android réel ou émulateur
- Déployer `firestore.rules` avant release
- Préparer captures d'écran Play Store

**Task 14 — PlansScreen** ✅ Fait

**Task 16 — PlansScreen** ✅ Fait

- `lib/features/subscription/presentation/plans_screen.dart` — Rewritten complet
- Header "Débloque OTADEX Premium ⭐" + sous-titre centré
- Toggle mensuel/annuel (BillingToggle réutilisé)
- Genin card (PlanCard) — disabled si currentRank == genin, AlertDialog confirmation si rétrograder
- Jonin card (PlanCard + \_GlowWrapper bleu) — badge POPULAIRE, glow statBlue
- Kage card (\_KageCard) — gradient #1A0A2E→#0D0D0F, border statPurple, glow violet, ShaderMask titre, bouton GestureDetector gradient
- Flow Chariow — liens d'achat externes + activation locale de licence Jonin/Kage
- Prix multi-devises selon préférence profil
- dart analyze → 0 erreur

**Task 18 — CharacterDetailScreen enrichi + nouveaux écrans** ✅ Fait

- `CharacterDetailScreen` → 5 onglets (Infos / Galerie / Relations / Médias / Exclusif) rank-aware
  - Onglet Infos : grille identité 2×3 (âge/genre/statut/nationalité/groupe sanguin/naissance), bio tronquée Genin, pouvoirs (3 max Genin), citations Jonin+, doubleurs AniList Jonin+, trivia Kage only
  - Onglet Relations : réseau AniList avec badges Ami/Rival/Ennemi/Famille (verrouillé Genin)
  - Onglet Médias : apparitions animé/manga + staff + studios depuis AniList (tous)
  - Onglet Exclusif : chatbot IA / génération image / quiz Kage (gate Genin/Jonin)
- `StudioScreen` → Créé (/studio/:id) — filmographie AniList, stats, grid 2 colonnes
- `VoiceActorScreen` → Créé (/voice-actor/:id) — bio, stats, rôles connus AniList
- `CharacterChatScreen` → Créé (/chat/:charId) — gate Kage, chatbot simulé, typing indicator
- `CharacterQuizScreen` → Créé (/quiz/:charId) — gate Jonin, 5 QCM, score + Firestore
- `Character` model enrichi : bloodType, dateOfBirth, quotes, trivia, aiPersonality, voiceActorIds
- `AniListService` enrichi : getFullCharacterData, getStudioById, getVoiceActorById
- `app_router` : 4 nouvelles routes (/studio/:id, /voice-actor/:id, /chat/:charId, /quiz/:charId)
- dart analyze → 0 erreur, 0 warning

**Task 19 (correctif) — Stratégie freemium corrigée** ✅ Fait

- Principe fondamental appliqué : le contenu encyclopédique est 100% accessible aux Genin
- **Supprimé** : bio tronquée Genin → expand/collapse pour TOUS
- **Supprimé** : limite 3 pouvoirs Genin → tous les pouvoirs visibles
- **Supprimé** : citations verrouillées Genin → toutes visibles
- **Supprimé** : doubleurs verrouillés Genin → tous visibles
- **Supprimé** : relations verrouillées Genin → toutes visibles
- **Gardé** : Trivia Kage uniquement (anecdotes exclusives)
- **Onglet Exclusif refait** en 3 niveaux :
  - Genin → écran verrouillé élégant avec liste des 4 fonctionnalités + CTA Kage + lien Jonin
  - Jonin → quiz accessible + 3 bannières upsell Kage élégantes
  - Kage → chatbot + génération image + quiz (inchangé)
- **Ajouté** : `_buildUpsellBanner` — bannière contextuelle non-intrusive (lock icon + tier + bouton Débloquer)
- **Ajouté** : `_exclusifFeatureRow` — ligne feature+tier dans l'écran Genin
- **Ajouté** : `_buildQuizCard` — widget réutilisé Jonin + Kage
- **Galerie** : note filigrane OTADEX pour Genin + bannière pub simulée 52px (Genin uniquement)
- dart analyze → 0 erreur, 0 warning (4 hints info pré-existants hors périmètre)

**Task 20 — Mock data enrichie** ✅ Fait

- `CharacterRelation`, `VoiceActorMock`, `MediaAppearanceMock`, `QuizQuestion` créés dans `character.dart`
- 8 personnages enrichis : quotes, trivia, aiPersonality, relations, voiceActors, mediaAppearances, quizQuestions
- Luffy (One Piece) et Frieren (FBJ) ajoutés comme nouveaux personnages mock
- `mockStudios` (5 studios) et `mockMangakas` (6 auteurs) ajoutés dans `MockData`
- Onglets Relations / Médias / Doubleurs : priorité mock → AniList → fallback texte
- `CharacterQuizScreen` accepte `List<QuizQuestion>` spécifique au personnage
- Note : Remplacer mock par AniList API live dans une prochaine tâche post-release

**Task 21 — Correctifs release + premium local** ✅ Fait

- Android label corrigé : `Otadex`
- `build.gradle.kts` nettoyé : plus de mots de passe release hardcodés, fallback debug si `key.properties` absent
- `.gitignore` renforcé : `serviceAccountKey.json`, `*.jks`, `key.properties`
- `upload_images.js` ne pointe plus vers le vieux dossier supprimé `assets/images/Animé pictures`; dossier source passé en argument possible
- Préférence monnaie ajoutée dans le profil : XAF, USD, EUR, GBP, CAD, NGN
- Prix centralisés via `PlanPrices` : Jonin 2 000 FCFA/mois, Kage 5 000 FCFA/mois, affichage selon monnaie utilisateur
- `PlansScreen` affiche mensuel/annuel avec `BillingToggle` et active localement Jonin/Kage via licence Chariow
- Fonctions premium finalisées sans Cloud Function : chatbot local OTADEX, quiz variable selon nombre de questions, génération locale d'image citation Kage
- `flutter analyze` → 0 issue

**Task 22 — Import JJK Firestore** ✅ Fait

- `scripts/import_jjk.js` → Créé (1 415 lignes)
- Import exécuté le 18 mai 2026 avec `firebase-admin` + `mammoth`
- Vérification Firestore OK : `animes/jujutsu-kaisen`, `creators/gege-akutami`, `studios/mappa`, 20 personnages, 7 quiz
- `scripts/google_time_offset.js` ajouté pour compenser le décalage d'horloge local lors de la signature JWT Google Auth
- Structure Firestore définie : `animes` / `creators` / `studios` / `characters` / `quizzes`
- 20 personnages JJK complets : nom, nomJaponais, description, pouvoirs, voixJaponaise, voixAnglaise, relations, citations, trivia, popularityRank
- Créateur Gege Akutami : bio, bibliographie complète, récompenses, influences
- Studio MAPPA : fondation, productions, description
- 7 quiz créés (5+ questions chacun) : Gojo, Yuji, Sukuna, Megumi, Nobara, Geto, Nanami
- `firestore.indexes.json` mis à jour : 3 index composites (animeId+popularityRank, animeId+statut, animeId+likesCount)
- `scripts/README.md` créé : instructions d'exécution + template réutilisable pour futurs animés
- Note : dans cet environnement, `node` Snap est inutilisable ; commande validée :
  `env NODE_OPTIONS='--require ./scripts/google_time_offset.js' /home/tilstack/.cache/ms-playwright-go/1.50.1/node scripts/import_jjk.js`
- Note : Template réutilisable pour chaque nouvel animé via `scripts/import_[anime_name].js`
- Prochaine tâche → Brancher Flutter sur Firestore (remplacer mock_data par Firestore queries)

**Task 23 — Firestore Flutter integration** ✅ Fait

- `lib/core/services/firestore_character_service.dart` → Créé
  - `getCharactersByAnime(animeId)` — requête Firestore ordonnée par `popularityRank`
  - `getCharacterById(id)` — fetch direct par ID Firestore
  - `getQuizForCharacter(characterId)` — quiz Firestore → `List<QuizQuestion>`
  - `getAllAnimes()` / `getAnimeById()` — collection Firestore `animes`
  - `getAllCreators()` / `getCreatorById()` — collection Firestore `creators`
  - Mapping complet : `nom`→`name`, `description`→`bio`, `pouvoirs`→`powers`, `citations`→`quotes`, `statut`→`status`, `rang`→`tier`, relations→`CharacterRelation`, voix→`VoiceActorMock`
- `lib/core/providers/anilist_providers.dart` mis à jour :
  - `firestoreCharacterServiceProvider` — singleton du service
  - `jjkCharactersProvider` — FutureProvider JJK depuis Firestore
  - `firestoreQuizProvider` — quiz Firestore par personnage ID
  - `characterDetailProvider` : `jjk-*` → Firestore, `anilist-*` → AniList, sinon mock
- `lib/core/providers/otadex_providers.dart` mis à jour :
  - `allCharactersProvider` → FutureProvider fusionné (Firestore JJK + mock autres séries)
  - `newCharactersProvider` → FutureProvider.family filtre sur allCharactersProvider
  - `recommendedCharactersProvider` → filtre préférences utilisateur sur allCharactersProvider
  - `allAnimesProvider` → Firestore en priorité, fallback mock
  - `allCreatorsProvider` → Firestore en priorité, fallback mock
- dart analyze → 0 erreur, 0 warning

**Task 24 — Architecture multi-animés + Recherche unifiée** ✅ Fait

- `Character` model : champ `animeId` ajouté (nullable, passe par Firestore → tous animés futurs)
- `firestore_character_service.dart` :
  - `getAllCharacters({int limit = 100})` — tous animés Firestore triés par `animeId`+`popularityRank`
  - `searchCharacters(query)` — recherche client-side sur `name`, `animeName`, `role`, `powers`
  - `searchAnimes(query)` — recherche client-side sur `name`, `genres`
  - `getSameAnimeCharacters({animeId, excludeCharacterId, limit})` — personnages du même animé (excluant le courant)
  - `getAllAnimesWithCharacterCount()` — alias de `getAllAnimes()`
  - `_characterFromFirestore` : passe `animeId` au modèle Character
- `anilist_service.dart` :
  - `getCharactersByAnimeId(anilistId, {perPage})` — personnages d'un animé AniList (fallback futur)
- `anilist_providers.dart` :
  - `searchCharactersProvider` remplace `searchResultsProvider` — fusion Firestore + AniList, dédupliqué par `name`
  - `searchAnimesProvider` — fusion Firestore + AniList, dédupliqué par `name`
  - `sameAnimeCharactersProvider` — Firestore prioritaire, fallback AniList si `animeId.startsWith('anilist-')`
- `otadex_providers.dart` :
  - `allCharactersProvider` → `getAllCharacters(limit: 100)` (tous animés Firestore) + mock uniquement pour IDs non présents dans Firestore
- `search_screen.dart` : utilise `searchCharactersProvider` (était `searchResultsProvider`)
- `character_detail_screen.dart` :
  - `_buildSameAnimeSection(theme)` — section horizontal scroll "Autres personnages de [animé]" dans l'onglet Médias
  - Présente pour les 3 branches du tab Médias (mock, no-anilist, AniList)
- Note : "Chaque `scripts/import_[anime].js` ajoute un animé complet — aucune modification de code Flutter requise"
- dart analyze → 0 erreur, 0 warning

**Task 24b — Design OTADEX Character Sheet (handoff Claude Design)** ✅ Fait

- Source : maquette haute-fidélité 6 vues (Infos / Galerie / Relations / Médias / Exclusif Genin / Exclusif Jonin) — 390×844px dark mode
- `character_detail_screen.dart` :
  - **Identity grid refactorisée** : cellules individuelles (`Container` + `borderRadius: 10`) sans container parent, labels en sentence-case (Âge / Genre / Statut / Nationalité / Groupe sanguin / Naissance), `childAspectRatio: 2.6`
  - **Section À propos** : suppression du card wrapper — texte directement sur le fond surface, bouton "Lire la suite ↓" en accent orange sans container intermédiaire
  - **Section "👥 Découvrir d'autres personnages"** (nouveau) : scroll horizontal `SizedBox(height: 168)`, portrait cards 124px via `allCharactersProvider` (filtre le personnage courant, max 6), gradient bg `cardColor → backgroundDeep`, `OtadexImage` plein cadre, overlay gradient bas, accent strip 4×16px `accentColor`, nom + animeName en bas, tuile "Voir tout / N personnages" orange en dernier item → `/search`
  - Import `otadex_providers.dart` ajouté
- dart analyze → 0 erreur, 0 warning

**Task 25 — Play Store préparation** ✅ Fait

- ✅ Fix Quiz → branché sur `firestoreQuizProvider` (déjà présent depuis session précédente — `character_quiz_screen.dart` détecte `jjk-` prefix et charge Firestore)
- ✅ `android:label` corrigé → `"OTADEX"` (était `"Otadex"`) dans `AndroidManifest.xml`
- ✅ `PLAY_STORE_SIGNING.md` → créé (instructions keytool + key.properties + note config Kotlin DSL déjà en place)
- ✅ `PLAY_STORE_TODO.md` → créé (checklist complète Play Store — Firestore import, device test, signing build, assets, soumission)
- Note : Tester l'app sur device AVANT le build release
- Note : Lancer manuellement `node scripts/import_jjk.js` (nécessite `serviceAccountKey.json`)
- Note : `applicationId = "com.otadex.otadex"` (Firebase-bound — ne pas changer)
- dart analyze → 0 erreur

---

### GitHub Pages — activé

Le site GitHub Pages est activé et le projet est public.

URLs publiques :

- Politique de confidentialité : `https://otadex.tilstack.me/privacy-policy.html`
- CGU : `https://otadex.tilstack.me/terms.html`
- Suppression de compte : `https://otadex.tilstack.me/account-deletion.html`

## Protection contre les usages malveillants

- Ajouter une licence explicite pour clarifier les conditions d'utilisation.
- Ne jamais committer de clés ou secrets dans le dépôt.
- Renforcer les règles Firestore pour autoriser l'accès uniquement aux utilisateurs authentifiés et aux rôles définis.
- Activer 2FA sur le compte GitHub principal.
- Ajouter un `SECURITY.md` et, si utile, un `CODE_OF_CONDUCT.md` pour préciser les usages interdits.

> Le projet est public ; il est donc essentiel de contrôler les données et les accès avant de publier un backend réel.

### GitHub Pages

Pages présentes dans `docs/` sur la branche `master`.

URLs Play Console :

- Politique de confidentialité : `https://otadex.tilstack.me/privacy-policy.html`
- CGU : `https://otadex.tilstack.me/terms.html`
- Suppression de compte : `https://otadex.tilstack.me/account-deletion.html`

---

## Historique des sessions

| Date        | Travail effectué                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ----------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Mai 2026    | Initialisation projet — Task 01 : Splash, Onboarding, Auth (mock)                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| Mai 2026    | Task 02 : HomeScreen réactif (isLoggedInProvider), ProfileScreen complet, avatar picker avec Jonin gate, permissions Android image_picker                                                                                                                                                                                                                                                                                                                                                                                 |
| 5 mai 2026  | Task 03 : Fix bug auth persistance (main.dart override isLoggedInProvider), AnimeDetailScreen complet, CreatorScreen complet, router mis à jour (/anime/:id, /creator/:id)                                                                                                                                                                                                                                                                                                                                                |
| 8 mai 2026  | Task 04 : CollectionScreen branché (Tab 2 BottomNav), UserProfile.collectedCharacterIds + addToCollection/removeFromCollection, placeholder FR corrigé, compteur collection cohérent                                                                                                                                                                                                                                                                                                                                      |
| 8 mai 2026  | Task 05 : Assets images JJK locales (15 personnages, ~120 images), app_assets.dart, OtadexImage widget (local+réseau), mock_data.dart → 5 personnages JJK avec images réelles, Character.images ajouté                                                                                                                                                                                                                                                                                                                    |
| 8 mai 2026  | Task 06 : AniList GraphQL live — http:^1.2.0 ajouté, AniListService (search/trending/detail), anilist_providers.dart (trending, featuredSlides, searchResults, characterDetail), HomeScreen héro + tendances branchés AniList, SearchScreen debounce 400ms + résultats live, fallback mock si réseau indisponible                                                                                                                                                                                                         |
| 8 mai 2026  | Task 07 : Nettoyage assets — pubspec.yaml allégé (logo/splash/onboarding/characters uniquement), app_assets.dart reécrit avec vrais fichiers locaux, assets/images/jujutsu_kaisen/ supprimé (~120 images), assets/images/Animé pictures/ supprimé, mock_data.dart migré vers imagePath réseau (images: [] pour JJK), splash+onboarding utilisent AppAssets.\*                                                                                                                                                             |
| 8 mai 2026  | Task 08 : Images mock → URLs AniList CDN — 8 personnages mis à jour (Gojo, Yuji, Sukuna, Megumi, Maki, Sung Jin-Woo, Tanjiro, Levi), plus d'imagePath vide ou placeholder local incorrect. searchAnimes() ajouté à AniListService. dart analyze → 0 erreur.                                                                                                                                                                                                                                                               |
| 9 mai 2026  | Task 09 : GalleryScreen — galerie plein écran (gallery_screen.dart), route /gallery/:charId, route stub /subscription ajoutées à app_router.dart, character_detail_screen.dart migré vers OtadexImage + navigation galerie. dart analyze → 0 erreur.                                                                                                                                                                                                                                                                      |
| 9 mai 2026  | Task 10 : Firebase Core — `flutterfire configure` projet `tilqui`, `firebase_options.dart`, `google-services.json`, `firebase_core` ajouté, `Firebase.initializeApp()` branché dans main.dart, Firebase CLI initialisé pour Firestore + Functions, Storage repoussé. flutter analyze → 0 issue.                                                                                                                                                                                                                           |
| 9 mai 2026  | Décision conformité Google Play : ajouter avant Firebase Auth des pages légales web publiques pour Politique de confidentialité, Conditions d'utilisation et Suppression de compte. Objectif : disposer d'URLs publiques compatibles Play Console, en plus des écrans légaux intégrés dans l'app.                                                                                                                                                                                                                         |
| 10 mai 2026 | Task 11 : Pages légales web — docs/index.html, docs/privacy-policy.html, docs/terms.html, docs/account-deletion.html. Dark OTADEX theme, toggle FR/EN, conforme Play Store. GitHub Pages prêt (activation manuelle requise).                                                                                                                                                                                                                                                                                              |
| 10 mai 2026 | Task 12 : Firebase Auth réelle — dépendances `firebase_auth` + `cloud_firestore`, `firebase_auth_service.dart`, login/register email + Google branchés, logout profil branché, profil utilisateur créé dans Firestore à l'inscription, rang initial restauré depuis SharedPreferences. flutter analyze + dart analyze → 0 issue.                                                                                                                                                                                          |
| 10 mai 2026 | Task 13 : Auth avancée — mot de passe oublié `password_reset_sheet.dart` implémenté (email + code reset), changement de mot de passe `change_password_sheet.dart` avec réauth Firebase, édition profil persistée dans Firestore / SharedPreferences. flutter analyze → 0 erreur.                                                                                                                                                                                                                                          |
| 10 mai 2026 | Task 14 : Play Store preparation lancée — docs/play-store ajoutés (listing FR, Data Safety, test plan, screenshots), firestore.rules remplacé localement par des règles hors mode test. Actions manuelles restantes : GitHub Pages, providers Firebase, déploiement rules, tests Android, captures.                                                                                                                                                                                                                       |
| 10 mai 2026 | Retours test auth/home — déconnexion redirige vers login, pseudo utilisateur restauré dans profil et HomeAppBar, page notifications avec état vide ajoutée, route `/notifications` créée, FirebaseAuthService persiste uid/email/pseudo/rang localement après login/register. flutter analyze + dart analyze → 0 issue.                                                                                                                                                                                                   |
| 10 mai 2026 | Vérification accès invité/connecté — Home et Search restent accessibles publiquement, Collection et Notifications sont protégées en accès direct par AuthRequiredScreen, la réhydratation du profil local ne se fait que si l'utilisateur est connecté.                                                                                                                                                                                                                                                                   |
| 14 mai 2026 | Firebase Storage images — upload_images.js créé (Node.js, upload 131 images vers Storage bucket tilqui.appspot.com), firebase_storage ^11.6.0 ajouté, StorageService créé (getCharacterImages + getCharacterCover), storageServiceProvider + characterImagesProvider ajoutés dans anilist_providers.dart, \_effectiveImages dans CharacterDetailScreen priorise Storage → images AniList → imagePath → fallback. dart analyze → 0 issue.                                                                                  |
| 15 mai 2026 | Task 15 — Collection persistante Firestore — CollectionService créé (getCollection, collectionStream, addToCollection/removeFromCollection avec gate Genin 10 persos), collectionServiceProvider + collectionStreamProvider + isCollectedProvider ajoutés dans anilist_providers.dart, CharacterDetailScreen FAB branché sur Firestore (FieldValue.arrayUnion/Remove) + gate LIMIT_REACHED → modal upgrade Jonin, CollectionScreen migré vers collectionStreamProvider (when loading/error/data). dart analyze → 0 issue. |
| 15 mai 2026 | Task 16 — PlansScreen complet — plans_screen.dart réécrit (ConsumerStatefulWidget), toggle BillingToggle réutilisé, flow premium ensuite migré vers Chariow/licence locale. dart analyze → 0 issue.                                                          |

| 16 mai 2026 | Task 18 — CharacterDetailScreen enrichi (5 onglets rank-aware : Infos / Galerie / Relations / Médias / Exclusif 👑), StudioScreen + VoiceActorScreen + CharacterChatScreen + CharacterQuizScreen créés, Character model enrichi (bloodType/dateOfBirth/quotes/trivia/aiPersonality/voiceActorIds), AniListService enrichi (getFullCharacterData/getStudioById/getVoiceActorById), app_router 4 nouvelles routes. dart analyze → 0 erreur, 0 warning. |
| 16 mai 2026 | Task 19 correctif — Stratégie freemium corrigée : contenu encyclopédique 100% libre pour Genin (bio complète, tous pouvoirs, citations, doubleurs, relations), Trivia Kage uniquement, onglet Exclusif refait en 3 niveaux (Genin locked / Jonin quiz + upsell banners / Kage all), _buildUpsellBanner contextuel, bannière ads simulée Genin en galerie. dart analyze → 0 erreur. |
| 17 mai 2026 | Task 20 — Mock data enrichie : quotes, trivia, aiPersonality, relations, voiceActors, mediaAppearances, quizQuestions pour 8 personnages existants + ajout Luffy (One Piece) et Frieren (FBJ). Modèles CharacterRelation/VoiceActorMock/MediaAppearanceMock/QuizQuestion créés dans character.dart. mockStudios (5) et `mockMangakas` (6) ajoutés dans MockData. Onglets Relations/Médias/Doubleurs branchés sur mock data (priorité mock → AniList → fallback). Quiz screen accepte List<QuizQuestion> spécifique au personnage (fallback générique si absent). app_router passe quizQuestions via extra. dart analyze → 0 erreur. |
| 17 mai 2026 | Task 21 — Correctifs release + premium local : label Android `Otadex`, signing release sans secrets hardcodés, `.gitignore` renforcé, `upload_images.js` nettoyé, préférence monnaie profil ajoutée, prix plans multi-devises centralisés, Kage fixé à 5 000 FCFA/mois, activation licence Chariow locale Jonin/Kage, assistant local OTADEX, génération locale d'image citation Kage, quiz sans limite fixe à 5 questions. flutter analyze → 0 issue. |
| 18 mai 2026 | Task 22 — Import JJK Firestore : `scripts/import_jjk.js` créé (20 personnages JJK, 1 animé, 1 créateur, 1 studio, 7 quiz). Données extraites depuis `JJK_Personnages_OTADEX_v2.docx` via mammoth/python XML. `firestore.indexes.json` mis à jour (3 index composites). `scripts/README.md` créé avec template réutilisable. |
| 19 mai 2026 | Task 23 — Firestore Flutter integration : `FirestoreCharacterService` créé (mapping Firestore→Character/AnimeEntry/CreatorEntry/QuizQuestion). `jjkCharactersProvider` + `firestoreQuizProvider` ajoutés. `characterDetailProvider` mis à jour (jjk-*→Firestore). `allCharactersProvider` fusionné (JJK Firestore + mock autres séries). `allAnimesProvider` / `allCreatorsProvider` priorité Firestore + fallback mock. dart analyze → 0 erreur. |
| 19 mai 2026 | Task 24 — Architecture multi-animés : `Character.animeId` ajouté. `searchCharacters`/`searchAnimes`/`getSameAnimeCharacters` ajoutés au service Firestore. `getCharactersByAnimeId` ajouté à AniList service. `searchCharactersProvider` + `searchAnimesProvider` (fusion Firestore+AniList) + `sameAnimeCharactersProvider` créés. `allCharactersProvider` migré vers `getAllCharacters(limit:100)`. Section "Autres personnages de [animé]" dans onglet Médias. dart analyze → 0 erreur. |
| 19 mai 2026 | Task 24b — Design handoff Claude Design : identity grid refactorisée (cellules individuelles, sentence-case), section À propos sans card wrapper (texte direct), section "👥 Découvrir d'autres personnages" ajoutée bas de l'onglet Infos (scroll horizontal portrait cards 124px, allCharactersProvider, gradient+image+accent strip+voir tout tile). dart analyze → 0 erreur. |
| 19 mai 2026 | Task 25 — Play Store préparation : `android:label` corrigé "OTADEX", Fix Quiz Firestore confirmé (déjà branché), `PLAY_STORE_SIGNING.md` créé (keytool + Kotlin DSL signing déjà configuré), `PLAY_STORE_TODO.md` créé (checklist complète device test → build → assets → soumission). dart analyze → 0 erreur. |

| 20 mai 2026 | Task 26 — Fix images JJK + AniList : `import_jjk.js` → URLs AniList CDN ajoutées pour les 20 personnages JJK (images[] + imagePath). `anilist_service.dart` → `imagePath: largeImg ?? ''`, filtrage `isNotEmpty` sur images[]. `otadex_image.dart` → `httpHeaders: {'User-Agent': 'OTADEX/1.0'}` ajouté à CachedNetworkImage. `_effectiveImages` dans `character_detail_screen.dart` → priorité images[] custom → imagePath → Firebase Storage → [] vide (plus de fallback local Gojo). `character_grid_card.dart` + `trending_character_card.dart` → logique image : `images.first` si disponible, sinon `imagePath`, sinon gradient. dart analyze → 0 issue. Note : Lancer `node scripts/import_jjk.js` pour pousser les nouvelles URLs vers Firestore. |

| 22 mai 2026 | Task 27 — Architecture données clarifiée + correctifs UX : `otadex_providers.dart` → `allCharactersProvider` simplifié (Firestore 200 persos OU JSON fallback, plus de merge). `trendingCharactersProvider` ajouté (filtre isTrending sur allCharactersProvider, tri likes desc, limit 20) — remplace AniList live dans `trending_section.dart`. `anilistTrendingCharactersProvider` renommé dans `anilist_providers.dart` (suppression conflit). `CollectionScreen` → remplace `MockData.allCharacters` par double-watch `collectionStreamProvider` + `allCharactersProvider` (IDs Firestore désormais résolus). `EmptyState` → bouton "Explorer" route `/search`, icône `bookmark_border_rounded`. `profile_screen.dart` → remplace `MockData` par `allCharactersProvider.valueOrNull`. `UserProfile` → 3 getters calculés dynamiquement : `fanLevel` (seuils 100/500/2000/5000), `fanLevelName` (Spectateur→Kage Suprême), `nextLevelScore`. `ProfileTabContent/_ProgressCard` → affiche `fanLevelName — Niveau fanLevel 🔥` (plus de "4" hardcodé). `search_screen.dart` → historique `_recentSearches` branché sur SharedPreferences : `_loadHistory` (initState), `_saveQuery` (submit/suggestion/trending tap), `_clearHistory`, `_removeRecentQuery` — liste vide au démarrage, persistée sur 5 entrées max. dart analyze → 0 issue. 
| 22 May 2026 | Task 29 — Import Naruto Shippuden : Création du script `import_ns.js` à partir du docx, 20 personnages préparés, mise en place des constantes `AppAssets` et mise à jour de `pubspec.yaml`. |
| 22 mai 2026 | Task 32 - Migration AniList vers Locale & refactor Images : [x] Importer images locals (JJK, NS, COE...), `OtadexImage` refactorisé pour prioriser locals assets, nettoyage des dépendances AniList dans les providers et scripts d'import. |
---

_À mettre à jour par Claude Code à la fin de chaque session._
_Dernière mise à jour : 22 mai 2026_
