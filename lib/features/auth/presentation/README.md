# lib/features/auth/presentation/

Couche de présentation de la feature Auth.

## Fichiers

| Fichier | Contenu |
|---|---|
| `login_screen.dart` | `LoginScreen` — 3 layers de fond (illustration ninja 22% opacité, gradient sombre, lueur violette), formulaire email+mdp, bouton Google SSO, lien vers `/register` |
| `register_screen.dart` | `RegisterScreen` — formulaire d'inscription |

## Composition visuelle du LoginScreen

```
Stack
 ├── Layer 0 : splash_illustration.png (opacity 0.22, cover, topCenter)
 ├── Layer 1 : LinearGradient 4 stops (0.30 → 0.65 → 0.92 → 1.0 opacité backgroundDeep)
 ├── Layer 2 : RadialGradient violet en haut (primary, alpha 0.18)
 └── SafeArea → Form
      ├── Logo 160px
      ├── Titre "Bon retour, ninja 🥷"
      ├── OtadexTextField (email)
      ├── OtadexPasswordField (mot de passe)
      ├── TextButton "Mot de passe oublié ?"
      ├── OtadexButton "Se connecter"
      ├── Séparateur "ou"
      ├── OutlinedButton "Continuer avec Google"
      └── Footer "Pas encore de compte ? Deviens Genin"
```

## TODO Task 02

- Remplacer `Future.delayed` mock par un vrai `LoginUseCase` Firebase
- Ajouter gestion d'erreurs (email invalide, mauvais mot de passe, compte inexistant)
- Implémenter le flux Google Sign-In
- Sauvegarder `keyIsLoggedIn = true` après succès
