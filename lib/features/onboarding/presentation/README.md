# lib/features/onboarding/presentation/

Couche de présentation de la feature Onboarding.

## Fichiers

| Fichier | Contenu |
|---|---|
| `onboarding_screen.dart` | `OnboardingScreen` — widget principal avec `PageController`, animation de particules, bouton "Passer", `SmoothPageIndicator` en bas |

## Architecture de navigation entre slides

L'écran orchestre les slides via des callbacks :

```dart
_slideAt(0) → SlideOneContent()                        // pas de bouton CTA
_slideAt(1) → SlideTwoContent(onNext: _nextPage)       // CTA → slide suivante
_slideAt(2) → SlideThreeContent(onFinish: _finish)     // CTA → login
```

`_finish()` écrit `keyHasSeenOnboarding = true` dans SharedPreferences avant de naviguer vers `/login`.

## Effets visuels

- **Transition scale+opacity** : chaque slide rétrécit et devient transparente pendant le swipe (`scale = 1.0 - offset * 0.08`, `opacity = 1.0 - offset * 0.5`)
- **Particules de fond** : 12 points orange montants générés avec `Random(77)`, animés via `_particleController` (5s en boucle)
- **Bouton Skip** : visible uniquement sur les slides 0 et 1, disparaît en fade sur la slide 2

## Sous-dossier

`widgets/` — les 3 contenus de slides, importés et montés par cet écran
