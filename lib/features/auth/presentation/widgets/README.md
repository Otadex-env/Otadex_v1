# lib/features/auth/presentation/widgets/

Widgets spécifiques à la feature Auth, non réutilisés ailleurs.

## Contenu actuel

Dossier réservé aux futurs widgets auth (Task 02+) :

- `auth_error_banner.dart` — affichage des erreurs Firebase (email déjà utilisé, mauvais mdp…)
- `social_login_button.dart` — bouton générique pour les providers OAuth (Google, Apple…)
- `rank_selector_widget.dart` — sélecteur de rang initial lors de l'inscription

## Règle

Si un widget auth doit être réutilisé dans une autre feature, il migre vers `core/widgets/`.
