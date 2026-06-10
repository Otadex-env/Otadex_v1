# Workflow — Ajout d'un nouvel animé sur OTADEX

Guide complet : de la création des dossiers jusqu'à la mise en ligne Firebase.

---

## Vue d'ensemble des étapes

```
otadex-assets (GitHub)          Otadex_v1 (Flutter)             Firebase
─────────────────────           ──────────────────────          ────────
1. Créer dossiers images   →    3. app_assets.dart          →   5. Firestore : animés
2. Nommer / uploader images     4. firestore_character_service  6. Firestore : personnages
                                                             →   7. Vérification finale
```

---

## Étape 1 — Repo `otadex-assets` : structure des dossiers

**Dépôt** : `https://github.com/Otadex-env/otadex-assets`

### Arborescence à créer

```
Animé pictures/
└── [Nom complet de l'animé]/          ← ex: "My Hero Academia"
    ├── [Personnage 1]/                ← ex: "Izuku Midoriya"
    │   ├── [prefix]_[slug]1.jpeg
    │   ├── [prefix]_[slug]2.jpeg
    │   └── ...
    ├── [Personnage 2]/
    │   └── ...
    └── ...
```

### Convention de nommage

| Élément        | Règle                                          | Exemple                        |
| -------------- | ---------------------------------------------- | ------------------------------ |
| Dossier animé  | Nom officiel, espaces autorisés                | `My Hero Academia`             |
| Dossier perso  | Nom complet du personnage, casse mixte         | `Izuku Midoriya`               |
| Préfixe images | 2-3 lettres initiales de l'animé + `_`         | `mha_` (My Hero Academia)      |
| Fichier image  | `[prefix][slug][numéro].jpeg`                  | `mha_izuku1.jpeg`              |
| Format images  | JPEG uniquement, nommage séquentiel depuis `1` | `mha_izuku1.jpeg` ... `N.jpeg` |

### Préfixes existants (à ne pas réutiliser)

| Animé                  | Préfixe |
| ---------------------- | ------- |
| Jujutsu Kaisen         | `jj_`   |
| Naruto Shippuden       | `ns_`   |
| Classroom of the Elite | `clk_`  |
| One Piece              | `op_`   |
| Kuroko no Basket       | `knb_`  |
| Fullmetal Alchemist    | `fma_`  |
| Hunter x Hunter        | `hxh_`  |

### Upload

1. Cloner ou ouvrir le repo `otadex-assets` localement
2. Créer les dossiers `Animé pictures/[Nom animé]/[Nom personnage]/`
3. Déposer les images (minimum 4 par personnage, idéal 8-13)
4. `git add . && git commit -m "feat: add [Nom animé] images" && git push`
5. Attendre ~2 min que GitHub CDN indexe les fichiers raw

---

## Étape 2 — URL de base GitHub Raw

L'URL raw suit toujours ce pattern :

```
https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/[Dossier animé]/[Dossier personnage]/[fichier].jpeg
```

⚠️ Les espaces dans les noms de dossiers sont **gardés tels quels** dans les constantes Dart — `Uri.encodeFull()` gère l'encodage au runtime (déjà fait dans `OtadexImage`).

---

## Étape 3 — `lib/core/constants/app_assets.dart`

### 3a. Ajouter la constante de base de l'animé

```dart
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MHA — My Hero Academia   prefix: mha_
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
static const String _mha =
    'https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia';
```

### 3b. Ajouter la liste d'images de chaque personnage

```dart
// ── Izuku Midoriya ─────────────────────────────────────────────────────────
static const List<String> izukuMidoriya = [
  '$_mha/Izuku Midoriya/mha_izuku1.jpeg',
  '$_mha/Izuku Midoriya/mha_izuku2.jpeg',
  // ... autant d'images que disponibles
];
```

Personnages sans images encore uploadées :

```dart
static const List<String> katsukyBakugo = [];  // dossier créé, images à venir
```

### 3c. Ajouter dans `getByCharacterId()`

La méthode `getByCharacterId()` en bas du fichier mappe `charId` → liste d'images.
L'ID Firestore du personnage doit être utilisé ici.

```dart
// MHA
case 'mha-izuku-midoriya':
  return izukuMidoriya;
case 'mha-katsuki-bakugo':
  return katsukyBakugo;
// ...
```

**Convention ID** : `[prefix animé sans underscore]-[prénom]-[nom]` en minuscules avec tirets.

- `jujutsu-kaisen` → `jjk-` : `jjk-gojo-satoru`
- `my-hero-academia` → `mha-` : `mha-izuku-midoriya`

---

## Étape 4 — `lib/core/services/firestore_character_service.dart`

### 4a. Ajouter les couleurs thème de l'animé

Dans `_cardColorForAnime()` et `_accentColorForAnime()` :

```dart
Color _cardColorForAnime(String animeId) => switch (animeId) {
  // ... existants ...
  'my-hero-academia' => AppColors.animeMhaCard,   // ← ajouter
  _ => AppColors.animeDefaultCard,
};

Color _accentColorForAnime(String animeId) => switch (animeId) {
  // ... existants ...
  'my-hero-academia' => AppColors.animeMhaAccent, // ← ajouter
  _ => AppColors.animeDefaultAccent,
};
```

### 4b. Ajouter la catégorie

```dart
String _categoryForAnime(String animeId) => switch (animeId) {
  // ... existants ...
  'my-hero-academia' => 'Shōnen',  // ← ajouter
  _ => 'Shōnen',
};
```

### 4c. Ajouter les couleurs dans `app_colors.dart`

Dans `lib/core/theme/app_colors.dart`, section `// ── Anime card colors ──` :

```dart
// My Hero Academia
static const Color animeMhaCard    = Color(0xFF1A2744);  // bleu nuit
static const Color animeMhaAccent  = Color(0xFF3B82F6);  // bleu primaire
```

⚠️ **RÈGLE ABSOLUE** : toujours ajouter dans `app_colors.dart`, jamais de `Color()` hardcodée ailleurs.

---

## Étape 5 — Firebase Firestore : document Animé

**Collection** : `animes`
**Document ID** : `my-hero-academia` (kebab-case, correspond à `animeId` des personnages)

### Structure du document

```json
{
  "titre": "My Hero Academia",
  "titreJaponais": "僕のヒーローアカデミア",
  "synopsis": "Dans un monde où 80% de la population possède un Super-Pouvoir...",
  "annee": 2016,
  "statut": "En cours",
  "studio": "Bones",
  "auteurId": "kohei-horikoshi",
  "genres": ["Shōnen", "Action", "Super-Héros"],
  "episodes": {
    "saison1": 13,
    "saison2": 25,
    "saison3": 25,
    "saison4": 25
  }
}
```

### Champs obligatoires

| Champ           | Type   | Description                              |
| --------------- | ------ | ---------------------------------------- |
| `titre`         | String | Nom français affiché dans l'app          |
| `titreJaponais` | String | Titre original japonais                  |
| `synopsis`      | String | Description courte (2-3 phrases)         |
| `annee`         | Number | Année de première diffusion              |
| `statut`        | String | `"En cours"` / `"Terminé"` / `"Annoncé"` |
| `studio`        | String | Studio de production                     |
| `genres`        | Array  | Premier élément = catégorie principale   |
| `auteurId`      | String | Référence doc dans `creators/`           |

---

## Étape 6 — Firebase Firestore : documents Personnage

**Collection** : `characters`
**Document ID** : `mha-izuku-midoriya` (même convention que `app_assets.dart`)

### Structure complète du document

```json
{
  "nom": "Izuku Midoriya",
  "animeName": "My Hero Academia",
  "animeId": "my-hero-academia",
  "rang": "Héros Pro",
  "popularityRank": 1,
  "imagePath": "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuku1.jpeg",
  "images": [],
  "description": "Né sans Alter dans un monde de super-héros, Izuku Midoriya...",
  "sexe": "Masculin",
  "age": "16 ans",
  "dateNaissance": "15 juillet",
  "nationalite": "Japonais",
  "statut": "Vivant",
  "pouvoirs": ["One For All", "Full Cowl", "Blackwhip", "Fa Jin"],
  "citations": [
    "Je cours toujours droit devant !",
    "Mon héritage, c'est tout ce dont j'ai besoin."
  ],
  "trivia": [
    "Son carnet de héros était numéroté #13.",
    "Il a mémorisé plus de 1000 techniques de héros."
  ],
  "relations": [
    {
      "nomPersonnage": "Katsuki Bakugo",
      "type": "rival"
    },
    {
      "nomPersonnage": "All Might",
      "type": "mentor"
    }
  ],
  "voixJaponaise": "Daiki Yamashita",
  "voixAnglaise": "Justin Briner",
  "auteurId": "kohei-horikoshi",
  "likesCount": 0
}
```

### Champs obligatoires minimum

| Champ            | Obligatoire | Notes                                           |
| ---------------- | ----------- | ----------------------------------------------- |
| `nom`            | ✅          | Nom complet affiché                             |
| `animeName`      | ✅          | Affiché sous le nom dans la fiche               |
| `animeId`        | ✅          | Doit correspondre au doc dans `animes/`         |
| `rang`           | ✅          | Tier affiché (Grade 1, Spécial, Héros Pro…)     |
| `popularityRank` | ✅          | 1-3 → trending, 1-10 → recommandé, 1 → featured |
| `imagePath`      | ✅          | URL GitHub raw de l'image principale            |
| `description`    | ✅          | Bio affichée dans l'onglet Infos                |
| `pouvoirs`       | ✅ (array)  | Affiché dans la section Pouvoirs                |
| `citations`      | ✅ (array)  | Premier élément = citation hero card            |
| `likesCount`     | ✅          | Initialiser à `0`                               |
| `images`         | optionnel   | Si vide → fallback sur `app_assets.dart`        |
| `trivia`         | optionnel   | Section Kage uniquement                         |
| `relations`      | optionnel   | Chaque relation : `{nomPersonnage, type}`       |

### Valeurs de `rang` et correspondance tier

| `rang` Firestore                | Tier Flutter |
| ------------------------------- | ------------ |
| `"Grade Spécial"` / `"Spécial"` | `ss`         |
| `"Grade 1"` / `"Héros Pro"`     | `s`          |
| `"Grade 2"` / `"Grade 3"`       | `a`          |
| Tout autre                      | `b`          |

### Valeurs de `type` dans `relations`

| Type Firestore                   | Couleur badge |
| -------------------------------- | ------------- |
| `"élève"`, `"ami"`, `"allié"`    | vert          |
| `"rival"`, `"mentor"`            | bleu          |
| `"ennemi"`, `"antagoniste"`      | rouge         |
| `"famille"`, `"frère"`, `"père"` | ambre         |

---

## Étape 7 — Créateur (optionnel mais recommandé)

**Collection** : `creators`
**Document ID** : `kohei-horikoshi`

```json
{
  "nom": "Kōhei Horikoshi",
  "occupation": "Mangaka",
  "nationalite": "Japonais",
  "bio": "Auteur du manga My Hero Academia, publié depuis 2014 dans Weekly Shōnen Jump.",
  "influences": ["Dragon Ball", "American Comics"],
  "oeuvres": [{ "titre": "My Hero Academia" }, { "titre": "Oumagadoki Zoo" }]
}
```

---

## Étape 8 — Vérification finale

### Checklist avant de considérer l'animé en ligne

- [ ] Dossiers créés dans `otadex-assets` et images pushées sur GitHub
- [ ] URLs GitHub raw testées manuellement dans le navigateur (une par personnage)
- [ ] `app_assets.dart` : constante `_[prefix]`, listes images, entrées dans `getByCharacterId()`
- [ ] `app_colors.dart` : couleurs `anime[Xxx]Card` et `anime[Xxx]Accent` ajoutées
- [ ] `firestore_character_service.dart` : 3 switch mis à jour (`_cardColor`, `_accentColor`, `_category`)
- [ ] Firestore `animes/` : document créé avec tous les champs obligatoires
- [ ] Firestore `characters/` : au moins 3 personnages créés avec IDs corrects
- [ ] Firestore `creators/` : document créé si auteur non existant
- [ ] Hot restart Flutter → personnages visibles en home (grille)
- [ ] Tap sur un personnage → fiche ouvre, images galerie chargent

---

## Récapitulatif des fichiers à modifier

| Fichier                                              | Action                                               |
| ---------------------------------------------------- | ---------------------------------------------------- |
| `otadex-assets/Animé pictures/[Nom]/[Perso]/*.jpeg`  | Créer dossiers + uploader images                     |
| `lib/core/constants/app_assets.dart`                 | Constante URL, listes images, `getByCharacterId`     |
| `lib/core/theme/app_colors.dart`                     | 2 couleurs `anime[Xxx]Card` + `anime[Xxx]Accent`     |
| `lib/core/services/firestore_character_service.dart` | 3 switch : `_cardColor`, `_accentColor`, `_category` |
| Firebase Console → `animes/`                         | 1 document par animé                                 |
| Firebase Console → `characters/`                     | N documents, un par personnage                       |
| Firebase Console → `creators/`                       | 1 document par auteur (si nouveau)                   |
