# Guide du code OTADEX (pour s'y retrouver seul)

Ce guide explique **où est quoi** et **comment les pièces s'enchaînent**.
Il remplace les parties devenues fausses de `OTADEX_CONTEXT.md` (noms de dossiers
`screens/`, `data/`, `domain/` qui n'existent plus tels quels).

## 1. Démarrage de l'app (dans l'ordre)

1. `lib/main.dart` → `main()` :
   - charge `.env` (valeurs publiques), initialise Firebase ;
   - lit les préférences locales (connecté ? quel rang ?) ;
   - crée les « providers » de départ puis lance `runApp`.
2. `lib/app.dart` → `OtadexApp` : langue, thème, navigation.
3. `lib/core/router/app_router.dart` : liste des pages. La première est
   `SplashScreen`, qui décide ensuite : onboarding, login ou home
   (`getInitialRoute()`).

## 2. Organisation des dossiers

| Dossier | Contenu | Quand y toucher |
|---|---|---|
| `lib/core/theme/` | couleurs (`app_colors.dart`), polices, thèmes par rang | changer le look |
| `lib/core/l10n/` | textes traduits (`app_strings.dart`) | changer/ajouter un texte |
| `lib/core/models/` | classes de données (`Character`, `UserProfile`…) | ajouter un champ |
| `lib/core/services/` | accès au monde extérieur (Firebase, API, licences) | brancher un service |
| `lib/core/providers/` | état partagé (Riverpod) | partager une donnée entre écrans |
| `lib/core/widgets/` | petits composants réutilisables (boutons, images…) | réutiliser un composant |
| `lib/features/<nom>/presentation/` | les écrans, un dossier par fonctionnalité | modifier un écran |
| `firestore.rules` | qui a le droit de lire/écrire dans la base | sécurité |

Règle simple : un **écran** affiche, un **service** parle à Firebase/API, un
**provider** garde l'état et le rend disponible aux écrans.

## 3. Riverpod en 4 lignes

- `ref.watch(unProvider)` dans `build` : lit la valeur **et** reconstruit
  l'écran quand elle change.
- `ref.read(unProvider)` dans un `onPressed` : lit une fois, sans reconstruire.
- `ref.read(unProvider.notifier).state = x` : modifie un `StateProvider`.
- Un widget qui utilise `ref` est un `ConsumerWidget` / `ConsumerStatefulWidget`.

## 4. Le rang (Genin / Jonin / Kage)

- Source de vérité : `lib/core/subscription/rank_providers.dart`.
- **Les écrans lisent uniquement `effectiveRankProvider`.**
- Le vrai rang est écrit côté serveur (Worker de licences) dans
  `users/{uid}.abonnement`. Le client ne l'écrit jamais ; `firestore.rules`
  l'interdit (création comprise, depuis la correction du 21/10/2026).
- Au retour au premier plan, `main.dart` revérifie la licence (au plus toutes
  les 4 h).

## 5. Navigation

- `context.go('/home')` : remplace la pile de pages.
- `context.push('/character/12')` : ajoute une page par-dessus (retour possible).
- Données complexes : `context.push('/gallery/12', extra: {...})`.

## 6. Ajouter un écran (recette)

1. Créer `lib/features/<feature>/presentation/mon_ecran.dart`.
2. Ajouter un `GoRoute` dans `app_router.dart`.
3. Y aller avec `context.push('/ma-route')`.
4. Textes dans `app_strings.dart`, couleurs dans `AppColors` (pas de
   `Color(0x…)` en dur).

## 7. Points de vigilance connus

- Fichiers très longs, à découper un jour : `search_screen.dart` (~1600 lignes),
  `app_assets.dart`, `mock_data.dart`, `app_strings.dart`.
- Beaucoup de `catch (_)` qui renvoient une liste vide dans
  `firestore_character_service.dart` : l'écran ne sait pas si c'est « aucun
  résultat » ou « erreur réseau ».
- La route `/search-standalone` est identique à `/search` et n'est utilisée
  nulle part.
- Le rang étant aussi copié dans les préférences locales, ne jamais s'y fier
  pour une décision de sécurité : seul le serveur fait autorité.
