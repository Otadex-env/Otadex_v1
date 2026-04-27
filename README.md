# OTADEX

Application mobile Flutter de collection de personnages animés/manga, avec système de rangs, thème dynamique et localisation multi-langue.

---

## Stack technique

| Technologie | Rôle |
|---|---|
| Flutter | Framework UI multiplateforme |
| Riverpod | Gestion d'état globale (providers) |
| GoRouter | Navigation déclarative |
| SharedPreferences | Persistance légère (login, onboarding) |
| Google Fonts | Typographies (Rajdhani, Nunito Sans) |

---

## Navigation — Flux de démarrage

```
main.dart
  └─► OtadexApp (app.dart)
        └─► GoRouter (app_router.dart)
              │
              ├─► / → SplashScreen
              │       └─► Après 2s : vérifie SharedPreferences
              │             ├─► keyHasSeenOnboarding = false → /onboarding
              │             └─► true → /home
              │
              ├─► /onboarding → OnboardingScreen (slides 1/2/3)
              │       └─► Suivant → /onboarding/age
              │
              ├─► /onboarding/age → AgeVerificationScreen
              │       └─► Confirmer → /onboarding/interests
              │
              ├─► /onboarding/interests → InterestsScreen
              │       └─► Terminer → /home  (sauvegarde keyHasSeenOnboarding)
              │
              ├─► /login → LoginScreen
              │       ├─► Connexion réussie → /home  (sauvegarde keyIsLoggedIn)
              │       └─► Pas de compte → /register
              │
              ├─► /register → RegisterScreen
              │       └─► Inscription → /login
              │
              └─► /home → HomeScreen (onglets)
                    ├─► Onglet 0 : Accueil (scroll)
                    ├─► Onglet 1 : Recherche
                    ├─► Onglet 2 : Collection (auth requise)
                    └─► Onglet 3 : Profil (auth requise)
```

> **Auth gate** : tapper sur les onglets Collection ou Profil sans être connecté ouvre `AuthGateModal` (bottom sheet login/register) au lieu de naviguer.

---

## Architecture des dossiers

```
lib/
├── main.dart                    # Point d'entrée — ProviderScope + runApp
├── app.dart                     # OtadexApp — MaterialApp.router + providers thème/locale
│
├── core/
│   ├── constants/
│   │   └── app_constants.dart   # Clés SharedPreferences (keyIsLoggedIn, keyHasSeenOnboarding)
│   │
│   ├── data/
│   │   └── mock_data.dart       # Données fictives : personnages, slides hero, trending
│   │
│   ├── l10n/
│   │   ├── app_locale.dart      # InheritedWidget qui injecte AppStrings dans le widget tree
│   │   ├── app_strings.dart     # Toutes les chaînes traduites (FR / EN / JA / ZH)
│   │   └── locale_provider.dart # StateProvider<String> — locale courante (défaut : 'fr')
│   │
│   ├── models/
│   │   ├── character.dart       # Modèle Character (id, name, series, rank, imageUrl…)
│   │   ├── featured_slide.dart  # Modèle FeaturedSlide (hero slider)
│   │   ├── user_profile.dart    # Modèle UserProfile (username, rank, stats)
│   │   └── user_rank.dart       # Enum UserRank { genin, jonin, kage } + extension label/parse
│   │
│   ├── providers/
│   │   └── recommendation_provider.dart  # Provider pour les recommandations de personnages
│   │
│   ├── router/
│   │   └── app_router.dart      # GoRouter — toutes les routes + helper getInitialRoute()
│   │
│   ├── services/
│   │   └── google_sign_in_service.dart  # Wrapper Google Sign-In
│   │
│   ├── theme/
│   │   ├── app_colors.dart          # Couleurs primitives (palette de base)
│   │   ├── app_spacing.dart         # Constantes d'espacement (xs, sm, md, lg…)
│   │   ├── app_theme.dart           # buildLightTheme() / buildDarkTheme() → ThemeData Material
│   │   ├── app_typography.dart      # Styles de texte globaux
│   │   ├── otadex_theme.dart        # InheritedWidget OtadexTheme — accès via OtadexTheme.of(ctx)
│   │   ├── otadex_theme_wrapper.dart# StatefulWidget qui applique RankTheme selon rank + isDark
│   │   ├── rank_theme.dart          # RankTheme : tokens couleur par rang (6 variantes dark/light)
│   │   └── theme_mode_provider.dart # StateProvider<ThemeMode> — défaut ThemeMode.dark
│   │
│   └── widgets/
│       ├── auth_gate_modal.dart         # Modal bottom sheet : connexion ou inscription
│       ├── otadex_button.dart           # Bouton primaire stylé
│       ├── otadex_text_field.dart       # Champ texte stylé
│       ├── rank_badge.dart              # Badge visuel du rang (Genin / Jonin / Kage)
│       ├── subscription_billing_card.dart  # Carte tarif abonnement
│       ├── subscription_feature_item.dart  # Ligne de feature dans modal abonnement
│       └── subscription_modal.dart         # Modal d'upsell abonnement premium
│
└── features/
    ├── splash/
    │   └── presentation/
    │       └── splash_screen.dart   # Écran de démarrage animé (logo + redirect)
    │
    ├── onboarding/
    │   └── presentation/
    │       ├── onboarding_screen.dart      # Slides swipables (PageView)
    │       ├── age_verification_screen.dart# Confirmation de l'âge utilisateur
    │       ├── interests_screen.dart       # Sélection des centres d'intérêt
    │       └── widgets/
    │           ├── onboarding_page.dart        # Template d'une slide
    │           ├── onboarding_rank_card.dart   # Carte illustrant un rang
    │           ├── slide_one_content.dart      # Contenu slide 1 : Découvrir
    │           ├── slide_two_content.dart      # Contenu slide 2 : Collectionner
    │           └── slide_three_content.dart    # Contenu slide 3 : Rejoindre
    │
    ├── auth/
    │   └── presentation/
    │       ├── login_screen.dart     # Formulaire email/password + Google Sign-In
    │       ├── register_screen.dart  # Formulaire inscription + choix du rang initial
    │       └── widgets/
    │           └── rank_selector.dart  # Sélecteur visuel Genin / Jonin / Kage
    │
    ├── home/
    │   └── presentation/
    │       ├── home_screen.dart      # Scaffold principal avec IndexedStack (4 onglets)
    │       └── widgets/
    │           ├── bottom_nav_bar.dart         # Barre de navigation bas (4 onglets)
    │           ├── category_chips.dart         # Filtres de catégorie horizontaux
    │           ├── character_grid_card.dart    # Carte individuelle de personnage
    │           ├── character_grid_section.dart # Grille de personnages filtrée par catégorie
    │           ├── hero_featured_slider.dart   # Carrousel hero (personnages mis en avant)
    │           ├── home_app_bar.dart           # AppBar avec avatar, rang et bouton login
    │           ├── search_bar_widget.dart      # Barre de recherche sticky (SliverPersistentHeader)
    │           ├── section_header.dart         # En-tête de section (titre + "Voir tout")
    │           ├── trending_character_card.dart# Carte personnage dans la section trending
    │           ├── trending_section.dart       # Section horizontale des tendances
    │           └── upsell_banner.dart          # Bannière d'upgrade (visible uniquement Genin)
    │
    ├── search/
    │   └── presentation/
    │       └── search_screen.dart    # Onglet Recherche (barre + résultats)
    │
    └── profile/
        └── presentation/
            ├── profile_screen.dart   # Écran profil — ConsumerStatefulWidget
            └── widgets/
                ├── avatar_picker.dart          # Sélecteur d'avatar utilisateur
                ├── billing_toggle.dart         # Toggle mensuel / annuel
                ├── kage_banner.dart            # Bannière promotionnelle rang Kage (dismissable)
                ├── plan_card.dart              # Carte d'un plan tarifaire
                ├── plan_section.dart           # Section plans (Genin / Jonin / Kage)
                ├── profile_hero.dart           # En-tête profil (avatar + username + bio)
                ├── profile_logout_footer.dart  # Bouton de déconnexion
                ├── profile_stat_row.dart       # Ligne de stats (Collection / FanScore / Rang)
                ├── profile_tab_bar.dart        # Onglets Profil (Collection / Progression / Stats)
                ├── profile_tab_content.dart    # Contenu selon l'onglet sélectionné
                ├── settings_section.dart       # Paramètres : compte, préférences, contenu, à propos
                └── subscription_card.dart      # Carte abonnement actif
```

---

## Système de thème

Le thème est **double** : Material (clair/sombre) + Rang (couleurs spécifiques au rang).

```
themeModeProvider (Riverpod)
  └─► ThemeMode.dark (défaut) ou ThemeMode.light
        │
        ├─► MaterialApp.router
        │     ├─► theme: AppTheme.buildLightTheme()
        │     └─► darkTheme: AppTheme.buildDarkTheme()
        │
        └─► OtadexThemeWrapper
              ├─► isDark: true/false
              └─► RankTheme.forRank(rank, isDark: isDark)
                    ├─► Genin dark / Genin light
                    ├─► Jonin dark / Jonin light
                    └─► Kage dark  / Kage light
```

Accès dans n'importe quel widget :
```dart
final theme = OtadexTheme.of(context);   // → RankTheme
final rank  = OtadexTheme.rankOf(context); // → UserRank
```

**Jetons disponibles dans RankTheme :** `accentColor`, `accentLight`, `accentGlow`, `accentShimmer`, `backgroundPrimary`, `backgroundCard`, `backgroundElevated`, `backgroundInput`, `borderDefault`, `borderActive`, `borderSubtle`, `textPrimary`, `textSecondary`, `textLink`, `rankBadgeColor`, `rankBadgeBg`, `backgroundGradient`, `hasShimmerEffect`, `hasGlowEffect`.

---

## Localisation

Système manuel (pas d'ARB/intl) géré par `AppStrings`.

```
localeProvider (Riverpod)   ← StateProvider<String>, défaut 'fr'
  └─► AppLocale (InheritedWidget)
        └─► AppStrings.forLocale(locale) → AppStrings instance
              └─► AppStrings.of(context)  dans n'importe quel widget
```

Langues supportées : **Français (fr)**, **English (en)**, **日本語 (ja)**, **中文 (zh)**.

Changer la langue : Profil → Paramètres → Langue → bottom sheet de sélection avec confirmation.

---

## Persistance locale (SharedPreferences)

| Clé | Type | Rôle |
|---|---|---|
| `keyIsLoggedIn` | bool | Utilisateur connecté ou non |
| `keyHasSeenOnboarding` | bool | Onboarding déjà vu (skip au prochain lancement) |

---

## Commandes utiles

```bash
# Lancer l'application
flutter run

# Analyser le code
flutter analyze --no-fatal-infos

# Lancer les tests
flutter test --reporter=compact

# Build APK debug
flutter build apk --debug

# Build APK release
flutter build apk --release
```
