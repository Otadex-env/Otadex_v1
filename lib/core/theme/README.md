# lib/core/theme/

Système de design OTADEX — palette de couleurs, typographie et grille d'espacement.

## Fichiers

| Fichier | Contenu |
|---|---|
| `app_colors.dart` | Toutes les couleurs de l'app (`primary`, `accent`, `backgroundDeep`, `rankGenin/Jonin/Kage`…) |
| `app_spacing.dart` | Grille 8pt : `xs=4`, `sm=8`, `md=16`, `lg=24`, `xl=32`, `xxl=48`, `buttonHeight=56`, `radiusLg`, `radiusFull` |
| `app_typography.dart` | Styles de texte partagés (via GoogleFonts Rajdhani + NunitoSans) |
| `app_theme.dart` | `AppTheme.buildDarkTheme()` — thème Material 3 sombre configuré pour l'app entière |

## Couleurs clés

- **Accent** `#FF6500` — orange tiré du logo officiel, utilisé pour les CTA et highlights
- **Primary** `#5C2BE2` — violet ninja, utilisé pour les lueurs et éléments secondaires
- **backgroundDeep** `#0D0D14` — fond quasi-noir de toutes les pages
- **rankGenin** `#7EABC9` / **rankJonin** `#9B59B6` / **rankKage** `#FF6500` — couleurs des niveaux d'abonnement
