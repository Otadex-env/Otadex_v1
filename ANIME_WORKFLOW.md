# Workflow — Ajout d'un nouvel animé sur OTADEX

Guide complet : de la création du fichier .docx jusqu'à la mise en ligne Firebase.

---

## Procédure rapide (2 commandes)

```bash
# 1. Préparer tout depuis un fichier .docx
node scripts/setup_anime.js MHA.docx

# 2. Déposer les images dans temp_images/My Hero Academia/[Personnage]/
#    puis pousser sur GitHub + Firestore
node scripts/push_images.js "My Hero Academia"
```

**Dépendances (à installer une fois) :**
```bash
npm install
```

---

## Vue d'ensemble

```
.docx (données)          otadex-assets (GitHub)        Otadex_v1 (Flutter)         Firebase
────────────────         ──────────────────────         ──────────────────────       ────────
setup_anime.js      →    temp_images/ (dossiers)   →   app_assets.dart         →    Firestore
  parse .docx            push_images.js                 app_colors.dart              animes/
  génère import_xxx.js   → renomme images               firestore_character_service  characters/
  importe Firestore      → copie vers otadex-assets     import_xxx.js                creators/
                         → git push GitHub
                         → met à jour Firestore
```

---

## Format du fichier .docx

Crée un fichier Word/LibreOffice avec les champs suivants (un par ligne, format `CLÉ: valeur`) :

```
ANIME: My Hero Academia
SLUG: my-hero-academia
PREFIX: mha
ANNEE: 2016
STUDIO: Bones
STATUT: En cours
GENRES: Shōnen, Action, Super-Héros
SYNOPSIS: Dans un monde où 80% de la population possède un Super-Pouvoir...
AUTEUR: Kōhei Horikoshi
AUTEUR_ID: kohei-horikoshi
AUTEUR_BIO: Auteur du manga My Hero Academia, publié depuis 2014 dans Weekly Shōnen Jump.
TITRE_JP: 僕のヒーローアカデミア
EPISODES: {"saison1": 13, "saison2": 25, "saison3": 25}

PERSONNAGE: Izuku Midoriya
ID: mha-izuku-midoriya
RANG: Héros Pro
POPULARITE: 1
SEXE: Masculin
AGE: 16 ans
NAISSANCE: 15 juillet
NATIONALITE: Japonais
STATUT_PERSO: Vivant
DESCRIPTION: Né sans Alter dans un monde de super-héros, Izuku Midoriya...
POUVOIRS: One For All, Full Cowl, Blackwhip, Fa Jin
CITATIONS: Je cours toujours droit devant ! | Mon héritage, c'est tout ce dont j'ai besoin.
TRIVIA: Son carnet de héros était numéroté #13. | Il a mémorisé plus de 1000 techniques.
VOIX_JP: Daiki Yamashita
VOIX_EN: Justin Briner
RELATION: Katsuki Bakugo|rival
RELATION: All Might|mentor

PERSONNAGE: Katsuki Bakugo
ID: mha-katsuki-bakugo
RANG: Héros Pro
POPULARITE: 2
...
```

### Champs obligatoires (animé)

| Champ      | Exemple                        |
|------------|--------------------------------|
| `ANIME`    | `My Hero Academia`             |
| `SLUG`     | `my-hero-academia`             |
| `PREFIX`   | `mha`                          |
| `ANNEE`    | `2016`                         |
| `STUDIO`   | `Bones`                        |
| `STATUT`   | `En cours` / `Terminé`         |
| `GENRES`   | `Shōnen, Action`               |
| `SYNOPSIS` | Description courte             |

### Champs obligatoires (personnage)

| Champ         | Exemple                     |
|---------------|-----------------------------|
| `PERSONNAGE`  | `Izuku Midoriya`            |
| `ID`          | `mha-izuku-midoriya`        |
| `RANG`        | `Héros Pro`                 |
| `POPULARITE`  | `1` (1-3 → trending)        |
| `DESCRIPTION` | Bio du personnage           |

### Convention ID personnage

Format : `[prefix]-[prénom]-[nom]` en minuscules avec tirets.

| Animé             | Préfixe | Exemple ID              |
|-------------------|---------|-------------------------|
| Jujutsu Kaisen    | `jjk`   | `jjk-gojo-satoru`       |
| Naruto Shippuden  | `ns`    | `ns-itachi-uchiha`      |
| My Hero Academia  | `mha`   | `mha-izuku-midoriya`    |

### Préfixes existants (réservés)

| Animé                  | Préfixe |
|------------------------|---------|
| Jujutsu Kaisen         | `jjk`   |
| Naruto Shippuden       | `ns`    |
| Classroom of the Elite | `clk`   |
| One Piece              | `op`    |
| Kuroko no Basket       | `knb`   |
| Fullmetal Alchemist    | `fma`   |
| Hunter x Hunter        | `hxh`   |

---

## Ce que fait `setup_anime.js`

| Étape | Action |
|-------|--------|
| A | Parse le .docx avec `mammoth` |
| B | Génère les URLs GitHub raw pour chaque personnage |
| C | Met à jour `lib/core/constants/app_assets.dart` |
| D | Met à jour `lib/core/theme/app_colors.dart` |
| E | Met à jour `lib/core/services/firestore_character_service.dart` |
| F | Génère `scripts/import_[prefix].js` |
| G | Lance l'import Firestore automatiquement |
| H | Crée les dossiers `temp_images/[Animé]/[Personnage]/` avec README |

**Couleurs auto-détectées par genre :**

| Genre      | Couleur card | Couleur accent |
|------------|-------------|----------------|
| Shōnen     | Bleu nuit    | Bleu           |
| Seinen     | Vert sombre  | Vert           |
| Shōjo      | Bordeaux     | Rose           |
| Isekai     | Violet foncé | Violet         |
| Sport      | Bleu marine  | Vert           |

---

## Ce que fait `push_images.js`

| Étape | Action |
|-------|--------|
| A | Scanne `temp_images/[Animé]/[Personnage]/` |
| B | Renomme en `[prefix]_[slug]N.jpeg` + conversion JPEG via `sharp` |
| C | Copie vers `otadex-assets/Animé pictures/[Animé]/[Personnage]/` |
| D | Met à jour les listes vides `[]` dans `app_assets.dart` |
| E | `git add . && git commit && git push origin main` |
| F | Relance `import_[prefix].js` avec les URLs finales |

**Convention de renommage automatique :**

```
image_001.jpg   → mha_izuk1.jpeg   (Izuku Midoriya, prefix mha)
photo.png       → mha_izuk2.jpeg
Screenshot.webp → mha_izuk3.jpeg
```
Peu importe le nom original — seul l'ordre alphabétique des fichiers détermine le numéro.

---

## Gestion des erreurs courantes

### `serviceAccountKey.json` manquant
```
❌  serviceAccountKey.json introuvable à la racine.
```
→ Firebase Console → Paramètres → Comptes de service → Générer une clé → copier à la racine
⚠️ NE JAMAIS committer ce fichier (ajouté dans `.gitignore`)

### Repo `otadex-assets` introuvable
```
⚠️  Repo otadex-assets introuvable automatiquement.
Chemin absolu vers otadex-assets :
```
→ Entrer le chemin complet, ex: `/home/user/Bureau/otadex-assets`

### Images non trouvées
```
❌  Aucune image trouvée.
```
→ Vérifier que les images sont dans `temp_images/[Animé]/[Personnage]/` (pas directement dans `[Animé]/`)

---

## Vérification manuelle post-setup

### Après `setup_anime.js`

- [ ] `app_assets.dart` : constante `_[prefix]` présente, listes `[]` vides
- [ ] `app_colors.dart` : `anime[Xxx]Card` et `anime[Xxx]Accent` ajoutés
- [ ] `firestore_character_service.dart` : 3 switch mis à jour
- [ ] Firestore `animes/` : document créé
- [ ] Firestore `characters/` : personnages créés avec IDs corrects
- [ ] `temp_images/[Animé]/[Personnage]/README.md` : présent dans chaque dossier

### Après `push_images.js`

- [ ] Images renommées dans `temp_images/[Animé]/[Personnage]/_renamed/`
- [ ] Images copiées dans `otadex-assets/Animé pictures/[Animé]/[Personnage]/`
- [ ] Commit git présent (`git log --oneline -1` dans `otadex-assets`)
- [ ] Test URL raw dans navigateur (retourne l'image)
- [ ] `app_assets.dart` : listes remplies avec les vraies URLs
- [ ] Firestore `characters/images[]` mis à jour
- [ ] Hot restart Flutter → personnages visibles, galerie charge ✅

---

## Détails techniques (pour modification manuelle)

### URL GitHub raw

```
https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/[Dossier animé]/[Dossier personnage]/[fichier].jpeg
```

⚠️ Les espaces sont **gardés tels quels** dans les constantes Dart — `_normalizeUrl()` dans `OtadexImage` gère l'encodage au runtime (évite le double-encodage `%2520`).

### Structure Firestore — animé

```json
{
  "titre": "My Hero Academia",
  "titreJaponais": "僕のヒーローアカデミア",
  "synopsis": "...",
  "annee": 2016,
  "statut": "En cours",
  "studio": "Bones",
  "auteurId": "kohei-horikoshi",
  "genres": ["Shōnen", "Action"],
  "episodes": { "saison1": 13 }
}
```

### Structure Firestore — personnage

```json
{
  "nom": "Izuku Midoriya",
  "animeName": "My Hero Academia",
  "animeId": "my-hero-academia",
  "rang": "Héros Pro",
  "popularityRank": 1,
  "imagePath": "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuk1.jpeg",
  "images": [],
  "description": "...",
  "sexe": "Masculin",
  "age": "16 ans",
  "dateNaissance": "15 juillet",
  "nationalite": "Japonais",
  "statut": "Vivant",
  "pouvoirs": ["One For All"],
  "citations": ["Je cours toujours droit devant !"],
  "trivia": [],
  "relations": [{ "nomPersonnage": "All Might", "type": "mentor" }],
  "voixJaponaise": "Daiki Yamashita",
  "voixAnglaise": "Justin Briner",
  "auteurId": "kohei-horikoshi",
  "likesCount": 0
}
```

### Valeurs de `rang` → tier Flutter

| `rang` Firestore              | Tier  |
|-------------------------------|-------|
| `"Grade Spécial"` / `"Spécial"` | `ss` |
| `"Grade 1"` / `"Héros Pro"`   | `s`   |
| `"Grade 2"` / `"Grade 3"`     | `a`   |
| Tout autre                    | `b`   |

### Valeurs de `type` dans `relations`

| Type                            | Couleur badge |
|---------------------------------|---------------|
| `"élève"`, `"ami"`, `"allié"`   | vert          |
| `"rival"`, `"mentor"`           | bleu          |
| `"ennemi"`, `"antagoniste"`     | rouge         |
| `"famille"`, `"frère"`, `"père"`| ambre         |

---

## Récapitulatif des fichiers modifiés par les scripts

| Fichier                                              | Script          | Action                           |
|------------------------------------------------------|-----------------|----------------------------------|
| `lib/core/constants/app_assets.dart`                 | setup + push    | URLs images                      |
| `lib/core/theme/app_colors.dart`                     | setup           | 2 couleurs animé                 |
| `lib/core/services/firestore_character_service.dart` | setup           | 3 switch                         |
| `scripts/import_[prefix].js`                         | setup           | Généré automatiquement           |
| `temp_images/[Animé]/[Personnage]/`                  | setup           | Dossiers + README                |
| `otadex-assets/Animé pictures/[Animé]/`              | push            | Images copiées                   |
| Firebase `animes/`                                   | setup (auto)    | Document créé                    |
| Firebase `characters/`                               | setup + push    | Documents créés, images mises à jour |
| Firebase `creators/`                                 | setup (auto)    | Document créé                    |
