# lib/features/onboarding/

Présentation du concept de l'application aux nouveaux utilisateurs via 3 slides swipables.

## Rôle

- Expliquer la valeur de l'app (encyclopédie animé, catalogue de personnages, système de rangs)
- Enregistrer que l'onboarding a été vu (`keyHasSeenOnboarding = true`) à la fin
- Rediriger vers l'écran de connexion une fois terminé

## Slides

| Slide | Titre | Contenu clé |
|---|---|---|
| 1 | L'univers Animé dans ta poche | Illustration flottante (animation 3 500 ms), badge "ENCYCLOPÉDIE OTAKU", sous-titre |
| 2 | Explore 10 000+ personnages | Mockup téléphone avec lueur violette, bouton "Découvrir →" |
| 3 | Quel fan es-tu ? | Cartes GENIN / JONIN / KAGE avec tarifs, bouton "Commencer l'aventure →" |

## Fichiers

| Fichier | Contenu |
|---|---|
| `presentation/onboarding_screen.dart` | Écran principal : `PageController`, particules animées, bouton Skip, `SmoothPageIndicator` |
| `presentation/widgets/slide_one_content.dart` | Contenu slide 1 |
| `presentation/widgets/slide_two_content.dart` | Contenu slide 2 |
| `presentation/widgets/slide_three_content.dart` | Contenu slide 3 avec cartes de rang |
