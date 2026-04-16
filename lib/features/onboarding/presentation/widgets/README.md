# lib/features/onboarding/presentation/widgets/

Contenus des 3 slides de l'onboarding. Chaque widget est un `StatelessWidget` (sauf slide 1) autonome et sans connaissance de `PageController`.

## Fichiers

| Fichier | Widget | Spécificités |
|---|---|---|
| `slide_one_content.dart` | `SlideOneContent` | `StatefulWidget` — `AnimationController` 3 500 ms pour l'effet float (translateY -10 ↔ +10) sur l'illustration |
| `slide_two_content.dart` | `SlideTwoContent` | `VoidCallback? onNext` — bouton "Découvrir →" appelle `onNext` (fourni par `OnboardingScreen._nextPage`) |
| `slide_three_content.dart` | `SlideThreeContent` | `VoidCallback? onFinish` — bouton "Commencer l'aventure →" appelle `onFinish` (fourni par `OnboardingScreen._finish`) |

## Widgets privés dans slide_three_content.dart

- `_RankCard` — carte de rang avec icône, nom, description et badge prix. Paramètres : `rank`, `color`, `bgColor`, `icon`, `priceLabel`, `isPriceBadge`, `badgeIsGreen`, `premiumBadge`, `description`, `delay`
- `_PillBadge` — badge pill "GRATUIT" (vert) et "PREMIUM" (accent orange)

## Pattern de couplage

Les slides reçoivent les callbacks depuis leur parent (`OnboardingScreen`) et ne naviguent pas elles-mêmes. Cela garantit que la logique de navigation (SharedPreferences + GoRouter) reste dans l'écran parent.
