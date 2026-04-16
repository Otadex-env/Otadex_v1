# lib/features/auth/

Feature d'authentification : connexion et inscription des utilisateurs.

## État actuel

- **Task 01 ✅** — UI complète (login + register screens)
- **Task 02 🔜** — Logique réelle Firebase Auth + Riverpod providers

## Écrans

| Écran | Route | Description |
|---|---|---|
| `LoginScreen` | `/login` | Connexion par email/mot de passe + Google SSO (UI), fond illustration ninja avec overlay gradient |
| `RegisterScreen` | `/register` | Inscription avec choix de rang initial (GENIN par défaut) |

## Architecture cible (Task 02)

```
auth/
  data/
    repositories/   # FirebaseAuthRepository (impl de AuthRepository)
    datasources/    # FirebaseAuthDataSource
  domain/
    entities/       # User, AuthState
    repositories/   # AuthRepository (interface)
    use_cases/      # LoginUseCase, RegisterUseCase, LogoutUseCase
  presentation/
    providers/      # authStateProvider (Riverpod)
    login_screen.dart
    register_screen.dart
    widgets/
```

## Fichiers présents

| Fichier | Contenu |
|---|---|
| `presentation/login_screen.dart` | `LoginScreen` — formulaire email/mdp, fond ninja, mock login (1s delay) |
| `presentation/register_screen.dart` | `RegisterScreen` — formulaire inscription |
| `presentation/widgets/` | Widgets spécifiques à l'auth |
