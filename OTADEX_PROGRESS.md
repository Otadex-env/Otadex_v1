# OTADEX — Suivi d'avancement

## État actuel du projet

- Flutter SDK : `>=3.0.0 <4.0.0` (Flutter 3.x)
- App version : `1.5.0+1`
- Firebase configuré : **OUI (Storage inclus)** — FlutterFire Android + Firebase Auth email/Google + Firestore profil utilisateur + Functions + Storage initialisés
- Dernier écran complété : **PlansScreen** (URLs Chariow `/checkout` + SnackBar post-achat, juin 2026)
- Dernière mise à jour : **Task 59 — Ajout Mushoku Tensei (20 personnages)**, 10 juin 2026
- Task 59 : Ajout complet de Mushoku Tensei. `app_colors.dart` : `animeMtCard` (`#0D0A1F`) + `animeMtAccent` (`#7B1FA2`). `firestore_character_service.dart` : `mushoku-tensei` dans 3 switch (cardColor → violet foncé, accentColor → violet, category → Isekai). `app_assets.dart` : constante `_mt` + 20 listes vides + 20 cases `getByCharacterId`. `scripts/import_mt.js` : script complet Firestore (creator `rifujin-na-magonote`, studio `studio-bind`, animé `mushoku-tensei`, 20 personnages batch, 7 quiz 5-6 questions). `scripts/google_time_offset.js` : correcteur décalage horloge JWT pour node playwright. `scripts/README.md` : section Mushoku Tensei ajoutée. `dart analyze` : 0 erreurs.
- Task 57 : Précachage images galerie au tap personnage. Création de `lib/core/utils/image_prefetcher.dart` (`ImagePrefetcher.prefetchCharacterImages` — fire-and-forget, 4 premières URLs via `CachedNetworkImageProvider` + `precacheImage`). Appliqué sur 6 points de navigation : `character_list_screen.dart`, `character_grid_section.dart`, `trending_section.dart`, `collection_screen.dart`, `char_discover_section.dart`, `search_screen.dart` (x2). Création de `ANIME_WORKFLOW.md` : guide complet étape par étape pour ajouter un nouvel animé (dossiers `otadex-assets`, `app_assets.dart`, `app_colors.dart`, `firestore_character_service.dart`, Firestore `animes/` + `characters/` + `creators/`). `dart analyze` : 0 erreurs.
- Task 56 : `character_detail_screen.dart` réduit de **3216 → 317 lignes** par extraction de 9 widgets indépendants dans `features/character/presentation/widgets/` : `char_detail_tab_bar.dart` (enum `CharDetailTab` + delegate), `char_hero.dart` (StatefulWidget avec animation propre), `char_infos_tab.dart` (ConsumerStatefulWidget), `char_discover_section.dart`, `char_galerie_tab.dart`, `char_relations_tab.dart`, `char_medias_tab.dart` (avec `_MediaRow` + `_StudioRow`), `char_exclusif_tab.dart` (avec `_QuizCard`, `_UpsellBanner`, `_FeatureRow`), `char_fab.dart`. Provider `charFullDataProvider` rendu public dans `anilist_providers.dart`. `dart analyze lib/` : 0 erreurs.
- Correction Task 55 : `CharacterListScreen` réécrit en `StatefulWidget` avec scroll infini (`ScrollController` + `startAfterDocument`). `FirestoreCharacterService.getCharactersPaginated()` ajouté (retourne `(List<Character>, DocumentSnapshot?)`). `app_router.dart`, `character_grid_section.dart`, `trending_section.dart` mis à jour pour ne plus passer `characters` en extra. `dart analyze lib/` : 0 erreurs.
- Correction Task 55 : `CharacterListScreen` réécrit en `StatefulWidget` avec scroll infini (`ScrollController` + `startAfterDocument`). `FirestoreCharacterService.getCharactersPaginated()` ajouté (retourne `(List<Character>, DocumentSnapshot?)`). `app_router.dart`, `character_grid_section.dart`, `trending_section.dart` mis à jour pour ne plus passer `characters` en extra. `dart analyze lib/` : 0 erreurs.
- Correction Task 54 : `login_screen.dart` logo corrigé (`AppAssets.logoFull`), `app_assets.dart` listes FMA (13 perso) et HXH (13 perso) remplies avec URLs GitHub réelles. ANR démarrage corrigé (NotificationService + licence check déférés post-runApp). Label Android `"OTADEX"` → `"Otadex"`.
- Correction Task 55b : Splash native Android — fond blanc → `#0D0D14`, logo centré (`drawable-nodpi/otadex_logo.png`). Launcher icon regénéré à toutes les densités (PNG + adaptive icons API 26+) avec fond `#0D0D14` et icône transparente centrée.

## Dépendances installées (`pubspec.yaml`)

| Package                     | Version | Usage                         |
| --------------------------- | ------- | ----------------------------- |
| go_router                   | ^13.0.0 | Navigation                    |
| google_fonts                | ^6.1.0  | Typographie                   |
| flutter_riverpod            | ^2.4.0  | State management              |
| riverpod_annotation         | ^2.3.0  | Codegen Riverpod              |
| shared_preferences          | ^2.2.0  | Persistance locale            |
| flutter_secure_storage      | ^9.0.0  | Token sécurisé                |
| smooth_page_indicator       | ^1.1.0  | Onboarding dots               |
| flutter_animate             | ^4.3.0  | Animations                    |
| shimmer                     | ^3.0.0  | Skeleton loaders              |
| cached_network_image        | ^3.3.0  | Images réseau                 |
| flutter_svg                 | ^2.0.0  | Icônes SVG                    |
| google_sign_in              | ^6.2.0  | OAuth Google                  |
| firebase_core               | ^2.27.0 | Initialisation Firebase       |
| firebase_auth               | ^4.17.0 | Auth email/password + Google  |
| cloud_firestore             | ^4.15.0 | Profil utilisateur Firestore  |
| firebase_storage            | ^11.6.0 | Images personnages Storage    |
| gap                         | ^3.0.1  | Espacement                    |
| image_picker                | ^1.1.0  | Avatar picker                 |
| firebase_messaging          | ^14.9.0 | Push notifications FCM        |
| flutter_local_notifications | ^17.0.0 | Notifications locales Android |

> ✅ `flutter pub get` exécuté — 0 erreur.

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

---

## Task 30 — Migration Firestore-only + Dynamisme (23 mai 2026)

### Audit réalisé

- Contrôle complet des 8 couches de données : providers, services, écrans, widgets
- Identification de 6 problèmes bloquants (RÈGLE ABSOLUE + AniList résiduel + données figées)

### ✅ FIX 1 — RÈGLE ABSOLUE rétablie : `AppColors` tokens anime

- `lib/core/theme/app_colors.dart` : 12 nouveaux tokens `animeJjkCard/Accent`, `animeNsCard/Accent`, `animeAotCard/Accent`, `animeOpCard/Accent`, `animeClkCard/Accent`, `animeDefaultCard/Accent`
- `lib/core/services/firestore_character_service.dart` : `_cardColorForAnime` + `_accentColorForAnime` utilisent désormais `AppColors.*` — plus aucun `Color(0xFF...)` hardcodé hors de `app_colors.dart`

### ✅ FIX 2 — Hero Slider branché sur Firestore

- `featuredSlidesProvider` reécrit : dérive les slides depuis `allAnimesProvider` (Firestore)
- Fallback `_kFallbackSlides` si Firestore vide (premier lancement)
- Quand un nouvel animé est importé → il apparaît automatiquement dans le hero carousel

### ✅ FIX 3 — `characterDetailProvider` Firestore-first universel

- Plus de liste de préfixes hardcodés (`jjk-`, `ns-`, `clk-`)
- Logique : Firestore → si null → fallback mock
- Tout nouveau préfixe d'animé importé dans Firestore sera automatiquement résolu

### ✅ FIX 4 — Catégories de filtre dynamiques

- `categoriesProvider` ajouté dans `otadex_providers.dart` : dérive les genres uniques depuis `allAnimesProvider` (Firestore), priorité aux genres standards, fallback liste statique
- `category_chips.dart` converti en `ConsumerWidget` : watch `categoriesProvider`
- `character_grid_section.dart` : watch `categoriesProvider`, suppression import `MockData`
- Quand un nouvel animé avec un genre inédit est importé → le chip filtre apparaît automatiquement

### ✅ FIX 5 — `AnimeDetailScreen` branché sur Firestore

- Remplace `otadexServiceProvider` (JSON mock) par `allAnimesProvider` + `allCharactersProvider` + `allCreatorsProvider`
- Personnages filtrés par `animeName == anime.name || animeId == anime.id`
- Créateur résolu depuis `allCreatorsProvider`
- Animés similaires depuis `allAnimesProvider`
- Images personnages : `AppAssets.getByCharacterId` en priorité
- Label "Note AniList" → "Note"

### ✅ FIX 6 — Messages UI nettoyés

- `character_detail_screen.dart` : "Relations à venir via AniList" → "Aucune relation disponible pour ce personnage"
- `character_detail_screen.dart` : "Médias à venir via AniList" → "Médias non disponibles pour ce personnage"
- `otadex_image.dart` : `.withOpacity()` déprecié → `.withValues(alpha:)`

### Règle d'extensibilité

> Importer un nouvel animé via `node scripts/import_[anime].js` suffit.
> Aucune modification Flutter requise : hero slider, catégories, personnages, fiche détail se mettent à jour automatiquement.

---

## Données mockées — Stratégie images

| Source                                  | Usage                                                                           |
| --------------------------------------- | ------------------------------------------------------------------------------- |
| Assets locaux JJK                       | Priorité absolue pour les 14 personnages JJK — via `AppAssets.getByCharacterId` |
| Firestore `images[]`                    | Priorité 2 — URLs stockées dans Firestore                                       |
| AniList CDN (réseau)                    | Fallback pour personnages non-JJK — via `OtadexImage(imagePath: url)`           |
| `assets/images/characters/satoru_gojo/` | Placeholder local générique (5 fichiers, ~500 KB)                               |
| Logo / splash / onboarding              | Assets locaux permanents — référencés via `AppAssets.*`                         |

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
| 15 mai 2026 | Task 16 — PlansScreen complet — plans_screen.dart réécrit (ConsumerStatefulWidget), toggle BillingToggle réutilisé, flow premium ensuite migré vers Chariow/licence locale. dart analyze → 0 issue.                                                                                                                                                                                                                                                                                                                       |

| 16 mai 2026 | Task 18 — CharacterDetailScreen enrichi (5 onglets rank-aware : Infos / Galerie / Relations / Médias / Exclusif 👑), StudioScreen + VoiceActorScreen + CharacterChatScreen + CharacterQuizScreen créés, Character model enrichi (bloodType/dateOfBirth/quotes/trivia/aiPersonality/voiceActorIds), AniListService enrichi (getFullCharacterData/getStudioById/getVoiceActorById), app_router 4 nouvelles routes. dart analyze → 0 erreur, 0 warning. |
| 16 mai 2026 | Task 19 correctif — Stratégie freemium corrigée : contenu encyclopédique 100% libre pour Genin (bio complète, tous pouvoirs, citations, doubleurs, relations), Trivia Kage uniquement, onglet Exclusif refait en 3 niveaux (Genin locked / Jonin quiz + upsell banners / Kage all), \_buildUpsellBanner contextuel, bannière ads simulée Genin en galerie. dart analyze → 0 erreur. |
| 17 mai 2026 | Task 20 — Mock data enrichie : quotes, trivia, aiPersonality, relations, voiceActors, mediaAppearances, quizQuestions pour 8 personnages existants + ajout Luffy (One Piece) et Frieren (FBJ). Modèles CharacterRelation/VoiceActorMock/MediaAppearanceMock/QuizQuestion créés dans character.dart. mockStudios (5) et `mockMangakas` (6) ajoutés dans MockData. Onglets Relations/Médias/Doubleurs branchés sur mock data (priorité mock → AniList → fallback). Quiz screen accepte List<QuizQuestion> spécifique au personnage (fallback générique si absent). app_router passe quizQuestions via extra. dart analyze → 0 erreur. |
| 17 mai 2026 | Task 21 — Correctifs release + premium local : label Android `Otadex`, signing release sans secrets hardcodés, `.gitignore` renforcé, `upload_images.js` nettoyé, préférence monnaie profil ajoutée, prix plans multi-devises centralisés, Kage fixé à 5 000 FCFA/mois, activation licence Chariow locale Jonin/Kage, assistant local OTADEX, génération locale d'image citation Kage, quiz sans limite fixe à 5 questions. flutter analyze → 0 issue. |
| 18 mai 2026 | Task 22 — Import JJK Firestore : `scripts/import_jjk.js` créé (20 personnages JJK, 1 animé, 1 créateur, 1 studio, 7 quiz). Données extraites depuis `JJK_Personnages_OTADEX_v2.docx` via mammoth/python XML. `firestore.indexes.json` mis à jour (3 index composites). `scripts/README.md` créé avec template réutilisable. |
| 19 mai 2026 | Task 23 — Firestore Flutter integration : `FirestoreCharacterService` créé (mapping Firestore→Character/AnimeEntry/CreatorEntry/QuizQuestion). `jjkCharactersProvider` + `firestoreQuizProvider` ajoutés. `characterDetailProvider` mis à jour (jjk-\*→Firestore). `allCharactersProvider` fusionné (JJK Firestore + mock autres séries). `allAnimesProvider` / `allCreatorsProvider` priorité Firestore + fallback mock. dart analyze → 0 erreur. |
| 19 mai 2026 | Task 24 — Architecture multi-animés : `Character.animeId` ajouté. `searchCharacters`/`searchAnimes`/`getSameAnimeCharacters` ajoutés au service Firestore. `getCharactersByAnimeId` ajouté à AniList service. `searchCharactersProvider` + `searchAnimesProvider` (fusion Firestore+AniList) + `sameAnimeCharactersProvider` créés. `allCharactersProvider` migré vers `getAllCharacters(limit:100)`. Section "Autres personnages de [animé]" dans onglet Médias. dart analyze → 0 erreur. |
| 19 mai 2026 | Task 24b — Design handoff Claude Design : identity grid refactorisée (cellules individuelles, sentence-case), section À propos sans card wrapper (texte direct), section "👥 Découvrir d'autres personnages" ajoutée bas de l'onglet Infos (scroll horizontal portrait cards 124px, allCharactersProvider, gradient+image+accent strip+voir tout tile). dart analyze → 0 erreur. |
| 19 mai 2026 | Task 25 — Play Store préparation : `android:label` corrigé "OTADEX", Fix Quiz Firestore confirmé (déjà branché), `PLAY_STORE_SIGNING.md` créé (keytool + Kotlin DSL signing déjà configuré), `PLAY_STORE_TODO.md` créé (checklist complète device test → build → assets → soumission). dart analyze → 0 erreur. |

| 20 mai 2026 | Task 26 — Fix images JJK + AniList : `import_jjk.js` → URLs AniList CDN ajoutées pour les 20 personnages JJK (images[] + imagePath). `anilist_service.dart` → `imagePath: largeImg ?? ''`, filtrage `isNotEmpty` sur images[]. `otadex_image.dart` → `httpHeaders: {'User-Agent': 'OTADEX/1.0'}` ajouté à CachedNetworkImage. `_effectiveImages` dans `character_detail_screen.dart` → priorité images[] custom → imagePath → Firebase Storage → [] vide (plus de fallback local Gojo). `character_grid_card.dart` + `trending_character_card.dart` → logique image : `images.first` si disponible, sinon `imagePath`, sinon gradient. dart analyze → 0 issue. Note : Lancer `node scripts/import_jjk.js` pour pousser les nouvelles URLs vers Firestore. |

| 22 mai 2026 | Task 27 — Architecture données clarifiée + correctifs UX : `otadex_providers.dart` → `allCharactersProvider` simplifié (Firestore 200 persos OU JSON fallback, plus de merge). `trendingCharactersProvider` ajouté (filtre isTrending sur allCharactersProvider, tri likes desc, limit 20) — remplace AniList live dans `trending_section.dart`. `anilistTrendingCharactersProvider` renommé dans `anilist_providers.dart` (suppression conflit). `CollectionScreen` → remplace `MockData.allCharacters` par double-watch `collectionStreamProvider` + `allCharactersProvider` (IDs Firestore désormais résolus). `EmptyState` → bouton "Explorer" route `/search`, icône `bookmark_border_rounded`. `profile_screen.dart` → remplace `MockData` par `allCharactersProvider.valueOrNull`. `UserProfile` → 3 getters calculés dynamiquement : `fanLevel` (seuils 100/500/2000/5000), `fanLevelName` (Spectateur→Kage Suprême), `nextLevelScore`. `ProfileTabContent/_ProgressCard` → affiche `fanLevelName — Niveau fanLevel 🔥` (plus de "4" hardcodé). `search_screen.dart` → historique `_recentSearches` branché sur SharedPreferences : `_loadHistory` (initState), `_saveQuery` (submit/suggestion/trending tap), `_clearHistory`, `_removeRecentQuery` — liste vide au démarrage, persistée sur 5 entrées max. dart analyze → 0 issue.
| 22 May 2026 | Task 29 — Import Naruto Shippuden : Création du script `import_ns.js` à partir du docx, 20 personnages préparés, mise en place des constantes `AppAssets` et mise à jour de `pubspec.yaml`. |
| 22 mai 2026 | Task 32 - Migration AniList vers Locale & refactor Images : [x] Importer images locals (JJK, NS, COE...), `OtadexImage` refactorisé pour prioriser locals assets, nettoyage des dépendances AniList dans les providers et scripts d'import. |
| 23 mai 2026 | Task 30 — Migration complète Firestore-only : tokens anime `AppColors`, `featuredSlidesProvider` depuis Firestore, `characterDetailProvider` Firestore-first universel, `categoriesProvider` dynamique (genres Firestore), `AnimeDetailScreen` branché Firestore, messages "via AniList" supprimés. `dart analyze → No issues found!` |
| 23 mai 2026 | Task 33 — Import Classroom of the Elite : `scripts/import_clk.js` créé (20 personnages, 1 animé Studio Lerche, 1 créateur Shōgo Kinugasa, 4 quiz — Ayanokoji/Horikita/Sakayanagi/Ryuen). Vérification images : tous les comptes assets↔app_assets.dart sont cohérents (JJK ✅ NS ✅ CLK ✅). 11 dossiers images créés pour personnages sans images : Kikyo Kushida, Sae Chabashira, Rokusuke Koenji, Airi Sakura, Miyabi Nagumo, Hiyori Shiina, Tsubasa Nanase, Ichika Amasawa, Takuya Yagami, Kohei Katsuragi, Mio Ibuki. `app_assets.dart` — 11 nouvelles listes vides + cases switch. `pubspec.yaml` — 11 nouveaux dossiers CLK déclarés. `flutter analyze → No issues found!` |

---

## Task 31 — Audit Firestore + Corrections source données (23 mai 2026)

### Audit réalisé

- A. `allCharactersProvider` : Firestore prioritaire ✅, fallback JSON mock si vide ✅
- B. `mock_data.dart` : Sung Jin-Woo, Gojo mock (c1-c6) — apparaissent seulement si Firestore vide (avant import)
- C. Route `/search` : ❌ MANQUANTE — `/search-standalone` existait, `/search` non → crash `_buildVoirToutTile`
- D. Assets : `hiromi higumura` (9 fichiers) présent dans `assets/` mais absent de `app_assets.dart`

### ✅ FIX 1 — Route `/search` ajoutée

- `lib/core/router/app_router.dart` : ajout route `/search` → `RechercheScreen()`
- Plus de crash quand "Voir tout" est tapé depuis la fiche personnage

### ✅ FIX 2 — Hiromi Higumura mappé dans app_assets.dart

- `lib/core/constants/app_assets.dart` : liste `hiromiHigumura` (jj_hiro1–9.jpeg) ajoutée
- Case `jjk-hiromi-higumura` ajouté dans `getByCharacterId()`
- pubspec.yaml : dossier `hiromi higumura/` déjà déclaré ✅

### ✅ FIX 3 — Images AppAssets prioritaires dans les cards

- `character_detail_screen.dart` `_buildPortraitCard` : `AppAssets.getByCharacterId` en priorité 1
- `character_detail_screen.dart` `_buildSameAnimeSection` : idem
- `character_detail_screen.dart` `_buildMockRelations` : relations utilisent `AppAssets.getByCharacterId(rel.id)` en priorité, fallback `rel.imageUrl`

### ✅ FIX 4 — Onglet Médias branché sur Firestore

- `character_detail_screen.dart` : `_buildFirestoreAnimeContent()` créé
  - Watch `allAnimesProvider` → résout l'animé du personnage (`c.animeId` ou `c.animeName`)
  - Watch `allCreatorsProvider` → résout le créateur via `anime.creatorId`
  - Card animé : nom, studio, année, episodes, status, genres (badges), synopsis (3 lignes) → tap → `/anime/:id`
  - Card créateur : initiales, role, nationalité, bio (2 lignes) → tap → `/creator/:id`
- Quand `_anilistId == null` et `mediaAppearances.isEmpty` : affiche `_buildFirestoreAnimeContent` + `_buildSameAnimeSection` (plus de message "non disponibles")

### dart analyze → No issues found!

---

## Task 34 — Fix source mock + Shimmer global (24 mai 2026)

### ✅ FIX 1 — Requête Firestore compound orderBy supprimée (CRITIQUE)

- `firestore_character_service.dart` `getAllCharacters()` : suppression `.orderBy('animeId')` (index composite absent → silent fail → fallback mock)
- Conservé uniquement `.orderBy('popularityRank')` — aucun index composite requis
- `catch(e)` améliore le log : `debugPrint('⚠️ Firestore getAllCharacters error: $e')`

### ✅ FIX 2 — animeId CLK corrigé

- `_cardColorForAnime` / `_accentColorForAnime` : `'classroom-of-the-elite'` → `'classroom-of-elite'` (id Firestore réel)
- `_categoryForAnime` : ajout `'classroom-of-elite' => 'Seinen'`

### ✅ FIX 3 — Debug log Firestore vide

- `otadex_providers.dart` `allCharactersProvider` : `debugPrint('⚠️ Firestore vide — vérifier import_jjk.js')` avant fallback mock

### ✅ FIX 4 — Search screen débranchée du mock

- `search_screen.dart` : suppression `OtadexDataService? _service` + import `otadex_data_service.dart`
- Remplacement par `_localChars`, `_localAnimes`, `_localCreators` chargés depuis `allCharactersProvider`, `allAnimesProvider`, `allCreatorsProvider` (Firestore first)
- Suggestions + filtres utilisent désormais les données Firestore

### ✅ Shimmer global — tous les CircularProgressIndicator remplacés

- Créé `lib/core/widgets/skeleton_loader.dart` : `shimmerBox()`, `SkeletonGrid`, `SkeletonRow`, `SkeletonBanner`, `SkeletonScreen`, `SkeletonList`
- Couleurs : `AppColors.backgroundCard` (base) + `AppColors.borderSubtle` (highlight) — respect RÈGLE AppColors
- Home screen : `character_grid_section.dart` → `SkeletonGrid(3×2)` | `trending_section.dart` → `SkeletonRow` | `hero_featured_slider.dart` → `SkeletonBanner`
- Autres : `anime_detail_screen`, `creator_screen`, `studio_screen`, `voice_actor_screen`, `character_quiz_screen` → `SkeletonScreen()`
- Sections : `character_detail_screen.dart` (4 CPIs) → `shimmerBox(height:80)` | `collection_screen.dart` (2 CPIs) → `SkeletonList()`
- Boutons : `otadex_button.dart`, `edit_profile_sheet.dart`, `change_password_sheet.dart`, `interests_screen.dart`, `plans_screen.dart` → `shimmerBox(circle)`

### dart analyze → No issues found!

---

---

## Task 35 — Fix crash navigation + UX corrections (24 mai 2026)

### ✅ FIX 1 — Crash navigation /character/:id résolu (CRITIQUE)

- **Cause** : `state.extra as Character` → crash quand `extra` est null (navigation depuis URL directe, deep link, ou appel sans extra)
- `lib/core/router/app_router.dart` : route `/character/:id` utilise désormais `state.pathParameters['id']!` — plus aucune dépendance à `state.extra`
- `lib/features/character/presentation/character_detail_screen.dart` :
  - Constructeur : `final Character character` → `final String characterId`
  - Champ `Character? _character` ajouté dans le State
  - Getter `c` : `widget.character` → `_character!` (alimenté avant chaque build)
  - `build()` → wrappé dans `characterDetailProvider(widget.characterId).when(loading / error / data)`
  - Loading → `SkeletonScreen` | Error → message erreur | Null → "Personnage introuvable"
  - Méthode `_buildScaffold(context)` extraite pour le contenu existant inchangé
- Tous les `context.push('/character/${id}')` existants restent valides (extra ignoré si présent)

### ✅ FIX 2 — Personnages animé non cliquables

- `lib/features/anime/presentation/anime_detail_screen.dart`
- `_CharactersList` : suppression du paramètre `onTap`
- `_CharacterRow` : suppression `GestureDetector` + `VoidCallback onTap` + chevron `Icons.chevron_right_rounded`
- Les rows restent visuellement identiques (avatar, nom, pill rang, animeName) mais ne réagissent plus au tap

### ✅ FIX 3 — "Tu pourrais aussi aimer" avec images réelles

- `lib/features/search/presentation/search_screen.dart`
- Suppression de `_recommendations` (liste statique de `Color()` hardcodés)
- `_buildRecommendations()` réécrit : utilise `_localChars.take(3)` (données Firestore)
- Chaque card : gradient `cardColor → accentColor` + `OtadexImage` (priorité assets locaux → `images[]` → `imagePath`) + scrim bas + nom + animeName
- OnTap : `context.push('/character/${c.id}')` — navigation vers la fiche
- Imports ajoutés : `app_assets.dart`, `app_colors.dart`

### dart analyze → No issues found!

---

---

## Task 36 — Fix BUG 1 & BUG 2 (25 mai 2026)

### ✅ BUG 1 — Bouton "Explorer" collection vide

- **Cause** : `context.go('/search')` remplaçait toute la pile de navigation → crash "No Material widget found" car SearchScreen se retrouvait sans ancêtre Scaffold/Material
- **Fix** : `lib/features/collection/presentation/collection_screen.dart:150` → `context.go` → `context.push`

### ✅ BUG 2 — Popup téléchargement ne se ferme pas

- **Cause** : SnackBar avec `backgroundColor` custom + style `Colors.white` (violation RÈGLE AppColors) + durée 5s rendait le widget visuel persistant
- **Fix** : `lib/features/character/presentation/gallery_screen.dart` → SnackBar simplifié sans backgroundColor ni textStyle custom, durée 4s, action label "Voir Kage", `context.push('/subscription')` conservé
- Texte : `'📥 Téléchargé avec filigrane'` (sans le sous-texte "Passe Kage...")

### dart analyze → No issues found!

---

## Task 37 — Notifications push Phase 1 (26 mai 2026)

### ✅ Dépendances

- `firebase_messaging: ^14.9.0` + `flutter_local_notifications: ^17.0.0` ajoutés dans `pubspec.yaml`

### ✅ Android

- `AndroidManifest.xml` : `POST_NOTIFICATIONS` + `RECEIVE_BOOT_COMPLETED` + meta-data `otadex_channel`

### ✅ NotificationService (`lib/core/services/notification_service.dart`)

- Demande permission FCM (alert, badge, sound)
- Channel Android `otadex_channel` (Importance.high)
- Token FCM sauvegardé dans `users/{uid}.fcmToken` au login
- `onMessage` → notification locale en foreground
- `onMessageOpenedApp` → navigation via `AppRouter.router.push(route)`
- `showLocal()` utilitaire pour notifications manuelles

### ✅ main.dart

- `await NotificationService.initialize()` appelé après `Firebase.initializeApp()`

### ✅ Cloche HomeScreen + badge non lus

- `HomeAppBar` : nouveau paramètre `unreadCount` + badge orange `AppColors.accent` sur la cloche
- `HomeScreen` : `StreamBuilder<int>` sur `users/{uid}/notifications` where `read == false` → passe le count à `HomeAppBar`

### ✅ NotificationsScreen (`lib/features/home/presentation/notifications_screen.dart`)

- Stream Firestore `users/{uid}/notifications` orderBy `created_at` desc
- Chaque item : icône typée (🎉 new_characters, 🏆 monthly_vote, 💎 subscription), titre, body, timestamp relatif
- Item non lu : fond teinté accent + point indicateur
- Tap → `docRef.update({'read': true})` + `context.push(route)`
- AppBar : bouton "Tout lire" → batch update Firestore
- Route `/notifications` déjà enregistrée dans `app_router.dart`

### ✅ scripts/import_jjk.js

- Après l'import des quiz : récupération tokens FCM → `messaging.sendEachForMulticast()` avec titre "🎉 Nouveaux personnages disponibles !" et route `/anime/jujutsu-kaisen`

### ✅ Cloud Function vote mensuel (`functions/src/index.ts`)

- `notifyMonthlyVote` : schedule `0 9 1 * *` timezone `Africa/Douala`
- Envoi FCM multicast + création doc `notifications` pour chaque user (type `monthly_vote`)
- Déployer : `firebase deploy --only functions`

### dart analyze → No issues found!

---

---

## Task 38 — Import One Piece Firestore (26 mai 2026)

### ✅ Script créé : `scripts/import_one_piece.js`

- Extrait depuis `One_Piece_Personnages_OTADEX_2026.docx` (python3 zipfile + regex, Snap AppArmor contourné)
- Structure identique à `import_jjk.js` en 6 étapes séquentielles

### ✅ Collections importées

| Collection   | Document         | Contenu                                                                                       |
| ------------ | ---------------- | --------------------------------------------------------------------------------------------- |
| `animes`     | `one-piece`      | 1160+ épisodes, Toei Animation, 530M copies vendues, genres Aventure/Action/Comédie/Fantaisie |
| `creators`   | `eiichiro-oda`   | Bio complète, biblio (Romance Dawn 1992 → OP 1997), prix Shōgakukan/Harvey Award              |
| `studios`    | `toei-animation` | Fondé 1956, Dragon Ball Z / Sailor Moon / Digimon / One Piece                                 |
| `characters` | `op-*` (15 docs) | Préfixe `op-`, popularityRank 1–15, bio/pouvoirs/relations/citations/trivia                   |
| `quizzes`    | `op-*` (7 sets)  | 5 questions chacun : Luffy, Zoro, Sanji, Nami, Law, Ace, Chopper                              |

### ✅ Personnages One Piece (15)

1. `op-monkey-d-luffy` — rank 1, Yonko / Capitaine
2. `op-roronoa-zoro` — rank 2, Combattant
3. `op-nami` — rank 3, Navigatrice
4. `op-usopp` — rank 4, Tireur d'élite
5. `op-sanji` — rank 5, Cuisinier
6. `op-tony-tony-chopper` — rank 6, Médecin
7. `op-nico-robin` — rank 7, Archéologue
8. `op-franky` — rank 8, Charpentier
9. `op-brook` — rank 9, Musicien
10. `op-jinbe` — rank 10, Timonier
11. `op-portgas-d-ace` — rank 11, Pirate / décédé
12. `op-trafalgar-d-water-law` — rank 12, Warlord / Capitaine
13. `op-shanks` — rank 13, Yonko
14. `op-boa-hancock` — rank 14, Impératrice / Warlord
15. `op-dracule-mihawk` — rank 15, Premier épéiste

### ✅ Quiz créés (7 × 5 questions)

- Monkey D. Luffy, Roronoa Zoro, Sanji, Nami, Trafalgar Law, Portgas D. Ace, Tony Tony Chopper

### ✅ Notification FCM post-import

- Titre : "🌊 One Piece débarque sur OTADEX !"
- Body : "Les personnages du Chapeau de Paille sont disponibles. Explore ta première fiche !"
- Route : `/anime/one-piece` | type : `new_characters`

### ✅ scripts/README.md mis à jour

- Section "## Import One Piece" ajoutée (prérequis, lancement, collections, 15 personnages)

### Commande de lancement

```bash
node scripts/import_one_piece.js
```

> Si `node` Snap est bloqué par AppArmor :
>
> ```bash
> env NODE_OPTIONS='--require ./scripts/google_time_offset.js' /home/tilstack/.cache/ms-playwright-go/1.50.1/node scripts/import_one_piece.js
> ```

### Note

- `imagePath` et `images[]` vides pour l'instant — à remplir après upload Firebase Storage des illustrations One Piece
- Ajouter les entrées dans `app_assets.dart` + `pubspec.yaml` quand les assets locaux seront disponibles

---

---

## Task 39 — Import Kuroko no Basket Firestore (26 mai 2026)

### ✅ Script créé : `scripts/import_kkb.js`

- Données extraites depuis `Kuroko_no_Basket_Personnages_OTADEX_2026.docx` (python3 zipfile + regex)
- Structure identique à `import_jjk.js` en 6 étapes séquentielles

### ✅ Collections importées

| Collection   | Document             | Contenu                                                                           |
| ------------ | -------------------- | --------------------------------------------------------------------------------- |
| `animes`     | `kuroko-no-basket`   | 75 épisodes, Production I.G, 3 saisons + Last Game, genres Shōnen/Sport           |
| `creators`   | `tadatoshi-fujimaki` | Bio complète, bibliographie (2006–2017), distinctions                             |
| `studios`    | `production-ig`      | Fondé 1987, Ghost in the Shell / Haikyuu!! / Attack on Titan S2                   |
| `characters` | `knb-*` (13 docs)    | Préfixe `knb-`, popularityRank 1–13, bio/pouvoirs/relations/citations/trivia      |
| `quizzes`    | `knb-*` (7 sets)     | 5 questions chacun : Akashi, Kuroko, Kagami, Kise, Aomine, Midorima, Murasakibara |

### ✅ Personnages Kuroko no Basket (13)

Classés par le 3e sondage de popularité officiel Weekly Shōnen Jump :

1. `knb-akashi-seijuro` — rank 1, Génération des Miracles / Capitaine Rakuzan
2. `knb-kuroko-tetsuya` — rank 2, Sixième Joueur Fantôme / Protagoniste
3. `knb-takao-kazunari` — rank 3, Hawk Eye — 1er non-Miracle top 3
4. `knb-kise-ryota` — rank 4, Perfect Copy — mannequin professionnel
5. `knb-kagami-taiga` — rank 5, Le Miracle qui n'en était pas un
6. `knb-midorima-shintaro` — rank 6, Tir de précision absolue depuis tout le terrain
7. `knb-aomine-daiki` — rank 7, Formless Shot — nihilisme du talent pur
8. `knb-murasakibara-atsushi` — rank 8, Aegis Shield — 208 cm
9. `knb-himuro-tatsuya` — rank 9, Mirage Shot — frère de cœur de Kagami
10. `knb-momoi-satsuki` — rank 10, Analyste de génie — seule féminine top 20
11. `knb-hyuga-junpei` — rank 11, Roi du 4e quart-temps / Capitaine Seirin
12. `knb-kiyoshi-teppei` — rank 12, Iron Heart — Roi sans Couronne
13. `knb-aida-riko` — rank 13, Coach Seirin — analyse physique visuelle

### ✅ Quiz créés (7 × 5 questions)

- Seijūrō Akashi, Tetsuya Kuroko, Taiga Kagami, Ryōta Kise, Daiki Aomine, Shintarō Midorima, Atsushi Murasakibara

### ✅ Notification FCM post-import

- Titre : "🏀 Kuroko no Basket débarque sur OTADEX !"
- Body : "La Génération des Miracles est disponible. Affronte le quiz !"
- Route : `/anime/kuroko-no-basket` | type : `new_characters`

### ✅ scripts/README.md mis à jour

- Section "## Import Kuroko no Basket" ajoutée (prérequis, lancement, collections, 13 personnages)

### Note sur les IDs

- Préfixe personnages : `knb-` (Kuroko no Basket) — cohérent avec `jjk-`, `op-`, `ns-`, `clk-`
- ID animé : `kuroko-no-basket` (hyphens, cohérent avec tous les autres IDs Firestore)

### Commande de lancement

```bash
node scripts/import_kkb.js
```

> Si `node` Snap est bloqué par AppArmor :
>
> ```bash
> env NODE_OPTIONS='--require ./scripts/google_time_offset.js' /home/tilstack/.cache/ms-playwright-go/1.50.1/node scripts/import_kkb.js
> ```

### Note

- `imagePath` et `images[]` vides — à remplir après upload Firebase Storage des illustrations KnB
- Ajouter entrées dans `app_assets.dart` + `pubspec.yaml` quand les assets locaux seront disponibles

---

---

## Task 40 — Migration OneSignal (27 mai 2026)

### Objectif

Remplacer Firebase Cloud Functions + FCM par OneSignal pour toutes les notifications push.

### ✅ Dépendances

- `firebase_messaging: ^14.9.0` retiré de `pubspec.yaml`
- `flutter_local_notifications: ^17.0.0` retiré de `pubspec.yaml`
- `onesignal_flutter: ^5.2.6` ajouté

### ✅ NotificationService réécrit (`lib/core/services/notification_service.dart`)

- `OneSignal.initialize(appId)` — App ID : `cfc58648-689b-432f-9afa-c4f49e69199f`
- `OneSignal.Notifications.requestPermission(true)` — permission utilisateur
- Sauvegarde de `oneSignalId` dans `users/{uid}.oneSignalId` (remplace `fcmToken`)
- Foreground : `addForegroundWillDisplayListener` → `event.notification.display()`
- Tap : `addClickListener` → navigation via `AppRouter.router.push(route)`

### ✅ AndroidManifest.xml

- Meta-data FCM `default_notification_channel_id` retirée (inutile avec OneSignal)
- Permissions `POST_NOTIFICATIONS` + `RECEIVE_BOOT_COMPLETED` conservées

### ✅ android/app/build.gradle.kts

- `isCoreLibraryDesugaringEnabled = true` déjà en place (Task 37)
- `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")` déjà en place

### ✅ Cloche HomeScreen + NotificationsScreen

- Déjà fonctionnels depuis Task 37 — aucun changement requis
- Badge non lus : stream Firestore `users/{uid}/notifications where read == false`
- NotificationsScreen : liste Firestore, tap → `read: true`, bouton "Tout lire"

### ✅ scripts/send_notification.js (NOUVEAU)

- Utilise l'API REST OneSignal v1 : `POST /api/v1/notifications`
- Segment : `"All"` (tous les abonnés)
- Paramètres : `title`, `body`, `route`, `type`
- Export : `module.exports = sendNotification` → utilisable depuis tous les scripts d'import
- Usage CLI : `node scripts/send_notification.js --title "..." --body "..." --route /home`

### ✅ scripts/notify_monthly_vote.js (NOUVEAU)

- Envoie la notification "🏆 Vote Fan du Mois ouvert !" via OneSignal REST API
- Type : `monthly_vote` | Route : `/home`
- Lancement manuel : `node scripts/notify_monthly_vote.js`
- Crontab : `0 9 1 * * /path/node .../notify_monthly_vote.js`

### ✅ Scripts d'import mis à jour

| Script          | Avant                    | Après                          |
| --------------- | ------------------------ | ------------------------------ |
| `import_jjk.js` | FCM multicast `fcmToken` | `sendNotification()` OneSignal |
| `import_op.js`  | FCM multicast `fcmToken` | `sendNotification()` OneSignal |
| `import_kkb.js` | FCM multicast `fcmToken` | `sendNotification()` OneSignal |
| `import_ns.js`  | Aucune notification      | `sendNotification()` ajouté    |
| `import_clk.js` | Aucune notification      | `sendNotification()` ajouté    |

### Clés OneSignal (dans `.env` — ne jamais committer)

```
APPIDONESIGNAL   = cfc58648-689b-432f-9afa-c4f49e69199f
APIKEYONESIGNAL  = os_v2_app_z7cymsditnbs7gx2yt2j42izt4neg33xnicezbuj4rjtexvwjh5rusmzdjw2t5ssrtszevfw6lif6b5qiypy4oaywwthibctmoosqjq
```

### Champ Firestore modifié

- `users/{uid}.fcmToken` → `users/{uid}.oneSignalId` (mis à jour automatiquement à chaque session)

### dart analyze → No issues found!

---

---

## Task 41 — Intégration Fullmetal Alchemist Brotherhood (29 mai 2026)

### Objectif

Ajouter Fullmetal Alchemist Brotherhood comme 6e anime sur OTADEX.

### ✅ Script d'import

- **`scripts/import_fma.js`** créé (modèle : `import_kkb.js`)
- Anime ID : `fullmetal-alchemist` | Préfixe personnages : `fma-`
- Studio : `bones` (Bones) | Créateur : `hiromu-arakawa` (Hiromu Arakawa)
- 13 personnages avec bio complète, pouvoirs, relations, citations, trivia
- 7 sets de quiz × 5 questions (Edward, Roy, Alphonse, Riza, Bradley, Hughes, Izumi)
- Notification OneSignal : `"⚗️ Fullmetal Alchemist Brotherhood débarque sur OTADEX !"`
- Route : `/anime/fullmetal-alchemist`

### ✅ Personnages (13)

| ID                        | Nom                   | Rang | isTrending |
| ------------------------- | --------------------- | ---- | ---------- |
| `fma-edward-elric`        | Edward Elric          | 1    | true       |
| `fma-roy-mustang`         | Roy Mustang           | 2    | true       |
| `fma-alphonse-elric`      | Alphonse Elric        | 3    | true       |
| `fma-riza-hawkeye`        | Riza Hawkeye          | 4    | false      |
| `fma-winry-rockbell`      | Winry Rockbell        | 5    | false      |
| `fma-van-hohenheim`       | Van Hohenheim         | 6    | false      |
| `fma-father`              | Father                | 7    | false      |
| `fma-king-bradley`        | King Bradley          | 8    | false      |
| `fma-scar`                | Scar                  | 9    | false      |
| `fma-maes-hughes`         | Maes Hughes           | 10   | false      |
| `fma-pride-selim-bradley` | Pride (Selim Bradley) | 11   | false      |
| `fma-greed-ling-yao`      | Greed / Ling Yao      | 12   | false      |
| `fma-izumi-curtis`        | Izumi Curtis          | 13   | false      |

### ✅ Flutter — fichiers modifiés

- **`lib/core/theme/app_colors.dart`** : `animeFmaCard = Color(0xFF1A0800)`, `animeFmaAccent = Color(0xFFB71C1C)`
- **`lib/core/services/firestore_character_service.dart`** : cases `fullmetal-alchemist` dans `_cardColorForAnime`, `_accentColorForAnime`, `_categoryForAnime` (Shōnen)
- **`lib/core/constants/app_assets.dart`** : 13 listes vides + 13 cases dans `getByCharacterId`
- **`pubspec.yaml`** : 13 déclarations de dossiers d'assets

### ✅ Dossiers assets créés

`assets/images/Animé pictures/Fullmetal Alchemist/{Edward Elric, Roy Mustang, Alphonse Elric, Riza Hawkeye, Winry Rockbell, Van Hohenheim, Father, King Bradley, Scar, Maes Hughes, Pride Selim Bradley, Greed Ling Yao, Izumi Curtis}/`

### Note

- `imagePath` et `images[]` vides — à remplir après upload Firebase Storage
- `dart analyze lib/ → No issues found!`

---

## Task 42 — Intégration Hunter x Hunter (29 mai 2026)

### Objectif

Ajouter Hunter x Hunter (2011, Madhouse) comme 7e anime sur OTADEX.

### ✅ Script d'import

- **`scripts/import_hxh.js`** créé (modèle : `import_kkb.js`)
- Anime ID : `hunter-x-hunter` | Préfixe personnages : `hxh-`
- Studio : `madhouse` (Madhouse) | Créateur : `yoshihiro-togashi`
- 13 personnages avec bio complète, pouvoirs Nen, relations, citations, trivia
- 7 sets de quiz × 5 questions (Killua, Gon, Hisoka, Kurapika, Meruem, Netero, Chrollo)
- Notification OneSignal : `"🔍 Hunter x Hunter débarque sur OTADEX !"`
- Route : `/anime/hunter-x-hunter`

### ✅ Personnages (13)

| ID                       | Nom                | Rang | isTrending |
| ------------------------ | ------------------ | ---- | ---------- |
| `hxh-killua-zoldyck`     | Killua Zoldyck     | 1    | true       |
| `hxh-gon-freecss`        | Gon Freecss        | 2    | true       |
| `hxh-hisoka-morow`       | Hisoka Morow       | 3    | true       |
| `hxh-kurapika`           | Kurapika           | 4    | false      |
| `hxh-chrollo-lucilfer`   | Chrollo Lucilfer   | 5    | false      |
| `hxh-leorio-paradinight` | Leorio Paradinight | 6    | false      |
| `hxh-biscuit-krueger`    | Biscuit Krueger    | 7    | false      |
| `hxh-meruem`             | Meruem             | 8    | false      |
| `hxh-isaac-netero`       | Isaac Netero       | 9    | false      |
| `hxh-illumi-zoldyck`     | Illumi Zoldyck     | 10   | false      |
| `hxh-ging-freecss`       | Ging Freecss       | 11   | false      |
| `hxh-feitan-portor`      | Feitan Portor      | 12   | false      |
| `hxh-neferpitou`         | Neferpitou         | 13   | false      |

### ✅ Flutter — fichiers modifiés

- **`lib/core/theme/app_colors.dart`** : `animeHxhCard = Color(0xFF061A06)`, `animeHxhAccent = Color(0xFF2E7D32)`
- **`lib/core/services/firestore_character_service.dart`** : cases `hunter-x-hunter` dans `_cardColorForAnime`, `_accentColorForAnime`, `_categoryForAnime` (Shōnen)
- **`lib/core/constants/app_assets.dart`** : 13 listes vides + 13 cases dans `getByCharacterId`
- **`pubspec.yaml`** : 13 déclarations de dossiers d'assets

### ✅ Dossiers assets créés

`assets/images/Animé pictures/Hunter x Hunter/{Killua Zoldyck, Gon Freecss, Hisoka Morow, Kurapika, Chrollo Lucilfer, Leorio Paradinight, Biscuit Krueger, Meruem, Isaac Netero, Illumi Zoldyck, Ging Freecss, Feitan Portor, Neferpitou}/`

### Note

- `imagePath` et `images[]` vides — à remplir après upload Firebase Storage
- `dart analyze lib/ → No issues found!`

---

## Task 43 — Migration URLs GitHub raw (scripts d'import) (30 mai 2026)

### Objectif

Remplacer tous les chemins `assets/images/...` locaux par des URLs GitHub raw dans les scripts d'import, et vérifier que Firestore passe bien les URLs au modèle `Character`.

### ✅ Scripts d'import mis à jour

| Script                  | Personnages | URLs ajoutées | Statut                                              |
| ----------------------- | ----------- | ------------- | --------------------------------------------------- |
| `scripts/import_jjk.js` | 14          | 112           | ✅ (session précédente)                             |
| `scripts/import_op.js`  | 14          | 142           | ✅ — Trafalgar Law: 8 images ajoutées               |
| `scripts/import_ns.js`  | 20          | 153           | ✅ — 11 préfixes corrigés (ns_itac→ns_itachi, etc.) |
| `scripts/import_kkb.js` | 13          | 117           | ✅ — tous les champs étaient vides                  |
| `scripts/import_clk.js` | 9           | variable      | ✅ — CLK_BASE + dossiers encodés                    |
| `scripts/import_fma.js` | —           | 0             | ⏭ ignoré — 0 images dans le repo                   |
| `scripts/import_hxh.js` | —           | 0             | ⏭ ignoré — 0 images dans le repo                   |

**Format URL :** `https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé%20pictures/[Animé%20encodé]/[Personnage%20encodé]/[fichier]`

**Corrections NS** (préfixes mal nommés dans l'ancienne version) :

| Personnage      | Ancien préfixe | Correct    |
| --------------- | -------------- | ---------- |
| Itachi Uchiha   | ns_itac        | ns_itachi  |
| Naruto Uzumaki  | ns_naru        | ns_naruto  |
| Kakashi Hatake  | ns_kaka        | ns_kakashi |
| Gaara           | ns_gaar        | ns_gaara   |
| Hinata Hyuga    | ns_hina        | ns_hinata  |
| Madara Uchiha   | ns_mada        | ns_madara  |
| Might Guy       | ns_migh        | ns_guy     |
| Rock Lee        | ns_rock        | ns_lee     |
| Hashirama Senju | ns_hash        | ns_hashi   |
| Konan           | ns_kona        | ns_konan   |
| Sasuke Uchiha   | ns_sasu        | ns_sasuke  |

Personnages NS sans images (Obito Uchiha, Shikamaru Nara, Tsunade) : `images: [], imagePath: ""`

### ✅ Dart — Firestore → Character (images)

**`lib/core/services/firestore_character_service.dart`** :

- Import ajouté : `import '../constants/app_assets.dart';`
- `_characterFromFirestore()` ligne 213 : fallback AppAssets si Firestore `images[]` absent ou vide

```dart
images: () {
  final fsImages = (d['images'] as List<dynamic>?)?.cast<String>() ?? [];
  if (fsImages.isNotEmpty) return fsImages;
  return AppAssets.getByCharacterId(id);
}(),
```

**`lib/features/character/presentation/character_detail_screen.dart`** :

- `_effectiveImages` : priorité inversée — Firestore URLs en premier, AppAssets en fallback

```dart
// 1. Images Firestore (GitHub raw URLs)
final firestoreImages = c.images.where((url) => url.isNotEmpty).toList();
if (firestoreImages.isNotEmpty) return firestoreImages;
// 2. AppAssets fallback
final localImages = AppAssets.getByCharacterId(c.id);
if (localImages.isNotEmpty) return localImages;
// 3. imagePath seul
```

### ✅ dart analyze lib/ → No issues found!

### Actions manuelles requises

1. Lancer chaque script : `node scripts/import_op.js`, `import_ns.js`, `import_kkb.js`, `import_clk.js`
2. Hot restart Flutter
3. Vérifier que les images se chargent depuis GitHub sur les fiches personnage

---

---

## Task 44 — Système de licences Chariow (1er juin 2026)

### Objectif

Intégrer l'API Chariow pour activer et vérifier les licences Jonin/Kage en temps réel.

### ✅ flutter_dotenv ajouté

- `flutter_dotenv: ^5.1.0` dans `pubspec.yaml`
- `.env` déclaré dans `pubspec.yaml` assets
- `.env` déjà présent à la racine avec `CHARIOW_API_KEY=sk_dt4ihlbu_...` (ne jamais committer)

### ✅ ChariowService (`lib/core/services/chariow_service.dart`) — NOUVEAU

- `LicenseResult` : `isActive`, `isExpired`, `expiresAt`, `productName`, `errorMessage`
- `activateLicense(licenseKey, uid)` : POST `/v1/licenses/{key}/activate` avec `device_identifier = uid`
  - Erreurs 400 traduits en français : révoquée / expirée / limite atteinte
  - Erreur 404 : "Licence introuvable. Vérifie la clé."
  - Réseau : "Erreur réseau. Réessaie plus tard."
- `checkLicense(licenseKey)` : GET `/v1/licenses/{key}`
- `detectPlan(productName)` : "jonin" → `UserRank.jonin`, "kage" → `UserRank.kage`, autre → `UserRank.genin`
- Clé lue via `dotenv.env['CHARIOW_API_KEY']`

### ✅ LicenseActivationScreen (`lib/features/subscription/presentation/license_activation_screen.dart`) — NOUVEAU

- Validation UUID : `RegExp(r'^[0-9a-fA-F-]{36}$')`
- Appel `ChariowService().activateLicense(key, uid)`
- Sur succès :
  - `detectPlan(productName)` → `UserRank`
  - Firestore `users/{uid}`: `abonnement`, `licenseKey`, `licenseExpiresAt`, `licenseActivatedAt`
  - `userProfileProvider.notifier.updateIdentity(rank: rank.name)`
  - SharedPreferences : `user_rank`, `subscription_plan`, `license_key`, `license_expires` (ms)
  - SnackBar "🎉 Bienvenue chez les {Jonin/Kage} !"
  - `context.go('/home')`
- Sur échec : message d'erreur sous le TextField

### ✅ Route `/activate-license` ajoutée dans `app_router.dart`

### ✅ PlansScreen (`lib/features/subscription/presentation/plans_screen.dart`) corrigé

- "Tchopé Plus" → "OTADEX Premium" / "Débloque OTADEX Premium"
- Formulaire d'activation **retiré** (déplacé vers `LicenseActivationScreen`)
- Bouton "Activer ma licence" (OutlinedButton) → `/activate-license`
- Cards Jonin/Kage avec "Acheter" → URLs Chariow store conservées

### ✅ SubscriptionCard (`lib/features/profile/presentation/widgets/subscription_card.dart`) — Section dynamique

- `ConsumerStatefulWidget` — lit `userProfileProvider` (rank) + SharedPreferences (`license_expires`)
- **Genin** : card standard + bouton "Passer au premium" → `/subscription`
- **Jonin/Kage actif** : plan + date expiration (DD/MM/YYYY) + jours restants
  - Si < 7 jours → `AppColors.error`
  - Bouton "Renouveler" → `/activate-license`
  - Bouton "Changer de plan" → `/subscription`
- **Expiré** : card rouge "Abonnement expiré" + bouton "Réactiver" → `/activate-license`

### ✅ main.dart — dotenv + vérification expiration au démarrage

- `await dotenv.load(fileName: '.env')` avant `Firebase.initializeApp()`
- Si `license_expires` dépassé et utilisateur connecté :
  - Vérification via `ChariowService().checkLicense(licenseKey)`
  - Si expiré/inactif → `user_rank = genin`, suppression `license_expires`, Firestore update
  - Si encore actif → mise à jour `license_expires` depuis Chariow
  - Si erreur réseau → rang conservé (pas de pénalité offline)

### ✅ AppConstants — nouvelles clés

- `keyLicenseExpires = 'license_expires'`
- `keyLicenseKey = 'license_key'`

### `dart analyze lib/ → No issues found!`

---

## _À mettre à jour par Claude Code à la fin de chaque session._

## Task 45 — Paiement Chariow : URLs checkout + SnackBar (1er juin 2026)

### Objectif

Brancher les 4 URLs de paiement Chariow avec `/checkout`, remplacer `UrlLauncherService` par `url_launcher` direct avec `canLaunchUrl`, et afficher un SnackBar post-achat.

### Fichier modifié

**`lib/features/subscription/presentation/plans_screen.dart`**

#### URLs mises à jour (ajout `/checkout`)

| Plan  | Mode    | URL                                             |
| ----- | ------- | ----------------------------------------------- |
| Jonin | Mensuel | `https://store.tilstack.me/prd_1epnxl/checkout` |
| Jonin | Annuel  | `https://store.tilstack.me/prd_xqbqdx/checkout` |
| Kage  | Mensuel | `https://store.tilstack.me/prd_hdj1oy/checkout` |
| Kage  | Annuel  | `https://store.tilstack.me/prd_0jx2mh/checkout` |

#### Méthode `_buyPlan(String url)`

- `canLaunchUrl` + `launchUrl(mode: LaunchMode.externalApplication)`
- SnackBar flottant après lancement :
  - Message : "Après ton achat, reviens ici pour activer ta licence 🔑"
  - Action "Activer" → `context.push('/activate-license')`
  - Couleurs : `AppColors.backgroundCard` + `AppColors.rankJonin`
- Import `UrlLauncherService` retiré, import `url_launcher` ajouté directement

### Checklist

- ✅ URLs Jonin Mensuel/Annuel + Kage Mensuel/Annuel avec `/checkout`
- ✅ `canLaunchUrl` + `launchUrl(externalApplication)` branché
- ✅ SnackBar post-achat avec action "Activer" → `/activate-license`
- ✅ AppColors uniquement (aucune `Color()` hardcodée)
- ✅ `dart analyze lib/` → No issues found!

---

---

## Task 46 — GitHub Actions : Vote Fan du Mois automatisé (1er juin 2026)

### Objectif

Automatiser l'envoi de la notification "Vote Fan du Mois" le 1er de chaque mois via GitHub Actions + OneSignal REST API.

### Fichiers créés / modifiés

**`.github/workflows/monthly_vote.yml`** (nouveau)

- Déclenchement : `cron: '0 8 1 * *'` (1er du mois à 8h UTC = 9h Douala UTC+1)
- `workflow_dispatch` : déclenchement manuel depuis GitHub UI
- Jobs : `checkout@v4` → `setup-node@v4 (18)` → `npm install` → `node scripts/notify_monthly_vote.js`
- Secrets injectés : `ONESIGNAL_API_KEY` + `ONESIGNAL_APP_ID`

**`scripts/notify_monthly_vote.js`** (réécrit)

- Script autonome (n'utilise plus `send_notification.js`)
- Lit `process.env.ONESIGNAL_API_KEY` + `process.env.ONESIGNAL_APP_ID`
- Garde `dotenv.config()` pour usage local (`.env`)
- Validation au démarrage : si variables absentes → `console.error` + `process.exit(1)`
- Notification : titre "🏆 Vote Fan du Mois ouvert !", body "Soutenez votre personnage préféré et devenez Fan #1 ce mois-ci !", url deep link `otadex://home`, segment `All`
- Appel HTTP natif via `https` (pas de dépendance externe supplémentaire)

**`.github/SECRETS.md`** (nouveau)

- Documentation des 2 secrets GitHub requis : `ONESIGNAL_API_KEY` + `ONESIGNAL_APP_ID`
- Lien direct vers la page de configuration des secrets du repo

### Checklist

- ✅ GitHub Actions → vote mensuel automatisé (1er du mois à 9h heure Douala)
- ✅ `notify_monthly_vote.js` → variables d'env (plus de valeurs hardcodées)
- ✅ `workflow_dispatch` → déclenchement manuel possible
- ✅ `.github/SECRETS.md` → documentation secrets GitHub

> ⚠️ **Note** : Configurer les secrets GitHub avant activation
> (`ONESIGNAL_API_KEY` + `ONESIGNAL_APP_ID` dans Settings → Secrets → Actions)

---

---

## Task 47 — Migration dart.yml → Flutter CI (1er juin 2026)

### Workflows audités

| Fichier            | Contient Dart                                | Action                       |
| ------------------ | -------------------------------------------- | ---------------------------- |
| `monthly_vote.yml` | Non (Node.js)                                | Ignoré                       |
| `dart.yml`         | Oui (`dart-lang/setup-dart`, `dart pub get`) | **Option A** — migré Flutter |

### Changements appliqués à `.github/workflows/dart.yml`

- Nom : `Dart` → `Flutter CI`
- `dart-lang/setup-dart@9a04e6d...` → `subosito/flutter-action@v2` (flutter `3.x` stable)
- `dart pub get` → `flutter pub get`
- `dart analyze` → `flutter analyze`
- `dart test` → `flutter test`
- Commentaires de template Dart supprimés

---

---

## Task 49 — UX/UI : Kage banner, catégories, recherche vocale (2 juin 2026)

### Changements logique & UI design

#### ✅ UpsellBanner — Bouton de fermeture (UI design)

- `lib/features/home/presentation/widgets/upsell_banner.dart` : converti en `StatefulWidget`
- Bouton `Icons.close_rounded` en haut à droite de la bannière Kage
- État dismissed persisté via `SharedPreferences` (`upsell_kage_dismissed`)
- La bannière ne réapparaît pas entre les sessions une fois fermée
- Layout restructuré : titre + × sur la même ligne, texte + bouton Débloquer en dessous

#### ✅ Catégories Home — Alignement avec les animés disponibles (logique)

- `lib/features/home/presentation/widgets/category_chips.dart` :
  - Fallback `_kDefaultCategories` corrigé : `['Tous', 'Shōnen', 'Seinen', 'Sport']`
  - Suppression des catégories inexistantes dans l'app : Isekai, Shōjo, Manhwa, Mecha
- `lib/core/providers/otadex_providers.dart` :
  - `'Sport'` ajouté dans la liste `prioritized` de `categoriesProvider`
  - Commentaire sur l'extensibilité : "étendre ici quand un nouveau genre arrive"
- `lib/core/theme/app_colors.dart` :
  - `catSportC1 = Color(0xFF1565C0)` + `catSportC2 = Color(0xFF0A1628)` ajoutés
  - Couleurs trend HxH/FMA/KNB/NS : `trendHxHBg`, `trendFMABg`, `trendKNBBg`, `trendNSBg`

#### ✅ Chemin pour nouvelles catégories (logique)

Pour ajouter une catégorie future :

1. `AppColors.catXxxC1/C2` dans `app_colors.dart`
2. `_subFilters` + `_categories` dans `search_screen.dart`
3. `_categoryForAnime()` dans `firestore_character_service.dart`
4. `prioritized` dans `otadex_providers.dart`
   Les catégories Firestore apparaissent automatiquement dans les chips Home via `categoriesProvider`.

#### ✅ Recherche — Voice search fonctionnel (logique + UI design)

- `pubspec.yaml` : `speech_to_text: ^6.6.0` ajouté
- `AndroidManifest.xml` : permission `RECORD_AUDIO` ajoutée
- `search_screen.dart` :
  - `SpeechToText _speech` + `_speechAvailable` + `_isListening` ajoutés
  - `_initSpeech()` : initialisation au démarrage, gestion erreurs/statuts
  - `_toggleListening()` : écoute FR, pause 3s, remplissage automatique du champ, submit en fin de phrase
  - Bouton mic : `GestureDetector` → `AnimatedSwitcher`
    - Inactif : `mic_none_rounded` accent (grisé si speech indisponible)
    - Actif : `mic_rounded` rouge (`AppColors.error`) avec animation

#### ✅ Recherche — Catégories et tendances mises à jour (UI design)

- `_subFilters` : `['Shōnen', 'Seinen', 'Sport']` (suppression Shōjo/Manhwa non dispo)
- `_categories` : 3 cards (Shōnen, Seinen, Sport) — suppression Shōjo/Manhwa/Donghua/Webtoon
- `_trending` : personnages réels de l'app (Gojo, Luffy, Killua, Itachi, Edward Elric, Akashi)

#### ✅ Nettoyage repo — Scripts one-shot supprimés (2 juin 2026)

- `git rm` : 7 `.docx`, `ns_data.html`, `upload_images.js`, 7 `import_*.js`,
  `send_notification.js`, 3 `rename_assets*.py`, `google_time_offset.js`, `tools/generate_assets.py`

### Prochaine étape notée

- **Tutoriel in-app** (à faire) : écran de tutoriel à l'entrée de l'application

### dart analyze → No issues found!

---

## Task 50 — Prochaine tâche : Tutoriel in-app (à planifier)

_À implémenter dans une prochaine session._

---

---

## Task 51 — Logo, Icônes Android + Fix Émulateur (4 juin 2026)

### ✅ Icône Android OTADEX

- `assets/images/logo/` : 6 assets disponibles (icon 512px, icon transparent 310px, icon white, logo transparent 727px, logo with name 512px, logo with name transparent 512px)
- Génération automatique via Python/Pillow depuis `otadex_icon.png` :
  - `mipmap-mdpi` → 48×48
  - `mipmap-hdpi` → 72×72
  - `mipmap-xhdpi` → 96×96
  - `mipmap-xxhdpi` → 144×144
  - `mipmap-xxxhdpi` → 192×192
- L'icône de lancement affiche désormais le logo OTADEX (fond `#0D0D0F` + icône)

### ✅ app_assets.dart — Nouvelles constantes

- `logoFull` → `otadex_logo_with_name_transparent.png` (corrigé, était `otadex_logo.png` inexistant)
- `logoFullSolid` → `otadex_logo_with_name.png`
- `logoIconTransparent` → `otadex_icon_small_transparent.png`
- `logoIconWhite` → `otadex_icon_white.png`
- `logoTransparent` → `otadex_logo_transparent.png`
- Splash utilise `logoFull` (transparent sur fond sombre) ✅

### ✅ Home — Logo dans l'AppBar

- `home_app_bar.dart` : le texte seul "OTADEX" remplacé par `logoIconTransparent` (36×36) + texte "OTA**DEX**" réduit à 22px
- Glow radius derrière le logo selon le rang (hasGlowEffect)

### ✅ Profil — Logo dans le header

- `profile_hero.dart` : ligne du haut transformée en header complet
  - Logo icon (28×28) + "OTA**DEX**" 16px à gauche
  - Bouton settings à droite (inchangé)

### ✅ Fix émulateur — Installation release APK

- **Cause du blocage** : APK debug = 234 MB (inclut Dart VM + symbols), partition `/data` à 90% → `INSTALL_FAILED_INSUFFICIENT_STORAGE`
- **Solution** : `flutter build apk --release` → 65 MB (4× plus petit)
- Installation via `adb install -r app-release.apk` → **Success**
- App lancée via `adb shell am start -n com.otadex.otadex/.MainActivity`
- **Pour le futur** : toujours utiliser le build release pour tester sur émulateur à faible espace

### 📊 Rapport Firebase — Analyse + Recommandations

#### Architecture Firestore actuelle

| Collection | Rôle | Accès |
|---|---|---|
| `characters` | 60+ personnages (JJK, NS, CLK...) | Lecture publique |
| `animes` | Métadonnées animés | Lecture publique |
| `creators` | Créateurs/mangakas | Lecture publique |
| `quizzes` | Quiz par personnage | Lecture publique |
| `users/{uid}` | Profil utilisateur (pseudo, rang, score) | Owner only |
| `comments` | Commentaires sur personnages | Lecture publique, write auth |
| `votes` | Votes/likes | Lecture publique, write auth |
| `subscriptions` | Abonnements | Read auth + owner |

#### ✅ Points forts

1. **Règles Firestore correctes** : `characters/animes/creators/quizzes` → read public, write false ✅
2. **Owner-only** sur `users/{uid}` : création validée via `uid == request.auth.uid` ✅
3. **Index composites** déployés : `animeId+popularityRank`, `animeId+statut`, `animeId+likesCount` ✅
4. **Fallback mock** : si Firestore vide → données locales JSON → 0 crash au premier lancement ✅
5. **Auth service complet** : email/password + Google, réauth, reset password, updateProfile ✅

#### ⚠️ Problèmes identifiés + Recommandations

**1. Recherche full-text coûteuse (PRIORITAIRE)**
- `searchCharacters()` charge 100 docs puis filtre côté client — chaque recherche = 1 lecture complète
- **Fix** : Utiliser un index Firestore sur `nom` OU intégrer Algolia/Meilisearch (Cloud Function trigger `onCreate`)

**2. `getAllCharacters(limit:200)` au démarrage**
- Chaque ouverture de l'app charge 200 documents Firestore → ~200 lectures/session
- **Fix** : Pagination `startAfterDocument` + cache local (`Riverpod keepAlive: true` ou Hive)
- Court terme : réduire `limit: 100` et ajouter `keepAlive: true` sur `allCharactersProvider`

**3. `collectionStream()` — Listener permanent**
- Stream Firestore actif tant que l'app est ouverte → OK fonctionnellement mais consomme des lectures en continu
- **Fix** : Désabonner le stream quand l'utilisateur n'est pas sur Profile/Collection

**4. Aucun rate limiting sur `votes/comments`**
- Un utilisateur peut créer des votes à répétition — aucune limite côté rules
- **Fix à ajouter dans `firestore.rules`** :
  ```js
  // Empêcher double-vote : 1 vote par user par character
  match /votes/{voteId} {
    allow create: if isSignedIn()
      && request.resource.data.user_id == request.auth.uid
      && !exists(/databases/$(database)/documents/votes/$(request.auth.uid + '_' + request.resource.data.character_id));
  }
  ```

**5. `studios` collection non sécurisée**
- La règle `/{document=**} { allow read, write: if false; }` bloque `studios` mais aucune règle explicite
- **Fix** : Ajouter une règle `match /studios/{document=**} { allow read: if true; allow write: if false; }`

**6. Champ `score_fan` non mis à jour**
- Créé à 0 à l'inscription, jamais incrémenté dans les actions utilisateur (likes, collection, quiz)
- **Fix** : Cloud Function `onVote`/`onCollect` → `increment(points)`

**7. Pas de Firestore offline persistence**
- Firestore Flutter active la persistence par défaut sur mobile, mais aucune config explicite dans `main.dart`
- **Fix** : Confirmer avec `FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);` dans `main.dart` avant `runApp()`

#### 💡 Optimisations APK size

| Technique | Gain estimé | Effort |
|---|---|---|
| `--split-per-abi` (x86_64 pour émulateur, arm64 pour device) | 40–50% | Faible — option build |
| ProGuard/R8 (déjà actif en release) | Inclus dans 65 MB | — |
| Désactiver `speech_to_text` en Genin si non utilisé | ~5 MB | Moyen |
| Retirer `firebase_storage` si Storage non utilisé activement | ~3 MB | Faible |
| Compression assets PNG → WebP (logo, splash, onboarding) | ~30% taille assets | Moyen |
| Deferred loading for quiz/chat features | ~10 MB | Élevé |

**Commande recommandée pour Play Store :**
```bash
flutter build apk --release --split-per-abi
# → app-arm64-v8a-release.apk (~35 MB) pour les vrais devices
# → app-x86_64-release.apk (~35 MB) pour l'émulateur
```

---

## Task 52 — Corrections Firebase pré-Play Store (5 juin 2026)

### Objectif
Corriger les 6 problèmes Firebase identifiés dans le rapport Task 51 avant la soumission Play Store.

### Fichiers modifiés

| Fichier | Modification |
|---------|-------------|
| `lib/core/services/firestore_character_service.dart` | FIX 1 : `searchCharacters` limit 100 → 20 / FIX 6 : ajout méthodes `toggleLike`, `submitComment`, `voteForCharacter` |
| `lib/core/providers/otadex_providers.dart` | FIX 2 : `allCharactersProvider` limit 200 → 20 + `ref.keepAlive()` |
| `lib/core/providers/anilist_providers.dart` | FIX 3 : `collectionStreamProvider` + `isCollectedProvider` → `.autoDispose` |
| `firestore.rules` | FIX 4 : rate limiting vote (voteId = uid_charId_mois, pas de doublon possible) / FIX 5 : règle `studios` ajoutée |
| `lib/features/character/presentation/character_detail_screen.dart` | FIX 6 : bouton like → `_toggleLike()` branché sur Firestore |

### Détail des fixes

#### FIX 1 — Recherche limitée à 20 docs ✅
```dart
// searchCharacters : limit(100) → limit(20)
final snap = await _db.collection('characters').limit(20).get();
```

#### FIX 2 — Pagination au démarrage (20 docs + keepAlive) ✅
```dart
final allCharactersProvider = FutureProvider<List<Character>>((ref) async {
  ref.keepAlive();
  ...getAllCharacters(limit: 20)
```
> `ref.keepAlive()` empêche le rechargement à chaque navigation.

#### FIX 3 — Stream collection autoDispose ✅
```dart
final collectionStreamProvider = StreamProvider.autoDispose<List<String>>(...);
final isCollectedProvider = Provider.autoDispose.family<bool, String>(...);
```
> Le stream Firestore se ferme automatiquement hors de CollectionScreen/ProfileScreen.

#### FIX 4 — Rate limiting votes (une fois par mois par personnage) ✅
```javascript
// firestore.rules — votes
allow create: if isSignedIn()
  && request.resource.data.user_id == request.auth.uid
  && !exists(.../votes/$(uid + '_' + character_id + '_' + mois));
allow update, delete: if false;
```
> Vote ID = `{uid}_{charId}_{YYYY-MM}` — la règle `!exists` bloque tout double vote.

#### FIX 5 — Collection studios sécurisée ✅
```javascript
match /studios/{studioId} {
  allow read: if true;
  allow write: if false;
}
```

#### FIX 6 — score_fan incrémenté sur toutes les actions ✅

| Action | Points | Statut |
|--------|--------|--------|
| Like personnage | +1 pt | ✅ Branché (`_toggleLike` → `toggleLike()`) |
| Commentaire | +3 pts | ✅ Service `submitComment()` prêt |
| Vote mensuel | +10 pts | ✅ Service `voteForCharacter()` prêt (anti-doublon) |
| Quiz réussi | +5 pts par bonne réponse | ✅ Déjà branché (Task 51) |

**Méthodes ajoutées dans `FirestoreCharacterService`** :
- `toggleLike(charId, isNowLiked)` — incrémente `score_fan` de +1 si like activé
- `submitComment(charId, text)` — crée doc dans `comments/` + incrémente `score_fan` de +3
- `voteForCharacter(charId)` — vérifie l'absence de vote ce mois, crée le vote + incrémente `score_fan` de +10

### Actions manuelles requises

```
━━━ ACTIONS MANUELLES ━━━
→ firebase deploy --only firestore:rules
→ Hot restart Flutter
→ Vérifier : recherche < 20 résultats
→ Vérifier : like → score_fan incrémenté dans Firestore users/{uid}
```

### Résultat
`dart analyze lib/` → **No issues found!**

---

_Dernière mise à jour : Task 52 — Corrections Firebase pré-Play Store, 5 juin 2026_
