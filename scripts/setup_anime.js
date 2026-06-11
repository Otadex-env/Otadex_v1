#!/usr/bin/env node
/**
 * setup_anime.js — Automatise l'ajout complet d'un animé dans OTADEX
 *
 * Usage :
 *   node scripts/setup_anime.js <fichier.docx>
 *   node scripts/setup_anime.js MHA.docx
 *
 * Format attendu du .docx (voir ANIME_WORKFLOW.md) :
 *   ANIME: My Hero Academia
 *   SLUG: my-hero-academia
 *   PREFIX: mha
 *   ANNEE: 2016
 *   STUDIO: Bones
 *   STATUT: En cours
 *   GENRES: Shōnen, Action
 *   SYNOPSIS: ...
 *   AUTEUR: Kōhei Horikoshi
 *   AUTEUR_ID: kohei-horikoshi
 *   AUTEUR_BIO: ...
 *   TITRE_JP: 僕のヒーローアカデミア
 *   EPISODES: {"saison1": 13, "saison2": 25}
 *
 *   PERSONNAGE: Izuku Midoriya
 *   ID: mha-izuku-midoriya
 *   RANG: Héros Pro
 *   POPULARITE: 1
 *   SEXE: Masculin
 *   AGE: 16 ans
 *   NAISSANCE: 15 juillet
 *   NATIONALITE: Japonais
 *   STATUT_PERSO: Vivant
 *   DESCRIPTION: ...
 *   POUVOIRS: One For All, Full Cowl
 *   CITATIONS: Citation 1 | Citation 2
 *   TRIVIA: Fait 1 | Fait 2
 *   VOIX_JP: Daiki Yamashita
 *   VOIX_EN: Justin Briner
 *   RELATION: Katsuki Bakugo|rival
 *   RELATION: All Might|mentor
 *
 *   PERSONNAGE: Katsuki Bakugo
 *   ...
 */

'use strict';

const fs   = require('fs');
const path = require('path');

// ── Dépendances ──────────────────────────────────────────────────────────────
let mammoth;
try {
  mammoth = require('mammoth');
} catch {
  console.error('❌  mammoth manquant. Lance : npm install mammoth');
  process.exit(1);
}

const { toVarName } = require('./anime_workflow/naming');

// ── Paths ─────────────────────────────────────────────────────────────────────
const ROOT          = path.resolve(__dirname, '..');
const APP_ASSETS    = path.join(ROOT, 'lib/core/constants/app_assets.dart');
const APP_COLORS    = path.join(ROOT, 'lib/core/theme/app_colors.dart');
const FS_SERVICE    = path.join(ROOT, 'lib/core/services/firestore_character_service.dart');
const SCRIPTS_DIR   = __dirname;
const TEMP_IMAGES   = path.join(ROOT, 'temp_images');
const GITHUB_BASE   = 'https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures';

// ── Couleurs selon genre ───────────────────────────────────────────────────────
const GENRE_COLORS = {
  shonen:  { card: '0xFF1A2744', accent: '0xFF3B82F6' }, // bleu nuit / bleu
  seinen:  { card: '0xFF1A2420', accent: '0xFF10B981' }, // vert sombre
  shojo:   { card: '0xFF2A1028', accent: '0xFFEC4899' }, // rose/violet
  isekai:  { card: '0xFF1E1040', accent: '0xFF8B5CF6' }, // violet/doré
  sport:   { card: '0xFF0E2040', accent: '0xFF22C55E' }, // vert/bleu
  default: { card: '0xFF1A1A2E', accent: '0xFFFF6D1B' }, // défaut orange
};

function detectColorsByGenre(genres) {
  const g = (genres || []).join(' ').toLowerCase();
  if (g.includes('seinen'))                 return GENRE_COLORS.seinen;
  if (g.includes('shōjo') || g.includes('shojo')) return GENRE_COLORS.shojo;
  if (g.includes('isekai'))                 return GENRE_COLORS.isekai;
  if (g.includes('sport') || g.includes('basket') || g.includes('foot'))
    return GENRE_COLORS.sport;
  if (g.includes('shōnen') || g.includes('shonen') || g.includes('action'))
    return GENRE_COLORS.shonen;
  return GENRE_COLORS.default;
}

// ── Parseur .docx ─────────────────────────────────────────────────────────────
async function parseDocx(filePath) {
  const result = await mammoth.extractRawText({ path: filePath });
  return parseText(result.value);
}

function parseText(text) {
  const lines = text.split('\n').map(l => l.trim()).filter(Boolean);
  const anime = {};
  const characters = [];
  let currentChar = null;

  for (const line of lines) {
    const [rawKey, ...rest] = line.split(':');
    const key   = rawKey.trim().toUpperCase();
    const value = rest.join(':').trim();

    if (!value) continue;

    switch (key) {
      case 'ANIME':       anime.nom = value; break;
      case 'SLUG':        anime.slug = value; break;
      case 'PREFIX':      anime.prefix = value.toLowerCase().replace(/[^a-z0-9]/g, ''); break;
      case 'ANNEE':       anime.annee = parseInt(value) || 2020; break;
      case 'STUDIO':      anime.studio = value; break;
      case 'STATUT':      anime.statut = value; break;
      case 'GENRES':      anime.genres = value.split(',').map(g => g.trim()); break;
      case 'SYNOPSIS':    anime.synopsis = value; break;
      case 'AUTEUR':      anime.auteurNom = value; break;
      case 'AUTEUR_ID':   anime.auteurId = value; break;
      case 'AUTEUR_BIO':  anime.auteurBio = value; break;
      case 'TITRE_JP':    anime.titreJaponais = value; break;
      case 'EPISODES': {
        try { anime.episodes = JSON.parse(value); } catch { anime.episodes = {}; }
        break;
      }

      case 'PERSONNAGE':
        if (currentChar) characters.push(currentChar);
        currentChar = { nom: value, relations: [] };
        break;

      default:
        if (!currentChar) break;
        switch (key) {
          case 'ID':           currentChar.id = value; break;
          case 'RANG':         currentChar.rang = value; break;
          case 'POPULARITE':   currentChar.popularityRank = parseInt(value) || 99; break;
          case 'SEXE':         currentChar.sexe = value; break;
          case 'AGE':          currentChar.age = value; break;
          case 'NAISSANCE':    currentChar.dateNaissance = value; break;
          case 'NATIONALITE':  currentChar.nationalite = value; break;
          case 'STATUT_PERSO': currentChar.statut = value; break;
          case 'DESCRIPTION':  currentChar.description = value; break;
          case 'POUVOIRS':     currentChar.pouvoirs = value.split(',').map(p => p.trim()); break;
          case 'CITATIONS':    currentChar.citations = value.split('|').map(c => c.trim()); break;
          case 'TRIVIA':       currentChar.trivia = value.split('|').map(t => t.trim()); break;
          case 'VOIX_JP':      currentChar.voixJaponaise = value; break;
          case 'VOIX_EN':      currentChar.voixAnglaise = value; break;
          case 'RELATION': {
            const parts = value.split('|');
            if (parts.length >= 2) {
              currentChar.relations.push({ nomPersonnage: parts[0].trim(), type: parts[1].trim() });
            }
            break;
          }
        }
    }
  }

  if (currentChar) characters.push(currentChar);

  // Dérivations automatiques si champs manquants
  if (!anime.slug && anime.nom) {
    anime.slug = toSlug(anime.nom);
  }
  if (!anime.prefix && anime.nom) {
    anime.prefix = anime.nom.toLowerCase().replace(/[^a-z]/g, '').slice(0, 3);
  }
  anime.genres = anime.genres || ['Shōnen'];

  // Compléter les IDs manquants des personnages
  for (const c of characters) {
    if (!c.id && c.nom) {
      c.id = `${anime.prefix}-${toSlug(c.nom)}`;
    }
    if (!c.statut) c.statut = 'Vivant';
    if (!c.pouvoirs) c.pouvoirs = [];
    if (!c.citations) c.citations = [];
    if (!c.trivia) c.trivia = [];
    if (!c.relations) c.relations = [];
  }

  return { anime, characters };
}

function toSlug(str) {
  return str
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');
}

// ── Étape B — URLs GitHub raw ────────────────────────────────────────────────
function buildImagePath(anime, character) {
  const charSlug = toSlug(character.nom).slice(0, 4);
  return `${GITHUB_BASE}/${anime.nom}/${character.nom}/${anime.prefix}_${charSlug}1.jpeg`;
}

// ── Étape C — app_assets.dart ────────────────────────────────────────────────
function updateAppAssets(anime, characters) {
  let content = fs.readFileSync(APP_ASSETS, 'utf8');

  const varName = `_${anime.prefix}`;
  if (content.includes(varName)) {
    console.log(`  ⏭  app_assets.dart : section ${varName} déjà présente, ignorée.`);
    return;
  }

  const capPrefix = anime.prefix.charAt(0).toUpperCase() + anime.prefix.slice(1);
  const listVarLines = characters.map(c => {
    const lowerName = toVarName(c.nom);
    return `  static const List<String> ${lowerName} = [];\n`;
  }).join('');

  const switchCases = characters.map(c => {
    const lowerName = toVarName(c.nom);
    return `      case '${c.id}':\n        return ${lowerName};`;
  }).join('\n');

  const newSection = `
  // ${'━'.repeat(75)}
  // ${capPrefix} — ${anime.nom}   prefix: ${anime.prefix}_
  // ${'━'.repeat(75)}
  static const String ${varName} = '${GITHUB_BASE}/${anime.nom}';

${listVarLines}`;

  // Insérer avant le commentaire "Résolution par charId"
  content = content.replace(
    /(\s*\/\/ ━+\s*\n\s*\/\/ Résolution par charId)/,
    `\n${newSection}$1`
  );

  // Ajouter les cases dans getByCharacterId avant le default
  content = content.replace(
    /(\s*default:\s*\n\s*return const \[\];)/,
    `\n      // ${capPrefix}\n${switchCases}\n$1`
  );

  fs.writeFileSync(APP_ASSETS, content, 'utf8');
  console.log(`  ✅  app_assets.dart mis à jour (${characters.length} personnages)`);
}

// ── Étape D — app_colors.dart ────────────────────────────────────────────────
function updateAppColors(anime) {
  let content = fs.readFileSync(APP_COLORS, 'utf8');
  const capPrefix = anime.prefix.charAt(0).toUpperCase() + anime.prefix.slice(1);
  const cardToken   = `anime${capPrefix}Card`;
  const accentToken = `anime${capPrefix}Accent`;

  if (content.includes(cardToken)) {
    console.log(`  ⏭  app_colors.dart : couleurs ${cardToken} déjà présentes, ignorées.`);
    return { cardToken, accentToken };
  }

  const colors = detectColorsByGenre(anime.genres);
  const newColors = `  // ${anime.nom}\n  static const Color ${cardToken}   = Color(${colors.card});\n  static const Color ${accentToken} = Color(${colors.accent});\n`;

  // Ajouter avant la dernière accolade du bloc anime card colors, ou à la fin avant '}'
  if (content.includes('animeDefaultCard')) {
    content = content.replace(
      /(static const Color animeDefaultCard[^\n]+\n\s*static const Color animeDefaultAccent[^\n]+\n)/,
      `$1\n${newColors}`
    );
  } else {
    content = content.replace(/(\n}\s*$)/, `\n${newColors}$1`);
  }

  fs.writeFileSync(APP_COLORS, content, 'utf8');
  console.log(`  ✅  app_colors.dart mis à jour (${cardToken}, ${accentToken})`);
  return { cardToken, accentToken };
}

// ── Étape E — firestore_character_service.dart ───────────────────────────────
function updateFirestoreService(anime, colors) {
  let content = fs.readFileSync(FS_SERVICE, 'utf8');
  const { cardToken, accentToken } = colors;

  if (content.includes(`'${anime.slug}'`)) {
    console.log(`  ⏭  firestore_character_service.dart : '${anime.slug}' déjà présent, ignoré.`);
    return;
  }

  const capPrefix = anime.prefix.charAt(0).toUpperCase() + anime.prefix.slice(1);
  const category  = detectCategory(anime.genres);

  content = content.replace(
    /(_ => AppColors\.animeDefaultCard,\s*\n\s*};)/,
    `        '${anime.slug}' => AppColors.${cardToken},\n        $1`
  );
  content = content.replace(
    /(_ => AppColors\.animeDefaultAccent,\s*\n\s*};)/,
    `        '${anime.slug}' => AppColors.${accentToken},\n        $1`
  );
  content = content.replace(
    /(_ => 'Shōnen',\s*\n\s*};)/,
    `        '${anime.slug}' => '${category}',\n        $1`
  );

  fs.writeFileSync(FS_SERVICE, content, 'utf8');
  console.log(`  ✅  firestore_character_service.dart mis à jour`);
}

function detectCategory(genres) {
  const g = (genres || []).join(' ').toLowerCase();
  if (g.includes('seinen'))  return 'Seinen';
  if (g.includes('shōjo') || g.includes('shojo')) return 'Shōjo';
  if (g.includes('isekai'))  return 'Isekai';
  if (g.includes('sport'))   return 'Sportif';
  return 'Shōnen';
}

// ── Étape F — import_[slug].js ───────────────────────────────────────────────
function generateImportScript(anime, characters) {
  const scriptPath = path.join(SCRIPTS_DIR, `import_${anime.prefix}.js`);
  const capName    = anime.nom.replace(/\s+/g, '');
  const { cardToken, accentToken } = {
    cardToken:   `anime${anime.prefix.charAt(0).toUpperCase() + anime.prefix.slice(1)}Card`,
    accentToken: `anime${anime.prefix.charAt(0).toUpperCase() + anime.prefix.slice(1)}Accent`,
  };

  const auteurId   = anime.auteurId  || toSlug(anime.auteurNom || 'unknown');
  const auteurNom  = anime.auteurNom || 'Auteur inconnu';
  const auteurBio  = anime.auteurBio || '';
  const titreJp    = anime.titreJaponais || '';
  const episodes   = JSON.stringify(anime.episodes || {});
  const genres     = JSON.stringify(anime.genres);

  const charsCode = characters.map((c, i) => {
    const imgPath = buildImagePath(anime, c);
    return `
  // ── ${c.nom}
  {
    id: '${c.id}',
    data: {
      nom: ${JSON.stringify(c.nom)},
      animeName: ${JSON.stringify(anime.nom)},
      animeId: '${anime.slug}',
      rang: ${JSON.stringify(c.rang || 'Personnage')},
      popularityRank: ${c.popularityRank || (i + 10)},
      imagePath: ${JSON.stringify(imgPath)},
      images: [],
      description: ${JSON.stringify(c.description || '')},
      sexe: ${JSON.stringify(c.sexe || 'Inconnu')},
      age: ${JSON.stringify(c.age || '')},
      dateNaissance: ${JSON.stringify(c.dateNaissance || '')},
      nationalite: ${JSON.stringify(c.nationalite || '')},
      statut: ${JSON.stringify(c.statut || 'Vivant')},
      pouvoirs: ${JSON.stringify(c.pouvoirs)},
      citations: ${JSON.stringify(c.citations)},
      trivia: ${JSON.stringify(c.trivia)},
      relations: ${JSON.stringify(c.relations)},
      voixJaponaise: ${JSON.stringify(c.voixJaponaise || '')},
      voixAnglaise: ${JSON.stringify(c.voixAnglaise || '')},
      auteurId: '${auteurId}',
      likesCount: 0,
    },
  },`;
  }).join('\n');

  const code = `#!/usr/bin/env node
/**
 * import_${anime.prefix}.js — Importe ${anime.nom} dans Firestore
 * Généré automatiquement par setup_anime.js
 *
 * Usage :
 *   node scripts/import_${anime.prefix}.js
 *
 * Nécessite : serviceAccountKey.json à la racine (NE PAS COMMITTER)
 */

'use strict';

const path  = require('path');
const admin = require('firebase-admin');

const KEY_PATH = path.resolve(__dirname, '../serviceAccountKey.json');
if (!require('fs').existsSync(KEY_PATH)) {
  console.error('❌  serviceAccountKey.json introuvable à la racine.');
  console.error('    Télécharge-le depuis Firebase Console → Paramètres → Comptes de service');
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.cert(require(KEY_PATH)),
});

const db = admin.firestore();

// ── Données ──────────────────────────────────────────────────────────────────

const ANIME = {
  id: '${anime.slug}',
  data: {
    titre: ${JSON.stringify(anime.nom)},
    titreJaponais: ${JSON.stringify(titreJp)},
    synopsis: ${JSON.stringify(anime.synopsis || '')},
    annee: ${anime.annee || 2020},
    statut: ${JSON.stringify(anime.statut || 'En cours')},
    studio: ${JSON.stringify(anime.studio || '')},
    auteurId: '${auteurId}',
    genres: ${genres},
    episodes: ${episodes},
  },
};

const CREATOR = {
  id: '${auteurId}',
  data: {
    nom: ${JSON.stringify(auteurNom)},
    occupation: 'Mangaka',
    nationalite: 'Japonais',
    bio: ${JSON.stringify(auteurBio)},
    oeuvres: [{ titre: ${JSON.stringify(anime.nom)} }],
  },
};

const CHARACTERS = [${charsCode}
];

// ── Import ────────────────────────────────────────────────────────────────────

async function importAll() {
  const batch = db.batch();
  let count = 0;

  // Animé
  batch.set(db.collection('animes').doc(ANIME.id), ANIME.data, { merge: true });
  console.log(\`  📺  Animé : \${ANIME.data.titre}\`);

  // Créateur
  batch.set(db.collection('creators').doc(CREATOR.id), CREATOR.data, { merge: true });
  console.log(\`  ✍️   Créateur : \${CREATOR.data.nom}\`);

  // Flush anime + creator first
  await batch.commit();

  // Personnages par lots de 20
  for (let i = 0; i < CHARACTERS.length; i += 20) {
    const chunk = CHARACTERS.slice(i, i + 20);
    const b = db.batch();
    for (const c of chunk) {
      b.set(db.collection('characters').doc(c.id), c.data, { merge: true });
      console.log(\`  👤  \${c.data.nom}\`);
      count++;
    }
    await b.commit();
  }

  console.log(\`\\n✅  Import terminé — \${count} personnages importés dans Firestore.\`);
  process.exit(0);
}

importAll().catch(err => {
  console.error('❌  Erreur import :', err.message);
  process.exit(1);
});
`;

  fs.writeFileSync(scriptPath, code, 'utf8');
  console.log(`  ✅  scripts/import_${anime.prefix}.js généré`);
  return scriptPath;
}

// ── Étape H — temp_images ─────────────────────────────────────────────────────
function createTempFolders(anime, characters) {
  const animeDir = path.join(TEMP_IMAGES, anime.nom);
  fs.mkdirSync(animeDir, { recursive: true });

  for (const c of characters) {
    const charDir = path.join(animeDir, c.nom);
    fs.mkdirSync(charDir, { recursive: true });
    const charSlug = toSlug(c.nom).slice(0, 4);
    const examples = Array.from({ length: 8 }, (_, i) =>
      `${anime.prefix}_${charSlug}${i + 1}.jpeg`
    ).join(', ');

    const readme = `# ${c.nom} — ${anime.nom}\n\nDéposer les images ici.\n\nConvention de nommage : ${examples}\n\nPeu importe le nom actuel des fichiers — push_images.js les renommera automatiquement.\n`;
    fs.writeFileSync(path.join(charDir, 'README.md'), readme, 'utf8');
  }

  console.log(`  ✅  Dossiers créés dans temp_images/${anime.nom}/`);
}

// ── Point d'entrée ────────────────────────────────────────────────────────────
async function main() {
  const docxPath = process.argv[2];

  if (!docxPath) {
    console.error('Usage : node scripts/setup_anime.js <fichier.docx>');
    console.error('Exemple : node scripts/setup_anime.js MHA.docx');
    process.exit(1);
  }

  const resolved = path.resolve(docxPath);
  if (!fs.existsSync(resolved)) {
    console.error(`❌  Fichier introuvable : ${resolved}`);
    process.exit(1);
  }

  console.log(`\n━━━ OTADEX — Setup Animé ━━━\n`);
  console.log(`📄  Lecture de ${path.basename(resolved)}...\n`);

  const { anime, characters } = await parseDocx(resolved);

  if (!anime.nom) {
    console.error('❌  Nom de l\'animé introuvable dans le fichier. Vérifie le format (ANIME: ...)');
    process.exit(1);
  }
  if (characters.length === 0) {
    console.error('❌  Aucun personnage trouvé. Vérifie le format (PERSONNAGE: ...)');
    process.exit(1);
  }

  console.log(`🎬  Animé     : ${anime.nom}`);
  console.log(`🔑  Slug      : ${anime.slug}`);
  console.log(`🏷️   Préfixe   : ${anime.prefix}_`);
  console.log(`👥  Personnages: ${characters.length}\n`);

  console.log('📦  Étape C — Mise à jour app_assets.dart...');
  updateAppAssets(anime, characters);

  console.log('🎨  Étape D — Mise à jour app_colors.dart...');
  const colorTokens = updateAppColors(anime);

  console.log('🔧  Étape E — Mise à jour firestore_character_service.dart...');
  updateFirestoreService(anime, colorTokens);

  console.log('📝  Étape F — Génération du script d\'import...');
  const importScript = generateImportScript(anime, characters);

  console.log('📁  Étape H — Création des dossiers temp_images...');
  createTempFolders(anime, characters);

  console.log('\n🚀  Étape G — Lancement de l\'import Firestore...');
  const { spawnSync } = require('child_process');
  const result = spawnSync('node', [importScript], {
    stdio: 'inherit',
    cwd: ROOT,
  });

  if (result.status !== 0) {
    console.warn('\n⚠️  Import Firestore échoué ou serviceAccountKey.json manquant.');
    console.warn('   Lance manuellement : node ' + path.relative(ROOT, importScript));
  }

  const charCount = characters.length;
  console.log(`
━━━ ${anime.nom} configuré ✅ ━━━
 Personnages : ${charCount}
 Firestore   : ${result.status === 0 ? 'importé ✅' : 'en attente (key manquante)'}
 Dossiers    : temp_images/${anime.nom}/

 PROCHAINE ÉTAPE :
 1. Déposer tes images dans temp_images/${anime.nom}/[Personnage]/
    (peu importe le nom — push_images.js les renommera)
 2. Lancer : node scripts/push_images.js "${anime.nom}"
`);
}

main().catch(err => {
  console.error('\n❌  Erreur :', err.message);
  process.exit(1);
});
