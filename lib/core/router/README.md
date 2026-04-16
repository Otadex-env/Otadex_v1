# lib/core/router/

Configuration centralisée de la navigation avec **GoRouter**.

## Fichiers

| Fichier | Contenu |
|---|---|
| `app_router.dart` | `AppRouter` : constantes de routes, instance `GoRouter`, `_HomePlaceholder`, `getInitialRoute()` |

## Routes définies

| Constante | Chemin | Écran |
|---|---|---|
| `AppRouter.splash` | `/` | `SplashScreen` |
| `AppRouter.onboarding` | `/onboarding` | `OnboardingScreen` |
| `AppRouter.login` | `/login` | `LoginScreen` |
| `AppRouter.register` | `/register` | `RegisterScreen` |
| `AppRouter.home` | `/home` | `_HomePlaceholder` (Task 02) |

## Logique de redirection

`getInitialRoute()` lit SharedPreferences et retourne :
- `/onboarding` si l'onboarding n'a jamais été vu
- `/login` si l'utilisateur n'est pas connecté
- `/home` si l'utilisateur est connecté

Cette fonction est appelée depuis `SplashScreen._redirect()` après l'animation de démarrage.
