# lib/features/splash/presentation/

Couche de présentation de la feature Splash.

## Fichiers

| Fichier | Contenu |
|---|---|
| `splash_screen.dart` | `SplashScreen` (StatefulWidget) — gère 2 AnimationController (progression + pulsation), les particules montantes (CustomPaint via `Random(42)`), les badges de rang animés, et la redirection via `_redirect()` |

## Widgets privés internes

- `_RankTeaser` — badge pill coloré (GENIN / JONIN / KAGE) affiché en bas de l'écran
- `_Dot` — séparateur `·` entre les badges
- `_buildParticles()` — liste de particules oranges montantes générées avec `Random(42)`
- `_buildGradientProgressBar()` — barre de progression gradient orange animée sur 1 500 ms

## Dépendances

- `flutter_animate` — animations d'entrée du logo et des badges
- `shimmer` — effet shimmer sur la tagline
- `go_router` — navigation vers la route initiale
- `shared_preferences` — lu via `getInitialRoute()` pour décider de la destination
