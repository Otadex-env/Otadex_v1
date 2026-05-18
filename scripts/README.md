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
