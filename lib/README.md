# lib/

Point d'entrée de l'application Flutter OTADEX.

## Contenu

| Fichier / Dossier | Rôle |
|---|---|
| `main.dart` | Bootstrap de l'app : orientation, barre système, ProviderScope, reset debug onboarding |
| `app.dart` | Widget racine `OtadexApp` : MaterialApp.router + thème sombre + GoRouter |
| `core/` | Utilitaires partagés par toutes les features (thème, routing, constantes, widgets) |
| `features/` | Modules fonctionnels organisés par domaine métier (splash, onboarding, auth…) |

## Architecture

L'application suit une **architecture Feature-first + Clean Architecture** :
- chaque feature est autonome dans son dossier
- le dossier `core/` contient uniquement du code réutilisable entre features
- la navigation globale est gérée par GoRouter depuis `core/router/`
