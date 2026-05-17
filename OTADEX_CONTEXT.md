# OTADEX — Contexte Projet Complet

> Fichier de référence pour Claude Code — à lire en début de chaque session

## 1. Vision & Objectif

- Nom : OTADEX — "The Ultimate Anime Character Encyclopedia"
- Concept : encyclopédie mobile interactive de personnages d'animés/webtoons/manhwas
- Inspiré du Pokédex (collection) + Pinterest (esthétique visuelle)
- Public cible : fans d'animés francophones, 15–35 ans
- Marché principal : Cameroun → Afrique francophone → Mondial
- Développé en solo avec assistance Claude Code

## 2. Stack Technique

- Frontend : Flutter 3.x (Dart) — iOS + Android
- State management : Riverpod (flutter_riverpod)
- Navigation : go_router
- Auth : Firebase Authentication (email + Google OAuth)
- Base de données : Cloud Firestore
- Stockage : Firebase Storage
- Fonctions serveur : Firebase Cloud Functions (Node.js) — prévues pour plus tard, non nécessaires au flow premium local actuel
- API animés principale : AniList GraphQL (https://graphql.anilist.co)
- API animés backup : Jikan REST API (https://api.jikan.moe/v4)
- IA Chatbot : assistant local OTADEX en attendant un branchement Cloud Function
- IA Image gen : rendu local d'image citation Kage en attendant un générateur distant
- Paiement : Chariow via liens externes + activation locale de licence
- Analytics : Firebase Analytics
- Monitoring : Firebase Crashlytics
- CI/CD : GitHub Actions + Fastlane
- Images réseau : cached_network_image
- Animations : flutter_animate
- Masonry grid : flutter_staggered_grid_view
- Font : DM Sans (Google Fonts)

## 3. Architecture — Clean Architecture

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_text_styles.dart
│   │   └── app_theme.dart
│   ├── widgets/
│   │   ├── bottom_nav_bar.dart
│   │   ├── character_card.dart
│   │   ├── section_header.dart
│   │   ├── category_pill.dart
│   │   ├── skeleton_loader.dart
│   │   ├── toast_widget.dart
│   │   └── premium_gate_sheet.dart
│   └── router/
│       └── app_router.dart
├── features/
│   ├── home/
│   ├── search/
│   ├── character/
│   ├── anime/
│   ├── creator/
│   ├── profile/
│   ├── auth/
│   └── subscription/
└── main.dart
```

Chaque feature suit : `data/` | `domain/` | `presentation/screens/` | `presentation/widgets/`

## 4. Design System — Tokens

**Couleurs (dans `app_colors.dart`) :**
| Token | Valeur | Usage |
|---|---|---|
| bgPrimary | `Color(0xFF0D0D0F)` | Fond principal |
| bgSurface | `Color(0xFF1A1A1F)` | Cards, surfaces |
| bgElevated | `Color(0xFF242429)` | Sheets, inputs |
| orange | `Color(0xFFFF6D1B)` | CTA principal, FAB, actifs |
| blue | `Color(0xFF3B82F6)` | Jonin tier |
| purple | `Color(0xFF8B5CF6)` | Kage tier |
| green | `Color(0xFF10B981)` | Succès |
| red | `Color(0xFFEF4444)` | Erreur, antagoniste |
| amber | `Color(0xFFF59E0B)` | Avertissement, étoiles |
| textPrimary | `Color(0xFFF5F5F5)` | Texte principal |
| textSecondary | `Color(0xFF8A8A9A)` | Texte secondaire |
| textDisabled | `Color(0xFF4A4A5A)` | Texte désactivé |

**Typographie — DM Sans :**

- 800 ExtraBold → titres héros (30–40px)
- 700 Bold → headers de section (17px)
- 600 SemiBold → noms cards, tabs actifs (15–16px)
- 500 Medium → tabs inactifs, chips (13px)
- 400 Regular → corps de texte (14px)
- 10–12px → badges, labels nav

**Spacing & Radius :**

- Padding horizontal écran : 16px
- Gap cards : 12px | Gap sections : 28–32px
- Radius : 50% avatars | 24px sheets | 14px boutons | 12px cards | 18px chips
- Safe area top : 44px | bottom : 34px
- Touch target minimum : 44×44px

## 5. Modèle Freemium

**Genin (gratuit) :**

- Consultation fiches ✅
- Recherche ✅
- Likes & commentaires ✅
- Collection max 10 personnages
- Publicités affichées
- IA désactivée ❌

**Jonin (2 000 FCFA/mois) :**

- Tout Genin +
- Collection illimitée ✅
- Sans publicités ✅
- IA chatbot personnage ✅
- Quiz IA ✅
- Recommandations IA ✅

**Kage Pass (5 000 FCFA/mois) :**

- Tout Jonin +
- Génération image citation IA ✅
- Téléchargement sans watermark ✅
- Thèmes exclusifs ✅
- Priorité Fan du Mois ✅

## 5.1 Tâches par abonnement

### Genin (gratuit) — objectif Play Store

1. Créer et publier la version gratuite sur le Play Store.
2. Authentification Firebase réelle (email + Google) avec persistance de session.
3. Écran d'accueil listant les personnages.
4. Recherche fonctionnelle de personnages.
5. Fiche personnage complète avec :
   - description,
   - galeries d'images en ligne,
   - likes,
   - commentaires,
   - ajout aux favoris,
   - ajout à la collection.
6. Galerie plein écran avec images réseau et placeholder shimmer (`cached_network_image`).
7. Collection limitée à 10 personnages pour Genin.
8. Profile et paramètres fonctionnels.
9. Stockage des données utilisateur et collection dans Firestore.
10. Pages légales / conditions / confidentialité disponibles et liées.
11. App taille cible < 60 MB : toutes les images animés doivent être réseau, pas locales.

### Jonin — roadmap phase 2

1. Débloquer collection illimitée.
2. Supprimer les publicités.
3. Ajouter IA chatbot personnage.
4. Ajouter quiz IA.
5. Ajouter recommandations personnalisées.
6. Implémenter page d'abonnement (PlansScreen) et paiement mobile.
7. Mettre en place gestion des souscriptions.
8. Ajouter thèmes premium et contenus exclusifs.

### Kage — roadmap phase 3

1. Génération d'image IA sans watermark.
2. Téléchargement d'images HD.
3. Thèmes exclusifs avancés.
4. Badge / priorité fan.
5. Fonctions premium de personnalisation et d'accès anticipé.
6. Gestion complète de l'abonnement Kage dans l'app.

## 6. Écrans MVP (Play Store)

| #   | Écran               | Chemin                                                                 |
| --- | ------------------- | ---------------------------------------------------------------------- |
| 1   | Home                | `features/home/presentation/screens/home_screen.dart`                  |
| 2   | Fiche Personnage    | `features/character/presentation/screens/character_detail_screen.dart` |
| 3   | Galerie Plein Écran | `features/character/presentation/screens/gallery_screen.dart`          |
| 4   | Recherche           | `features/search/presentation/screens/search_screen.dart`              |
| 5   | Inscription         | `features/auth/presentation/screens/signup_screen.dart`                |
| 6   | Connexion           | `features/auth/presentation/screens/login_screen.dart`                 |
| 7   | Profil + Paramètres | `features/profile/presentation/screens/profile_screen.dart`            |
| 8   | Fiche Animé         | `features/anime/presentation/screens/anime_detail_screen.dart`         |
| 9   | Fiche Créateur      | `features/creator/presentation/screens/creator_screen.dart`            |
| 10  | Plans & Abonnement  | `features/subscription/presentation/screens/plans_screen.dart`         |

## 7. Navigation Map (go_router)

```
/splash          → SplashScreen
/home            → HomeScreen
/search          → SearchScreen
/character/:id   → CharacterDetailScreen
/anime/:id       → AnimeDetailScreen
/creator/:id     → CreatorScreen
/gallery/:charId → GalleryScreen
/profile         → ProfileScreen
/auth/login      → LoginScreen
/auth/signup     → SignupScreen
/subscription    → PlansScreen
```

## 8. Collections Firestore

| Collection      | Champs clés                                                                    |
| --------------- | ------------------------------------------------------------------------------ |
| `users`         | uid, pseudo, email, abonnement, score_fan, badges[], created_at                |
| `characters`    | id, nom, anime_id, description, pouvoirs[], citations[], images[], likes_count |
| `animes`        | id, titre, synopsis, genres[], createur_id, personnages_ids[]                  |
| `creators`      | id, nom, bio, nationalite, oeuvres_ids[]                                       |
| `votes`         | user_id, character_id, mois, created_at                                        |
| `comments`      | user_id, character_id, texte, likes, signalements, created_at                  |
| `badges`        | id, nom, description, condition, image_url                                     |
| `subscriptions` | user_id, plan, start_date, end_date, auto_renew                                |

## 9. Règles de développement

- Toutes les couleurs → `AppColors` (jamais hardcodées inline)
- Toutes les strings UI → en français
- Composants partagés → `lib/core/widgets/` (ne jamais recréer inline)
- Pas d'appels API directs dans les widgets → passer par les repositories
- Clés API sensibles → Firebase Cloud Functions uniquement, jamais côté client
- Images toujours avec `cached_network_image` + placeholder shimmer
- `SafeArea` respectée sur tous les écrans
- Respect des quotas Firebase Spark Plan en Phase 1

## 10. Données mockées (pour développement)

**Personnages :**
| Nom | Œuvre | Type | Titre | Likes |
|---|---|---|---|---|
| Sung Jinwoo | Solo Leveling | Manhwa | Monarque des Ombres | 24 831 |
| Gojo Satoru | Jujutsu Kaisen | Shonen | Grade Spécial 0 | 38 247 |
| Tanjiro Kamado | Demon Slayer | Shonen | Pilier Eau | 29 400 |
| Monkey D. Luffy | One Piece | Shonen | Roi des Pirates | 51 200 |
| Frieren | Frieren BJE | Shonen | Archimage | 18 700 |
| Levi Ackerman | Attack on Titan | Seinen | Capitaine | 44 100 |

**Users :**
| Pseudo | Plan | Niveau | Score | Collectés |
|---|---|---|---|---|
| Jean-Paul_Otaku | Jonin | 4 | 3 847 | 67 |
| Awa_Fan | Genin | 2 | 412 | 7 |

## 11. État d'implémentation — Mai 2026

### ✅ Terminé (Task 01)

- Splash screen animé
- Onboarding (3 slides)
- Auth screens (Login + Signup) — mock local + SharedPreferences
- `isLoggedInProvider` (Riverpod StateProvider) — source de vérité réactive pour l'auth
- HomeScreen → ConsumerStatefulWidget, lit `isLoggedInProvider`
- LoginScreen → écrit `isLoggedInProvider` après login réussi

### ✅ Terminé (Task 02 — partiel)

- ProfileScreen complet avec hero, stats, tabs, avatar picker, settings
- `UserProfileNotifier` avec `updateProfile()` et `updateAvatar()`
- `EditProfileSheet` avec sélection d'image (image_picker ^1.1.0)
- Jonin-gate avatar : seuls Jonin/Kage peuvent changer leur avatar
- `ProfileHero` affiche l'avatar local (FileImage) si défini
- Permissions Android : `READ_MEDIA_IMAGES` + `READ_EXTERNAL_STORAGE`

### 🔜 À faire

- Soumission Play Store : AAB/APK signé, captures finales, Play Console.
- Tester login/register/logout et achats licence sur appareil réel.
- Déployer/valider `firestore.rules` côté Firebase.
- Remplacer progressivement les données enrichies mock par AniList/Firestore live.
- Brancher plus tard Cloud Functions pour IA distante et validation serveur des licences.
- Image persistance avatar complète via Firebase Storage.

## 12. Providers Riverpod existants

| Provider              | Fichier                                     | Type                                                      | Rôle                       |
| --------------------- | ------------------------------------------- | --------------------------------------------------------- | -------------------------- |
| `isLoggedInProvider`  | `core/providers/auth_provider.dart`         | `StateProvider<bool>`                                     | État de connexion global   |
| `userProfileProvider` | `core/providers/user_profile_provider.dart` | `StateNotifierProvider<UserProfileNotifier, UserProfile>` | Profil utilisateur courant |
| `localeProvider`      | `core/l10n/locale_provider.dart`            | `StateProvider<String>`                                   | Langue de l'app            |
| `themeModeProvider`   | `core/theme/theme_mode_provider.dart`       | `StateProvider<ThemeMode>`                                | Thème clair/sombre         |

## 13. Ordre d'implémentation recommandé

1. AppColors + AppTextStyles + AppTheme
2. Composants partagés (BottomNav, CharacterCard, SectionHeader, etc.)
3. AppRouter (go_router config complète)
4. Auth screens (Login + Signup) + Firebase Auth
5. HomeScreen + données mockées
6. CharacterDetailScreen
7. SearchScreen + Firestore fulltext
8. ProfileScreen
9. Fiche Animé + Fiche Créateur
10. PlansScreen + Chariow/licence locale

---

_Dernière mise à jour : mai 2026_
_Généré pour Claude Code — OTADEX MVP Phase 1_
