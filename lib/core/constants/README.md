# lib/core/constants/

Constantes statiques de l'application, regroupées dans des classes utilitaires avec constructeur privé.

## Fichiers

| Fichier | Contenu |
|---|---|
| `app_constants.dart` | Clés SharedPreferences (`keyHasSeenOnboarding`, `keyIsLoggedIn`, `keyUserRank`), noms de rangs, durée du splash, nom et tagline de l'app |

## Usage

```dart
import '../../../core/constants/app_constants.dart';

prefs.getBool(AppConstants.keyHasSeenOnboarding)
prefs.setBool(AppConstants.keyIsLoggedIn, true)
```

Toutes les valeurs sont des `const` — elles ne doivent jamais être définies inline dans le code métier.
