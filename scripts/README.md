# Scripts OTADEX

Scripts Node.js pour l'import de données vers Firebase Firestore.

## Import JJK

Lance l'import de tous les personnages JJK dans Firestore.

### Prérequis

- `serviceAccountkey.json` à la racine du projet (ne jamais committer)
- Node.js installé
- Dépendances installées :

```bash
npm install mammoth firebase-admin
```

### Lancement

```bash
node scripts/import_jjk.js
```

Si `node` pointe vers Snap/AppArmor ou si Google Auth refuse le JWT à cause
d'un décalage d'horloge local, utiliser le binaire Node disponible avec le
préchargeur d'horloge :

```bash
env NODE_OPTIONS='--require ./scripts/google_time_offset.js' /home/tilstack/.cache/ms-playwright-go/1.50.1/node scripts/import_jjk.js
```

### Collections créées / mises à jour

| Collection | Document ID | Contenu |
|---|---|---|
| `animes` | `jujutsu-kaisen` | Titre, synopsis, genres, épisodes, studio, auteur |
| `creators` | `gege-akutami` | Bio, bibliographie, récompenses, influences |
| `studios` | `mappa` | Fondation, productions, description |
| `characters` | `jjk-{slug}` | 20 personnages JJK complets |
| `quizzes` | `jjk-{slug}` | Quiz 5+ questions pour 7 personnages principaux |

### Personnages importés

1. `jjk-gojo-satoru` — Grade Spécial
2. `jjk-yuji-itadori` — Grade Spécial (de facto)
3. `jjk-ryomen-sukuna` — Grade Spécial
4. `jjk-megumi-fushiguro` — Grade 2
5. `jjk-nobara-kugisaki` — Grade 3
6. `jjk-suguru-geto` — Grade Spécial
7. `jjk-kento-nanami` — Grade 1
8. `jjk-yuta-okkotsu` — Grade Spécial
9. `jjk-maki-zenin` — Grade Spécial (de facto)
10. `jjk-aoi-todo` — Grade 1
11. `jjk-toge-inumaki` — Demi-Grade 1
12. `jjk-panda` — Grade 1
13. `jjk-toji-fushiguro` — Assassin
14. `jjk-mahito` — Grade Spécial
15. `jjk-kenjaku` — Antagoniste
16. `jjk-choso` — Secondaire
17. `jjk-shoko-ieiri` — Grade 1
18. `jjk-mei-mei` — Grade 1
19. `jjk-noritoshi-kamo` — Grade 1
20. `jjk-kasumi-miwa` — Grade 3

---

## Import One Piece

Lance l'import de tous les personnages One Piece dans Firestore.

### Prérequis

- `serviceAccountkey.json` à la racine du projet (ne jamais committer)
- Node.js installé
- Dépendances installées :

```bash
npm install mammoth firebase-admin
```

### Lancement

```bash
node scripts/import_one_piece.js
```

Si `node` pointe vers Snap/AppArmor, utiliser le binaire alternatif :

```bash
env NODE_OPTIONS='--require ./scripts/google_time_offset.js' /home/tilstack/.cache/ms-playwright-go/1.50.1/node scripts/import_one_piece.js
```

### Collections créées / mises à jour

| Collection | Document ID | Contenu |
|---|---|---|
| `animes` | `one-piece` | Titre, synopsis, genres, épisodes, studio, auteur |
| `creators` | `eiichiro-oda` | Bio, bibliographie, récompenses, influences |
| `studios` | `toei-animation` | Fondation, productions, description |
| `characters` | `op-{slug}` | 15 personnages One Piece complets |
| `quizzes` | `op-{slug}` | Quiz 5 questions pour 7 personnages principaux |

### Personnages importés

1. `op-monkey-d-luffy` — Pirate (Capitaine / Yonko)
2. `op-roronoa-zoro` — Pirate (Combattant)
3. `op-nami` — Navigatrice
4. `op-usopp` — Tireur d'élite
5. `op-sanji` — Cuisinier
6. `op-tony-tony-chopper` — Médecin
7. `op-nico-robin` — Archéologue
8. `op-franky` — Charpentier
9. `op-brook` — Musicien
10. `op-jinbe` — Timonier
11. `op-portgas-d-ace` — Pirate / Marine (décédé)
12. `op-trafalgar-d-water-law` — Pirate (Capitaine / Warlord)
13. `op-shanks` — Yonko
14. `op-boa-hancock` — Pirate / Warlord / Impératrice
15. `op-dracule-mihawk` — Warlord / Premier épéiste

---

## Import Kuroko no Basket

Lance l'import de tous les personnages Kuroko no Basket dans Firestore.

### Prérequis

- `serviceAccountkey.json` à la racine du projet (ne jamais committer)
- Node.js installé
- Dépendances installées :

```bash
npm install mammoth firebase-admin
```

### Lancement

```bash
node scripts/import_kkb.js
```

Si `node` pointe vers Snap/AppArmor, utiliser le binaire alternatif :

```bash
env NODE_OPTIONS='--require ./scripts/google_time_offset.js' /home/tilstack/.cache/ms-playwright-go/1.50.1/node scripts/import_kkb.js
```

### Collections créées / mises à jour

| Collection | Document ID | Contenu |
|---|---|---|
| `animes` | `kuroko-no-basket` | Titre, synopsis, genres, 75 épisodes, studio, auteur |
| `creators` | `tadatoshi-fujimaki` | Bio, bibliographie, récompenses |
| `studios` | `production-ig` | Fondation 1987, Ghost in the Shell, Haikyuu!! |
| `characters` | `knb-{slug}` | 13 personnages KnB complets |
| `quizzes` | `knb-{slug}` | Quiz 5 questions pour 7 personnages principaux |

### Personnages importés

1. `knb-akashi-seijuro` — Génération des Miracles — Meneur / Capitaine Rakuzan
2. `knb-kuroko-tetsuya` — Sixième Joueur Fantôme — Seirin
3. `knb-takao-kazunari` — Hawk Eye — Shūtoku
4. `knb-kise-ryota` — Perfect Copy — Kaijō
5. `knb-kagami-taiga` — Le Miracle qui n'en était pas un — Seirin
6. `knb-midorima-shintaro` — Tir de précision absolue — Shūtoku
7. `knb-aomine-daiki` — Formless Shot — Tōō
8. `knb-murasakibara-atsushi` — Aegis Shield — Yōsen
9. `knb-himuro-tatsuya` — Mirage Shot — Yōsen
10. `knb-momoi-satsuki` — Analyste de génie — Tōō (Manager)
11. `knb-hyuga-junpei` — Clutch Player / Capitaine Seirin
12. `knb-kiyoshi-teppei` — Iron Heart — Roi sans Couronne
13. `knb-aida-riko` — Coach Seirin

---

## Import Mushoku Tensei

Lance l'import de tous les personnages Mushoku Tensei dans Firestore.

### Prérequis

- `serviceAccountkey.json` à la racine du projet (ne jamais committer)
- Node.js installé
- Dépendances installées :

```bash
npm install mammoth firebase-admin
```

### Lancement

```bash
env NODE_OPTIONS='--require ./scripts/google_time_offset.js' /home/tilstack/.cache/ms-playwright-go/1.50.1/node scripts/import_mt.js
```

### Collections créées / mises à jour

| Collection | Document ID | Contenu |
|---|---|---|
| `animes` | `mushoku-tensei` | Titre, synopsis, genres, épisodes, studio, auteur |
| `creators` | `rifujin-na-magonote` | Bio, bibliographie, récompenses |
| `studios` | `studio-bind` | Fondation, productions, description |
| `characters` | `mt-{slug}` | 20 personnages MT complets |
| `quizzes` | `mt-{slug}` | Quiz 5-6 questions pour 7 personnages principaux |

### Personnages importés

1. `mt-rudeus-greyrat` — Mage Niveau Dieu (Protagoniste)
2. `mt-roxy-migurdia` — Eau Roi
3. `mt-sylphiette-greyrat` — Eau Roi
4. `mt-eris-boreas-greyrat` — Mad Sword King
5. `mt-ruijerd-superdia` — Guerrier Légendaire
6. `mt-paul-greyrat` — Aventurier S-rank
7. `mt-orsted` — Dieu Dragon
8. `mt-hitogami` — Dieu Humain (Antagoniste)
9. `mt-ghislaine-dedoldia` — Épée Roi
10. `mt-perugius-dola` — Sept Grandes Puissances
11. `mt-zenith-greyrat` — Mère de Rudeus
12. `mt-norn-greyrat` — Sœur de Rudeus
13. `mt-aisha-greyrat` — Demi-sœur de Rudeus
14. `mt-elinalise-dragonroad` — Grand-mère de Sylphie
15. `mt-cliff-grimoire` — Prêtre de Millis
16. `mt-zanoba-shirone` — Ancien Prince / Disciple
17. `mt-nanahoshi-shizuka` — Invoquée accidentellement
18. `mt-ariel-anemoi-asura` — Princesse d'Asura
19. `mt-lilia-greyrat` — Ancienne servante
20. `mt-badigadi` — Roi Démon Immortel

---

## Template pour futurs animés

Pour chaque nouvel animé, créer :

```
scripts/import_[anime_name].js
```

En suivant la même structure que `import_jjk.js` :

```js
// 1. animeData   → collection animes/{animeId}
// 2. creatorData → collection creators/{creatorId}
// 3. studioData  → collection studios/{studioId}
// 4. characters  → collection characters/{characterId}  (batch write)
// 5. quizzes     → collection quizzes/{characterId}     (batch write)
```

### Collections concernées à chaque import

- `animes/{animeId}` — métadonnées de l'animé
- `creators/{creatorId}` — auteur / mangaka
- `studios/{studioId}` — studio d'animation
- `characters/{characterId}` — un document par personnage
- `quizzes/{characterId}` — questions quiz par personnage

---

## Sécurité

- `serviceAccountkey.json` est dans `.gitignore` — ne jamais committer
- `scripts/google_time_offset.js` compense uniquement le décalage d'horloge
  local pendant la signature JWT Google Admin SDK.
- Clé Claude API : uniquement via Firebase Cloud Function, jamais côté client
- Firestore rules : déployer avant release (`firebase deploy --only firestore:rules`)
