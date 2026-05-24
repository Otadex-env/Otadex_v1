# Design — Home grid limit + images hero + tri popularité

**Date:** 2026-05-24  
**Scope:** 3 corrections ciblées sur le home et le detail screen

---

## 1. Images en avant-plan (character_detail_screen.dart)

**Problème:** `_buildAnimatedImage()` (l.490) utilise `c.imagePath` seulement. Les personnages Firestore qui n'ont que `images[]` affichent la silhouette au lieu de leur image.

**Fix:** Remplacer `c.imagePath != null` → `_effectiveImages.isNotEmpty` et `c.imagePath!` → `_effectiveImages.first`. La méthode `_effectiveImages` existe déjà (l.55) et applique la priorité : assets locaux → `images[]` → `imagePath`.

**Fichier:** `lib/features/character/presentation/character_detail_screen.dart` (l.490–495)

---

## 2. Grille "Recommandés pour toi" — limite 6 cartes

**Problème:** `_buildGrid(chars)` rend toute la liste (peut dépasser 30 personnages). Le bouton "Voir tout" existe mais la grille home est trop longue.

**Fix:** Ajouter `maxItems` optionnel à `_buildGrid`. Dans `CharacterGridSection.build`, passer `maxItems: 6` pour la section Recommandés ET pour Nouveautés. Le `onAction` (Voir tout) continue de passer la liste complète à `CharacterListScreen`.

**Fichier:** `lib/features/home/presentation/widgets/character_grid_section.dart`

---

## 3. Tri par popularité (likes décroissants)

**Problème:** `recommendedCharactersProvider` et `newCharactersProvider` filtrent mais ne trient pas — l'ordre est celui de Firestore (popularityRank ASC de la query). Les personnages populaires ne sont pas forcément en tête de la grille home.

**Fix:** Après le filtrage dans les deux providers, ajouter un sort `(a, b) => b.likes.compareTo(a.likes)`. Résultat : les plus likés apparaissent en premier dans la grille home ET dans "Voir tout".

**Fichier:** `lib/core/providers/otadex_providers.dart`

---

## Fichiers modifiés

| Fichier | Changement |
|---------|-----------|
| `character_detail_screen.dart` | `_buildAnimatedImage` → `_effectiveImages` |
| `character_grid_section.dart` | `_buildGrid(maxItems: 6)` pour les 2 sections |
| `otadex_providers.dart` | Sort likes desc dans recommended + new providers |

## Non modifié

- `CharacterListScreen` — affiche déjà toute la liste passée en extra
- `firestore_character_service.dart` — mapping correct
- `Character` model — `likes` et `images` déjà présents
