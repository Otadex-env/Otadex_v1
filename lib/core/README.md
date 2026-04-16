# lib/core/

Code partagé entre toutes les features. Ne contient aucune logique métier spécifique à un domaine.

## Sous-dossiers

| Dossier | Rôle |
|---|---|
| `constants/` | Constantes globales de l'application (clés SharedPreferences, noms de rangs, tagline) |
| `router/` | Configuration GoRouter : routes nommées, redirections, `getInitialRoute()` |
| `theme/` | Système de design : couleurs, typographie, espacements |
| `widgets/` | Widgets réutilisables indépendants de toute feature (boutons, champs de texte, badges) |

## Règle d'or

Un fichier placé dans `core/` ne doit **jamais** importer depuis `features/`.
La dépendance est toujours unidirectionnelle : `features/ → core/`.
