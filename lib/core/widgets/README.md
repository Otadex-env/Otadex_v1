# lib/core/widgets/

Widgets génériques réutilisables dans toutes les features. Aucune logique métier ici.

## Fichiers

| Fichier | Widget(s) | Description |
|---|---|---|
| `otadex_button.dart` | `OtadexButton` | Bouton principal gradient orange, avec état `isLoading` (spinner), hauteur fixe `buttonHeight=56` |
| `otadex_text_field.dart` | `OtadexTextField`, `OtadexPasswordField` | Champ de saisie stylisé (fond sombre, bordure accent on focus) + variante mot de passe avec toggle visibilité |
| `rank_badge.dart` | `RankBadge` | Badge pill coloré selon le rang (GENIN / JONIN / KAGE), utilisé dans le profil et l'onboarding |

## Principes

- Ces widgets acceptent des paramètres génériques (`label`, `onPressed`, `controller`…) sans couplage à un provider ou à un state spécifique
- Ils respectent le design system défini dans `core/theme/`
- L'ajout d'un widget ici doit être justifié par une réutilisation dans **au moins 2 features différentes**
