# lib/features/splash/

Écran de démarrage (splash screen) affiché au lancement de l'application.

## Rôle

- Afficher l'identité visuelle OTADEX pendant le chargement
- Décider de la route initiale via `getInitialRoute()` (onboarding, login ou home)
- Durée totale : **3 500 ms** (`AppConstants.splashDuration`)

## Séquence d'animation

| Temps | Événement |
|---|---|
| 0 ms | Fade-in illustration de fond |
| 300 ms | Apparition du logo avec slideY |
| 900 ms | Fade-in de la tagline (shimmer) |
| 1 200 ms | Début de la pulsation du logo |
| 1 800 ms | Apparition des badges GENIN / JONIN / KAGE |
| 2 000 ms | Démarrage de la barre de progression gradient |
| 3 500 ms | Redirection vers la route initiale |

## Fichiers

| Fichier | Contenu |
|---|---|
| `presentation/splash_screen.dart` | `SplashScreen` — widget principal avec tous les layers et la séquence temporelle |
