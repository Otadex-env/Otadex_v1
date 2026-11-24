# Character Narrative Role Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a curated narrative-role classification (protagoniste, antagoniste, deutéragoniste, anti-héros, rival, mentor, allié, secondaire) to characters, surfaced in the UI with spoiler protection and filterable in the character list and search.

**Architecture:** A new fixed vocabulary (mirrored Dart/JS, same pattern as `genres.js`/`genre_catalog.dart`) backs three new Firestore/`Character` fields (`role`, `roleNote`, `roleSpoiler`). The existing `Character.role` field (which actually holds the free-text "rang"/occupation, e.g. "Capitaine de la 6e division") is renamed to `Character.occupation` first to free the name for its new, narrower meaning. UI additions (badge, grid chip, filter chips) are additive widgets wired into existing screens; no existing screen is restructured. Two Node scripts extend the existing automation: `setup_anime.js` detects role for new imports, and a new `migrate_roles.js` (dry-run-first, mirroring `normalize_genres.js`) backfills the 6 anime imported before this feature existed.

**Tech Stack:** Flutter/Dart (Riverpod, go_router, cloud_firestore), Node.js (firebase-admin) import/migration scripts.

**Spec:** User-provided spec, inlined below (no separate file existed before this plan — this plan is the spec's only written form besides the original chat message).

```
RÈGLE : AppColors uniquement, aucune Color() hardcodée.
Source de données : Firestore uniquement. Ne jamais réintroduire AniList.

OBJECTIF : ajouter la notion de rôle narratif (protagoniste,
antagoniste, etc.) aux personnages.

1 — MODÈLE ET FIRESTORE
Ajouter au modèle Character et au mapping Firestore :
  - role : un seul rôle principal parmi : protagoniste,
    antagoniste, deutéragoniste, anti-héros, rival, mentor,
    allié, secondaire
  - roleNote : texte court optionnel décrivant l'évolution
    du rôle (ex. "Rival puis allié")
  Si le champ est absent → valeur par défaut "secondaire",
  sans crash. Le rôle n'est PAS le camp moral : ne pas
  mélanger avec un éventuel champ d'alignement.

2 — PIPELINE D'IMPORT
Mettre à jour setup_anime.js (et le modèle de import_[slug].js
généré) pour lire le rôle depuis le .docx : détecter la mention
de rôle de chaque personnage, la normaliser vers l'une des
valeurs ci-dessus, garder le texte brut dans roleNote si
plusieurs rôles sont cités. Si rien n'est détecté → "secondaire"
et afficher un avertissement listant ces personnages.
Mettre à jour naming.js seulement si nécessaire.

3 — MIGRATION DES ANIMÉS EXISTANTS
Créer scripts/migrate_roles.js : pour les personnages déjà
dans Firestore (JJK, Naruto, Classroom, One Piece, Kuroko,
Mushoku Tensei), proposer un rôle à partir des données
existantes, écrire dans un fichier de revue (CSV ou JSON)
AVANT toute écriture, et n'écrire dans Firestore qu'après
ma validation. Utiliser le correctif d'horloge habituel.

4 — UI
  - Badge de rôle sur la fiche personnage (onglet Infos),
    couleurs via AppColors (protagoniste, antagoniste,
    autres rôles distincts mais sobres).
  - Petit badge sur les cards de la grille, discret.
  - Gestion des spoilers : le badge "antagoniste" peut
    révéler une intrigue. Ajouter un champ roleSpoiler
    (bool, défaut false). Si true, afficher le rôle masqué
    avec une action "Révéler".
  - Filtre par rôle dans "Voir tout" et dans la recherche
    (chips). Garder la pagination 20/20.

5 — DOCS ET QUALITÉ
Mettre à jour ANIME_WORKFLOW.md avec le nouveau champ.
Mettre à jour OTADEX_PROGRESS.md.
dart analyze lib/ → 0 erreur.
```

## Global Constraints

- AppColors only: every new color is an existing or newly-added **named token** in `lib/core/theme/app_colors.dart`; never an inline `Color(0x...)` outside that file.
- Firestore is the only data source; never add an AniList call for any of this feature's data.
- `role` is a narrative role, never a moral-alignment field — do not conflate it with any "camp"/alignment concept.
- Default on missing data is always `secondaire` (Dart) with no exception thrown, matching the spec's "sans crash" requirement — this differs from the existing `genres` pipeline, which throws (`normalizeGenresStrict`) on an unrecognized value. Role normalization is **lenient by design**: unrecognized/missing → `secondaire` + a listed warning, never a thrown error.
- Reuse existing `AppColors` tokens already defined (no new hex literals needed): `accent`, `accentDarkRed`, `accentRoyalBlue`, `accentDeepPurple`, `accentDeepOrange`, `accentIndigo`, `accentForestGreen`, `textSecondary`.
- Firestore pagination in "Voir tout" stays at exactly 20 items per page even when filtered by role (server-side `.where()`, not client-side slicing).

## Decisions the spec left open (resolved here)

1. **Name collision.** `Character.role` already exists and is populated from Firestore's `rang` field (free text like "Capitaine de la 6e division" — a title/occupation, not a narrative role). It's read in 6 places across the UI. Task 1 renames this field to `Character.occupation` (same Firestore source field `rang`, same behavior, just a clearer name) before introducing the new `role` with its new meaning. `CreatorEntry.role` and `MediaAppearanceMock.role` are unrelated models and are not touched.
2. **Badge placement on the character sheet.** The spec says "onglet Infos" — the Infos tab (`CharDetailInfosTab`), not the shared hero header that sits above all 5 tabs. The badge goes at the top of `CharDetailInfosTab.build()`, before `CharIdentityGrid`.
3. **Grid card scope.** "Cards de la grille" = `CharacterGridCard` (used in the Home grid, "Voir tout", search results, Collection). `TrendingCharacterCard` (the horizontal "Tendances" rail) is a different, non-grid widget and is out of scope — not mentioned in the spec and left untouched.
4. **Role filter chips are static, not content-derived.** Unlike genre chips (which only show genres present in the catalog), the 8 roles are a fixed curated enum — all 8 chips always render, consistent with them being a controlled vocabulary rather than per-anime data.
5. **Migration target anime IDs.** The spec names anime by display name ("JJK, Naruto, Classroom, One Piece, Kuroko, Mushoku Tensei"), not Firestore IDs. Confirmed from the codebase: `jujutsu-kaisen`, `naruto-shippuden`, `classroom-of-elite`, `mushoku-tensei` are literal `animeId` values used in `_configForAnime`. `one-piece` and the Kuroko no Basket ID are **not** found anywhere in the current codebase (their one-off import scripts no longer exist) — `migrate_roles.js` resolves these two by title match against the live `animes` collection at runtime (see Task 7) rather than a hardcoded guessed slug, and prints a clear miss/match report before writing anything.
6. **`naming.js`** needs no change — `toVarName()` is unrelated to role data (it only maps character names to Dart variable names for image asset lists).

## Review Focus

- A Firestore character doc missing `role`/`roleNote`/`roleSpoiler` entirely (every character imported before this feature) must render as `secondaire`, no note, not spoiler-hidden — not throw, not show `null`.
- A character doc with an unrecognized free-text `role` value (e.g. a typo, or a value from before the vocabulary was locked) must fall back to `secondaire` in the UI rather than crash the mapping layer.
- `roleSpoiler: true` with `role: "antagoniste"` must render the masked/"Révéler" state everywhere the role is shown (Infos tab badge, grid card), not just one of them.
- Selecting a role filter chip in "Voir tout" with zero matching characters must show the existing empty/`_hasMore == false` state, not an infinite loader or a crash on `lastDoc`.
- `setup_anime.js`'s per-character role detection must still produce a usable (non-throwing) result when a `.docx` character block has **no** role-related text anywhere — this is the common case for minor/secondary characters, not an edge case.

---

### Task 1: Rename `Character.role` → `Character.occupation`; add `role`/`roleNote`/`roleSpoiler`

**Files:**
- Modify: `lib/core/models/character.dart`
- Modify: `lib/core/services/firestore_character_service.dart:232-310` (`_characterFromFirestore`)
- Modify: `lib/features/character/presentation/widgets/char_identity_grid.dart:29`
- Modify: `lib/features/character/presentation/widgets/char_medias_tab.dart:260`
- Modify: `lib/features/anime/presentation/anime_detail_screen.dart:503-510`
- Modify: `lib/features/search/presentation/search_screen.dart:2018`
- Create: `lib/core/constants/role_catalog.dart`
- Test: `test/role_catalog_test.dart`

**Interfaces:**
- Produces: `enum NarrativeRole { protagoniste, antagoniste, deuteragoniste, antiHero, rival, mentor, allie, secondaire }` in `role_catalog.dart`, plus `NarrativeRole narrativeRoleFromFirestore(String? raw)` (never throws, defaults to `secondaire`), `String narrativeRoleToFirestore(NarrativeRole r)` (inverse mapping — the canonical French string written back to Firestore, e.g. `antiHero` → `"anti-héros"`), `String narrativeRoleLabel(NarrativeRole r)` (French display label, e.g. `antiHero` → `"Anti-héros"`), `Color narrativeRoleColor(NarrativeRole r)` (returns one of the `AppColors` tokens listed in Global Constraints).
- Produces: `Character.occupation` (`String?`, replaces old `Character.role`), `Character.role` (`NarrativeRole`, non-nullable, defaults `NarrativeRole.secondaire`), `Character.roleNote` (`String?`), `Character.roleSpoiler` (`bool`, defaults `false`).
- Consumes (Task 2, 3 depend on this): the five items above. (Task 4 also depends on `narrativeRoleToFirestore`.)

- [ ] **Step 1: Write the failing test for the catalog mapping**

```dart
// test/role_catalog_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:otadex/core/constants/role_catalog.dart';

void main() {
  group('narrativeRoleFromFirestore', () {
    test('known values map correctly', () {
      expect(narrativeRoleFromFirestore('protagoniste'), NarrativeRole.protagoniste);
      expect(narrativeRoleFromFirestore('anti-héros'), NarrativeRole.antiHero);
    });
    test('null, empty, or unknown falls back to secondaire', () {
      expect(narrativeRoleFromFirestore(null), NarrativeRole.secondaire);
      expect(narrativeRoleFromFirestore(''), NarrativeRole.secondaire);
      expect(narrativeRoleFromFirestore('nonsense'), NarrativeRole.secondaire);
    });
  });

  test('every role has a non-empty label and a color', () {
    for (final r in NarrativeRole.values) {
      expect(narrativeRoleLabel(r), isNotEmpty);
      expect(narrativeRoleColor(r), isNotNull);
    }
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run: `flutter test test/role_catalog_test.dart`
Expected: FAIL — `role_catalog.dart` does not exist yet (`Error: Error when reading 'lib/core/constants/role_catalog.dart'`).

- [ ] **Step 3: Create `lib/core/constants/role_catalog.dart`**

Mirror the structure of `lib/core/constants/genre_catalog.dart` for the doc comment/library style, but this vocabulary is lenient (never throws) rather than strict. Canonical values and order, exactly as the spec lists them: `protagoniste`, `antagoniste`, `deutéragoniste`, `anti-héros`, `rival`, `mentor`, `allié`, `secondaire`. `narrativeRoleFromFirestore` lowercases/trims and matches against the French strings (accept `deuteragoniste`/`antihero` as accent-insensitive aliases of the same enum values — same `keyOf`-style normalization as `genres.js`, not a body the signature determines on its own, so: strip accents, lowercase, strip non-alphanumerics, then look up). Color mapping (fixed, from Global Constraints):
`protagoniste` → `AppColors.accent`, `antagoniste` → `AppColors.accentDarkRed`, `deuteragoniste` → `AppColors.accentRoyalBlue`, `antiHero` → `AppColors.accentDeepPurple`, `rival` → `AppColors.accentDeepOrange`, `mentor` → `AppColors.accentIndigo`, `allie` → `AppColors.accentForestGreen`, `secondaire` → `AppColors.textSecondary`. `narrativeRoleToFirestore` is the exact inverse of `narrativeRoleFromFirestore`'s canonical (non-alias) strings — `protagoniste`→`"protagoniste"`, `deuteragoniste`→`"deutéragoniste"`, `antiHero`→`"anti-héros"`, `allie`→`"allié"`, etc.

- [ ] **Step 4: Run test to verify it passes**

Run: `flutter test test/role_catalog_test.dart`
Expected: PASS

- [ ] **Step 5: Rename `Character.role` to `Character.occupation`**

In `lib/core/models/character.dart`: rename the field (and constructor parameter) `role` → `occupation`, and in `Character.fromJson`, change `role: json['role'] as String?,` → `occupation: json['role'] as String?,` (same JSON key, mock data is unaffected). Do not touch `CreatorEntry.role` or `MediaAppearanceMock.role` — different classes.

- [ ] **Step 6: Add the new role fields to `Character`**

Same file: add `final NarrativeRole role;` (default via constructor `this.role = NarrativeRole.secondaire`), `final String? roleNote;`, `final bool roleSpoiler;` (default `false`). Import `role_catalog.dart`. In `Character.fromJson`, read `role: narrativeRoleFromFirestore(json['role'] as String?), roleNote: json['roleNote'] as String?, roleSpoiler: json['roleSpoiler'] as bool? ?? false,` (mock JSON data simply won't have these keys yet — the defaults apply, per Review Focus).

- [ ] **Step 7: Update the 4 call sites of the old `Character.role`**

- `firestore_character_service.dart:297`: `role: rang,` → `occupation: rang, role: narrativeRoleFromFirestore(d['role'] as String?), roleNote: d['roleNote'] as String?, roleSpoiler: d['roleSpoiler'] as bool? ?? false,`
- `char_identity_grid.dart:29`: `c.status ?? c.role` → `c.status ?? c.occupation`
- `char_medias_tab.dart:260`: `char.role ?? ''` → `char.occupation ?? ''`
- `anime_detail_screen.dart:503-510`: `character.role` → `character.occupation` (both occurrences, the `!= null` check and the `CharPill` argument)
- `search_screen.dart:2018`: `c.role` → `c.occupation` (both occurrences on that line)

- [ ] **Step 8: Run `dart analyze` and the full test suite**

Run: `dart analyze lib/ test/`
Expected: `No issues found!`
Run: `flutter test`
Expected: all tests PASS (including the pre-existing `search_match_test.dart` and `widget_test.dart`, unaffected by this change).

- [ ] **Step 9: Commit**

```bash
git add lib/core/models/character.dart lib/core/constants/role_catalog.dart \
  lib/core/services/firestore_character_service.dart \
  lib/features/character/presentation/widgets/char_identity_grid.dart \
  lib/features/character/presentation/widgets/char_medias_tab.dart \
  lib/features/anime/presentation/anime_detail_screen.dart \
  lib/features/search/presentation/search_screen.dart \
  test/role_catalog_test.dart
git commit -m "feat(character): add narrative role field, rename old role to occupation"
```

---

### Task 2: Role badge on the character sheet (Infos tab), with spoiler reveal

**Files:**
- Create: `lib/features/character/presentation/widgets/char_role_badge.dart`
- Modify: `lib/features/character/presentation/widgets/char_infos_tab.dart` (`build()`, around line 51-65)

**Interfaces:**
- Consumes: `Character.role`, `.roleNote`, `.roleSpoiler` (Task 1); `narrativeRoleLabel`/`narrativeRoleColor` (Task 1).
- Produces: `CharRoleBadge` widget — `const CharRoleBadge({required Character character})`. No other task depends on this widget's internals (Task 3's grid badge is visually similar but intentionally separate/smaller — not shared, per Task 3's own file).

- [ ] **Step 1: Build `CharRoleBadge` as a `StatefulWidget`**

Visual reference: the pill style already used in `char_relations_tab.dart`'s `_RelationCard` badge (rounded pill, `color.withValues(alpha: 0.20)` background, `color.withValues(alpha: 0.55)` border, colored text) — reuse that look, not `CharPill` (which has no room for an icon + optional note + tap target). Default state: a pill showing an icon (reuse `Icons.theater_comedy_rounded` or similar single icon for all roles — the spec asks for color differentiation, not per-role icons) + `narrativeRoleLabel(character.role)`, tinted with `narrativeRoleColor(character.role)`. If `character.roleNote` is non-empty, render it as a smaller secondary line under/after the label (e.g. "Rival puis allié"). If `character.roleSpoiler` is `true`: initial state shows a masked pill ("Rôle masqué" + a lock icon, neutral `AppColors.textSecondary` tint, no role color leak) with a tappable "Révéler" affordance; tapping flips local `_revealed` state to show the real badge (same as the non-spoiler rendering) — this is local UI state, nothing is written back to Firestore or to any provider.

- [ ] **Step 2: Wire it into `CharDetailInfosTab`**

In `char_infos_tab.dart`, add `CharRoleBadge(character: c)` as the first child of the `Column` in `build()`, before `CharIdentityGrid(character: c)`, wrapped in the same `EdgeInsets.fromLTRB(16, ..)` horizontal padding convention used by the sibling sections in this file.

- [ ] **Step 3: Manual verification (no widget-test harness exists for this screen)**

Run the app (`flutter run`), open a character detail screen for a character with `role` unset (any pre-existing character) and confirm it renders "Secondaire" in the neutral `textSecondary` tint and does not crash. Then, using any Firestore console or a throwaway local edit, set one character's `role` to `"antagoniste"` and `roleSpoiler` to `true`: confirm the Infos tab shows the masked/"Révéler" state (no "Antagoniste" text, no red tint visible before tapping), and that tapping "Révéler" flips it to the real badge — this is the Review Focus case that must never leak. This file has no existing widget tests for the Infos tab to extend — do not add a Flutter widget test here; this task's correctness gate is `dart analyze` plus this manual check, consistent with how `char_infos_tab.dart`'s other sections are verified in this codebase.

- [ ] **Step 4: Run `dart analyze`**

Run: `dart analyze lib/`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/features/character/presentation/widgets/char_role_badge.dart \
  lib/features/character/presentation/widgets/char_infos_tab.dart
git commit -m "feat(character): add role badge with spoiler reveal to the Infos tab"
```

---

### Task 3: Discreet role indicator on grid cards

**Files:**
- Modify: `lib/features/home/presentation/widgets/character_grid_card.dart`

**Interfaces:**
- Consumes: `Character.role`, `.roleSpoiler`, `narrativeRoleColor` (Task 1).
- Produces: nothing consumed elsewhere — self-contained visual addition.

- [ ] **Step 1: Add a small corner indicator**

In the `Stack` inside `CharacterGridCard.build()` (around line 64-251), add one more `Positioned` child: a small (≈8-10px) filled circle or short pill in `character.accentColor`-independent `narrativeRoleColor(character.role)`, placed at `top: 8, right: 8` (the existing `isNew` badge occupies `top: 8, left: 8`; the collection-bookmark button already occupies `top: 10, right: 10` at 44×44 — place this indicator at `top: 8, right: 54` so it sits just left of the bookmark button's tap target, never overlapping it). Render nothing for `NarrativeRole.secondaire` (the default/no-signal case — keeps the common case visually clean, "discret" per the spec). If `character.roleSpoiler` is `true`, render the neutral/locked variant (a small lock glyph in `AppColors.textSecondary`), never the real role color — the card must never leak a spoiler-flagged role.

- [ ] **Step 2: Manual verification**

Run the app, confirm on the Home grid that: a character with `role: protagoniste` shows the small orange dot, a character with no role data shows nothing extra, nothing visually collides with the existing NEW badge or bookmark icon at common screen widths (360-430dp), and — using the same `roleSpoiler: true` + `role: "antagoniste"` test character from Task 2 — the grid card shows only the neutral lock glyph, never the red antagoniste tint (same leak this must not have, on the card this time instead of the Infos tab).

- [ ] **Step 3: Run `dart analyze`**

Run: `dart analyze lib/`
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/features/home/presentation/widgets/character_grid_card.dart
git commit -m "feat(character): add discreet role indicator to grid cards"
```

---

### Task 4: Role filter chips + server-side filtering in "Voir tout"

**Files:**
- Create: `lib/features/character/presentation/widgets/role_filter_chips.dart`
- Modify: `lib/core/services/firestore_character_service.dart:41-66` (`getCharactersPaginated`)
- Modify: `lib/features/character/presentation/character_list_screen.dart`
- Modify: `firestore.indexes.json`

**Interfaces:**
- Consumes: `NarrativeRole`, `narrativeRoleLabel`, `narrativeRoleColor` (Task 1).
- Produces: `RoleFilterChips` widget — `const RoleFilterChips({NarrativeRole? selected, required ValueChanged<NarrativeRole?> onSelect})` (Task 5 reuses this exact widget/signature for search). `FirestoreCharacterService.getCharactersPaginated({int limit, DocumentSnapshot? lastDocument, NarrativeRole? role})` — new optional `role` parameter, `null` behaves exactly as today.

- [ ] **Step 1: Add the composite Firestore index**

In `firestore.indexes.json`, add to the `characters` collection group indexes:
```json
{
  "collectionGroup": "characters",
  "queryScope": "COLLECTION",
  "fields": [
    { "fieldPath": "role", "order": "ASCENDING" },
    { "fieldPath": "popularityRank", "order": "ASCENDING" }
  ]
}
```

- [ ] **Step 2: Extend `getCharactersPaginated`**

In `firestore_character_service.dart`, add `NarrativeRole? role` param. When non-null, insert `.where('role', isEqualTo: narrativeRoleToFirestore(role))` into the query chain before `.orderBy('popularityRank')` (add `String narrativeRoleToFirestore(NarrativeRole r)` to `role_catalog.dart` — the inverse of `narrativeRoleFromFirestore`, returning the canonical French string written by the import/migration scripts). Everything else in the method (the `limit + 1` / `hasMore` pagination logic) is unchanged — this is what keeps pagination at exactly 20 per page under a role filter.

- [ ] **Step 3: Build `RoleFilterChips`**

Visual reference: `category_chips.dart`'s `_GenreChip` (outline chip, filled+bordered when selected). Render one chip per `NarrativeRole.values` in enum declaration order, each labeled via `narrativeRoleLabel` and tinted via `narrativeRoleColor` when selected (unselected state stays neutral, matching `_GenreChip`'s `theme.textSecondary`/`theme.borderSubtle` unselected look) — no "Tous" chip is needed since `selected == null` is represented by none of the per-role chips being active; add one leading "Tous" chip that calls `onSelect(null)` for symmetry with `category_chips.dart`'s pattern.

- [ ] **Step 4: Wire into `CharacterListScreen`**

Add `NarrativeRole? _selectedRole;` state. Render `RoleFilterChips(selected: _selectedRole, onSelect: _onRoleSelected)` between the existing title `Row` and the `Expanded(CustomScrollView(...))`. `_onRoleSelected(role)` resets pagination state (`_characters.clear(); _lastDocument = null; _hasMore = true; _initialLoaded = false;`) and calls `_loadMore()` with the new role captured, then calls `setState`. Pass `role: _selectedRole` through to every `_service.getCharactersPaginated(...)` call in `_loadMore()`.

- [ ] **Step 5: Manual verification**

Run the app, open "Voir tout", select each role chip in turn, confirm the grid reloads with at most 20 items per scroll batch and the "Tous les personnages chargés" footer still appears correctly when a filtered role runs out of matches (Review Focus item: zero-match role must not infinite-spin).

- [ ] **Step 6: Run `dart analyze`**

Run: `dart analyze lib/`
Expected: `No issues found!`

- [ ] **Step 7: Commit**

```bash
git add lib/features/character/presentation/widgets/role_filter_chips.dart \
  lib/core/services/firestore_character_service.dart \
  lib/features/character/presentation/character_list_screen.dart \
  firestore.indexes.json
git commit -m "feat(character): filter 'Voir tout' by narrative role"
```

---

### Task 5: Role filter chips in search

**Files:**
- Modify: `lib/features/search/presentation/search_screen.dart`

**Interfaces:**
- Consumes: `RoleFilterChips` (Task 4), `NarrativeRole` (Task 1).
- Produces: nothing consumed elsewhere.

- [ ] **Step 1: Add role filter state**

Add `NarrativeRole? _selectedRoleFilter;` alongside the existing `_selectedSubFilter` field (around line 79).

- [ ] **Step 2: Apply it in `_filteredCharacters`**

In both branches of `_filteredCharacters` (the AniList-results branch around line 180-185 and the local-catalog branch around line 190-202), add `&& (_selectedRoleFilter == null || c.role == _selectedRoleFilter)` to the existing filter predicates. This is character-only — `_filteredAnimes` and `_filteredCreators` are untouched (role doesn't apply to animes/creators).

- [ ] **Step 3: Render the chips in the results panel**

In `_buildResultsContent` (line 1572), render `RoleFilterChips(selected: _selectedRoleFilter, onSelect: (r) => setState(() => _selectedRoleFilter = r))` only when characters are a relevant result type (`_selectedFilter == 0 || _selectedFilter == 1`), placed alongside the existing "Catégorie : $_selectedSubFilter" indicator block (around line 1593-1620) — same `Padding`/row conventions.

- [ ] **Step 4: Manual verification**

Search for a common term, toggle role chips, confirm the character result list narrows and the "autres personnages" see-more count updates accordingly.

- [ ] **Step 5: Run `dart analyze`**

Run: `dart analyze lib/`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/search/presentation/search_screen.dart
git commit -m "feat(search): filter character results by narrative role"
```

---

### Task 6: Role detection in the import pipeline (`setup_anime.js`)

**Files:**
- Create: `scripts/anime_workflow/roles.js`
- Create: `scripts/anime_workflow/roles.test.js`
- Modify: `scripts/setup_anime.js` (`parseText`, `generateImportScript`)

**Interfaces:**
- Produces: `ROLES` (ordered array of the 8 canonical French role strings), `normalizeRole(raw)` (exact/alias match → canonical string or `null`), `detectRole(text)` (scans free text for any canonical role or alias as a whole/partial word match, returns `{ role: string, matches: string[] }` — `matches` has every distinct role found, for the `roleNote` "multiple roles cited" case; `role` is `matches[0]` or `'secondaire'` if `matches` is empty).
- Consumes (Task 7 reuses `normalizeRole`/`ROLES`): same two exports.

- [ ] **Step 1: Write the failing test**

```js
// scripts/anime_workflow/roles.test.js — plain Node assertions, no test framework (none installed in this project)
const assert = require('assert');
const { ROLES, normalizeRole, detectRole } = require('./roles');

assert.deepStrictEqual(normalizeRole('Protagoniste'), 'protagoniste');
assert.deepStrictEqual(normalizeRole('antihero'), 'anti-héros');
assert.strictEqual(normalizeRole('nonsense'), null);

const single = detectRole('Protagoniste de la série, elle mène le groupe.');
assert.deepStrictEqual(single, { role: 'protagoniste', matches: ['protagoniste'] });

const multi = detectRole('Rival de longue date, devenu allié dans le dernier arc.');
assert.deepStrictEqual(multi.matches, ['rival', 'allié']);

const none = detectRole('Camarade de classe discret, apparaît dans quelques scènes.');
assert.deepStrictEqual(none, { role: 'secondaire', matches: [] });

console.log('roles.test.js: all assertions passed');
```

- [ ] **Step 2: Run test to verify it fails**

Run: `node scripts/anime_workflow/roles.test.js`
Expected: FAIL — `Cannot find module './roles'`

- [ ] **Step 3: Create `scripts/anime_workflow/roles.js`**

Mirror `scripts/anime_workflow/genres.js`'s structure (`keyOf` accent/case/punctuation-insensitive key, an `ALIAS_SOURCE` map, a `LOOKUP` built from canonical + aliases) but export the lenient `detectRole` instead of a throwing `normalizeStrict` — this vocabulary never fails an import. `ROLES = ['protagoniste', 'antagoniste', 'deutéragoniste', 'anti-héros', 'rival', 'mentor', 'allié', 'secondaire']`. Aliases: `antagonist→antagoniste`, `deuteragoniste→deutéragoniste` (no-accent variant), `antihero`/`anti hero`/`antiheros→anti-héros`, `rivale→rival`, `mentore→mentor`, `alliee`/`allie→allié`, `héros`/`heroine`/`héroïne→protagoniste`, `vilain`/`méchant principal→antagoniste`. `detectRole(text)` lowercases via `keyOf` and checks, for each canonical role (in `ROLES` order, excluding `secondaire`), whether its own key or any alias key appears as a substring of the keyed text; collects every role that matched (preserving `ROLES` order) into `matches`, returns `{ role: matches[0] ?? 'secondaire', matches }`.

- [ ] **Step 4: Run test to verify it passes**

Run: `node scripts/anime_workflow/roles.test.js`
Expected: `roles.test.js: all assertions passed`

- [ ] **Step 5: Add `ROLE:` field support to `setup_anime.js`'s parser**

In `parseText()` (around line 141-163), add a case in the per-character field switch: `case 'ROLE': currentChar.role = value.trim(); currentChar.roleNote = null; break;` (an explicit `ROLE:` line in the `.docx` always wins, verbatim, normalized through `normalizeRole`; if `normalizeRole` returns `null` for an explicit `ROLE:` value, keep the raw text in `roleNote` and fall through to detection below rather than silently discarding what the author wrote).

- [ ] **Step 6: Add detection fallback for characters without an explicit `ROLE:` line**

After the per-character loop that currently fills missing defaults (around line 178-188, where `c.statut`/`c.pouvoirs`/etc. get defaults), add: if `c.role` is still unset, run `detectRole(`${c.rang ?? ''} ${c.description ?? ''}`)`; set `c.role = result.role`; if `result.matches.length > 1`, set `c.roleNote = result.matches.join(' puis ')` (e.g. `"rival puis allié"`, matching the spec's own example wording style); collect the character's name into a `charactersWithoutRole` list when `result.matches.length === 0` (i.e. it fell back to `secondaire` with zero signal). After processing all characters, if that list is non-empty, print one warning line listing them (e.g. `⚠️  Rôle non détecté (secondaire par défaut) : Name1, Name2, ...`) — this must not stop the import (Global Constraints: lenient).

- [ ] **Step 7: Include role in the generated `import_[prefix].js`**

In `generateImportScript()` (around line 342-372, the per-character `charsCode` template), add `role: ${JSON.stringify(c.role || 'secondaire')}, roleNote: ${JSON.stringify(c.roleNote || null)},` to the generated character `data` object, right next to the existing `rang`/`popularityRank` fields.

- [ ] **Step 8: Run the JS test and `node --check` the modified file**

Run: `node scripts/anime_workflow/roles.test.js && node --check scripts/setup_anime.js`
Expected: test passes; syntax check produces no output (success).

- [ ] **Step 9: Commit**

```bash
git add scripts/anime_workflow/roles.js scripts/anime_workflow/roles.test.js scripts/setup_anime.js
git commit -m "feat(import): detect and normalize narrative role from anime docx"
```

---

### Task 7: `scripts/migrate_roles.js` — review-first migration for the 6 pre-existing anime

**Files:**
- Create: `scripts/migrate_roles.js`

**Interfaces:**
- Consumes: `ROLES`, `normalizeRole`, `detectRole` (Task 6).
- Produces: a review file at `scripts/migrate_roles_review.json` (default run) and, only on `--apply` reading that same file back, Firestore writes to `characters/{id}`.

- [ ] **Step 1: Define the target anime list with runtime resolution**

```js
const TARGET_ANIME = [
  { label: 'Jujutsu Kaisen', id: 'jujutsu-kaisen' },
  { label: 'Naruto Shippuden', id: 'naruto-shippuden' },
  { label: 'Classroom of the Elite', id: 'classroom-of-elite' },
  { label: 'Mushoku Tensei', id: 'mushoku-tensei' },
  { label: 'One Piece', id: null },   // resolved by title match, see Step 2
  { label: 'Kuroko no Basket', id: null },
];
```

- [ ] **Step 2: Resolve the two `id: null` entries against the live `animes` collection**

Query `db.collection('animes').get()`, find a doc whose `titre` field case/accent-insensitively contains "one piece" or "kuroko", fill in that entry's `id`. For any `TARGET_ANIME` entry still unresolved after this (neither a hardcoded id found nor a title match), print `❌  "<label>" introuvable dans animes/ — ignoré` and exclude it from the rest of the run rather than crashing.

- [ ] **Step 3: For each resolved anime, propose a role per character**

For every `characters` doc with that `animeId`: skip it if it already has a `role` field (idempotent re-runs). Otherwise call `detectRole(`${doc.rang ?? ''} ${doc.description ?? ''}`)` (same function Task 6 uses), producing `{ proposedRole, proposedRoleNote, matchedFrom: 'rang+description' }`.

- [ ] **Step 4: Write the review file, make zero Firestore writes, and stop (default mode)**

Write `scripts/migrate_roles_review.json`: `{ "generatedAt": "<ISO timestamp>", "characters": [ { "id": ..., "nom": ..., "animeId": ..., "currentRang": ..., "proposedRole": ..., "proposedRoleNote": ... }, ... ] }`. Print a summary count per anime and per proposed role. Print, in the same run, `Revue écrite dans scripts/migrate_roles_review.json — édite ce fichier si besoin, puis relance avec --apply pour écrire dans Firestore.` and exit **without** touching Firestore writes (reads only, to enumerate characters).

- [ ] **Step 5: `--apply` reads the (possibly hand-edited) review file and writes it**

Gate behind `--apply` (reject if both `--apply` and no existing review file are present: `❌  scripts/migrate_roles_review.json introuvable — lance d'abord le script sans --apply.`). Before writing, save a backup exactly like `normalize_genres.js` does: `scripts/backups/roles_backup_<timestamp>.json` containing, per character id, its state *before* the write (in this case: absence of the field, i.e. `{}`, since none of these 6 anime currently have a `role` field — this still gives a restorable record of "which ids were touched"). Then batch-`update()` (not `set()`, to avoid touching any other field) each character doc from the review file's (possibly user-edited) `proposedRole`/`proposedRoleNote` into `role`/`roleNote`. Print a per-anime success count.

- [ ] **Step 6: Document the clock-skew requirement in the file header**

```js
/**
 * migrate_roles.js — Backfill narrative `role` for characters imported
 * before this field existed (JJK, Naruto Shippuden, Classroom of the Elite,
 * One Piece, Kuroko no Basket, Mushoku Tensei).
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     node scripts/migrate_roles.js                 (revue seule, aucune écriture)
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     node scripts/migrate_roles.js --apply          (écrit scripts/migrate_roles_review.json dans Firestore)
 */
```

- [ ] **Step 7: Dry run against the real project and report back**

Run: `env NODE_OPTIONS='--require ./scripts/google_time_offset.js' node scripts/migrate_roles.js`
Expected: `scripts/migrate_roles_review.json` is created; no Firestore write occurs; the per-anime match/miss report (Step 2) and the proposed-role counts (Step 4) are shown for the user to review. **Do not run with `--apply` as part of this task** — that write happens only after the user has reviewed/edited the file and said so, per the spec's "n'écrire qu'après ma validation."

- [ ] **Step 8: Commit**

```bash
git add scripts/migrate_roles.js
git commit -m "feat(migration): add review-first narrative role backfill for pre-existing anime"
```

(The generated `scripts/migrate_roles_review.json` and any `scripts/backups/roles_backup_*.json` are run artifacts, not source — do not commit them; confirm they're covered by the existing `scripts/backups/`-style `.gitignore` entry or add one if missing.)

---

### Task 8: Docs and final verification

**Files:**
- Modify: `ANIME_WORKFLOW.md`
- Modify: `OTADEX_PROGRESS.md`

**Interfaces:**
- Consumes: nothing code-level: this task is documentation + a final whole-project check.

- [ ] **Step 1: Document the new field in `ANIME_WORKFLOW.md`**

Add `role` and `roleNote` rows to the "Structure complète du document" character JSON example (Étape 6) and to the "Champs obligatoires minimum" table — mark both optional, default `"secondaire"` / absent. Add one line to the "Valeurs de `type` dans `relations`" area's sibling section (new subsection) listing the 8 canonical `role` values and noting it is a **separate** vocabulary from `relations[].type`, consistent with Global Constraint "not the moral alignment field."

- [ ] **Step 2: Add an `OTADEX_PROGRESS.md` entry**

Append a new dated task entry (next number after the current highest `Task N`) summarizing: renamed `Character.role`→`occupation`; added `role`/`roleNote`/`roleSpoiler`; new `role_catalog.dart` + `scripts/anime_workflow/roles.js`; badge in Infos tab + grid card indicator + filter chips in "Voir tout" and search; `setup_anime.js` role detection; `migrate_roles.js` created (review-first, not yet applied — pending user validation); `dart analyze lib/` → 0 erreur. Follow the terse, file-by-file bullet style already used by the existing entries in this file (see Task 60/61/62 for the exact voice/format to match).

- [ ] **Step 3: Final whole-project check**

Run: `dart analyze lib/`
Expected: `No issues found!`
Run: `flutter test`
Expected: all tests PASS.
Run: `node scripts/anime_workflow/roles.test.js`
Expected: `roles.test.js: all assertions passed`

- [ ] **Step 4: Commit**

```bash
git add ANIME_WORKFLOW.md OTADEX_PROGRESS.md
git commit -m "docs: document narrative role field in workflow and progress logs"
```

- [ ] **Step 5: Print the manual-actions summary for the user**

At the end of this task, state explicitly (this is the plan's own closing instruction, not a code step):
1. `scripts/migrate_roles.js` has been run in review mode only — `scripts/migrate_roles_review.json` exists and is waiting for the user's review/edits before anyone runs `--apply`.
2. If any of the 6 target anime failed to resolve an `animeId` (Task 7, Step 2's miss report), those anime got **no** proposed roles and need a manual fix (either add the id to `TARGET_ANIME` or confirm the anime's real Firestore id) before a meaningful `--apply`.
3. The new Firestore composite index (`role` + `popularityRank`) must be deployed (`firebase deploy --only firestore:indexes`, or via the Firebase Console) before the role filter in "Voir tout" (Task 4) will work against production data — until then, that specific filtered query will fail at runtime with a "missing index" error from Firestore (the UI will show its existing empty-state, not crash, but will show zero results for every role).
