#!/usr/bin/env node
/**
 * push_images.js — Renomme, copie et pousse les images d'un animé vers otadex-assets
 *
 * Usage :
 *   node scripts/push_images.js "My Hero Academia"
 *
 * Prérequis :
 *   - Images déposées dans temp_images/[Animé]/[Personnage]/
 *   - Repo otadex-assets accessible localement
 */

'use strict';

const fs      = require('fs');
const path    = require('path');
const { execSync, spawnSync } = require('child_process');
const readline = require('readline');
const { toVarName } = require('./anime_workflow/naming');

// ── Dépendances ───────────────────────────────────────────────────────────────
let sharp;
try {
  sharp = require('sharp');
} catch {
  console.error('❌  sharp manquant. Lance : npm install sharp');
  process.exit(1);
}

// ── Paths ─────────────────────────────────────────────────────────────────────
const ROOT        = path.resolve(__dirname, '..');
const TEMP_IMAGES = path.join(ROOT, 'temp_images');
const APP_ASSETS  = path.join(ROOT, 'lib/core/constants/app_assets.dart');
const SCRIPTS_DIR = __dirname;
const GITHUB_BASE = 'https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures';
const IMAGE_EXTS  = new Set(['.jpg', '.jpeg', '.png', '.webp', '.gif', '.bmp']);

// ── Utils ─────────────────────────────────────────────────────────────────────
function toSlug(str) {
  return str
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');
}

function ask(question) {
  return new Promise(resolve => {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
    rl.question(question, answer => {
      rl.close();
      resolve(answer.trim());
    });
  });
}

// ── Détection du repo otadex-assets ──────────────────────────────────────────
async function findOtadexAssets() {
  const candidates = [
    path.resolve(ROOT, '../otadex-assets'),
    path.resolve(ROOT, '../../otadex-assets'),
    path.resolve(process.env.HOME || '', 'Bureau/otadex-assets'),
  ];

  for (const c of candidates) {
    if (fs.existsSync(path.join(c, 'Animé pictures'))) return c;
  }

  console.log('\n⚠️  Repo otadex-assets introuvable automatiquement.');
  const answer = await ask('Chemin absolu vers otadex-assets : ');
  if (!fs.existsSync(path.join(answer, 'Animé pictures'))) {
    console.error(`❌  Dossier "Animé pictures" introuvable dans : ${answer}`);
    process.exit(1);
  }
  return answer;
}

// ── Lecture du préfixe depuis app_assets.dart ─────────────────────────────────
function detectPrefix(animeName) {
  try {
    const content = fs.readFileSync(APP_ASSETS, 'utf8');
    // Cherche : // XXX — [animeName]   prefix: pfx_
    const re = new RegExp(`\\/\\/\\s*[A-Z]+\\s*—\\s*${escapeRegex(animeName)}[^\\n]*prefix:\\s*([a-z0-9]+)_`, 'i');
    const m  = content.match(re);
    if (m) return m[1];
  } catch { /* ignore */ }

  // Fallback : 3 premières lettres
  return animeName.toLowerCase().replace(/[^a-z]/g, '').slice(0, 3);
}

function escapeRegex(str) {
  return str.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

// ── Étape A — Lister les images ───────────────────────────────────────────────
function listImages(animeDir) {
  const result = [];
  const chars  = fs.readdirSync(animeDir).filter(name => {
    const full = path.join(animeDir, name);
    return fs.statSync(full).isDirectory() && name !== 'README.md';
  });

  for (const charName of chars) {
    const charDir = path.join(animeDir, charName);
    const files   = fs.readdirSync(charDir)
      .filter(f => IMAGE_EXTS.has(path.extname(f).toLowerCase()) && f !== 'README.md')
      .map(f => path.join(charDir, f));
    if (files.length > 0) {
      result.push({ charName, files });
    }
  }
  return result;
}

// ── Étape B — Renommer + convertir en JPEG ────────────────────────────────────
async function renameImages(animeName, prefix, charImages) {
  const renamed = [];

  for (const { charName, files } of charImages) {
    const slug = toSlug(charName).slice(0, 4);
    const outDir = path.join(TEMP_IMAGES, animeName, charName, '_renamed');
    fs.mkdirSync(outDir, { recursive: true });

    const charRenamed = [];
    for (let i = 0; i < files.length; i++) {
      const src      = files[i];
      const destName = `${prefix}_${slug}${i + 1}.jpeg`;
      const dest     = path.join(outDir, destName);

      process.stdout.write(`    ${destName} ← ${path.basename(src)} ... `);
      await sharp(src).jpeg({ quality: 90 }).toFile(dest);
      console.log('✓');
      charRenamed.push(dest);
    }
    renamed.push({ charName, files: charRenamed });
  }
  return renamed;
}

// ── Étape C — Copier vers otadex-assets ──────────────────────────────────────
function copyToAssets(assetsRoot, animeName, charImages) {
  const urls = {};

  for (const { charName, files } of charImages) {
    const destDir = path.join(assetsRoot, 'Animé pictures', animeName, charName);
    fs.mkdirSync(destDir, { recursive: true });

    urls[charName] = [];
    for (const src of files) {
      const destName = path.basename(src);
      fs.copyFileSync(src, path.join(destDir, destName));
      const url = `${GITHUB_BASE}/${animeName}/${charName}/${destName}`;
      urls[charName].push(url);
    }
    console.log(`    📂  ${charName} → ${files.length} images`);
  }
  return urls;
}

// ── Étape D — Mettre à jour app_assets.dart ───────────────────────────────────
function updateAppAssets(animeName, prefix, charUrls) {
  let content = fs.readFileSync(APP_ASSETS, 'utf8');
  let updated = false;

  for (const [charName, urls] of Object.entries(charUrls)) {
    const varName = toVarName(charName);
    const charId  = `${prefix}-${toSlug(charName)}`;

    const emptyRe = new RegExp(`(static const List<String> ${escapeRegex(varName)} = )\\[\\]`, 'g');
    if (emptyRe.test(content)) {
      const urlListFull = urls.map(u => `    '${u}'`).join(',\n');
      content = content.replace(
        new RegExp(`(static const List<String> ${escapeRegex(varName)} = )\\[\\](;)`, 'g'),
        `$1[\n${urlListFull},\n  ]$2`
      );
      updated = true;
    } else {
      // Distingue "déjà remplie" (OK) de "variable absente" (problème silencieux)
      const existsRe = new RegExp(`static const List<String> ${escapeRegex(varName)}\\s*=`, 'g');
      if (!existsRe.test(content)) {
        console.warn(`  ⚠️  ${charName} : variable "${varName}" introuvable dans app_assets.dart — vérifier setup_anime.js`);
      }
    }
  }

  if (updated) {
    fs.writeFileSync(APP_ASSETS, content, 'utf8');
    console.log(`  ✅  app_assets.dart mis à jour avec les vraies URLs`);
  } else {
    console.log(`  ℹ️   app_assets.dart : listes déjà remplies ou variables non trouvées`);
  }
}

// ── Étape E — Git push otadex-assets ─────────────────────────────────────────
function gitPush(assetsRoot, animeName, charCount) {
  console.log('\n  🔄  git add + commit + push...');
  try {
    execSync('git add .', { cwd: assetsRoot, stdio: 'pipe' });
    execSync(`git commit -m "feat: add ${animeName} images (${charCount} persos)"`, {
      cwd: assetsRoot,
      stdio: 'pipe',
    });
    execSync('git push origin main', { cwd: assetsRoot, stdio: 'inherit' });
    console.log('  ✅  Push GitHub réussi');
    return true;
  } catch (err) {
    console.error('  ❌  Erreur git push :', err.message);
    return false;
  }
}

// ── Étape F — Relancer l'import Firestore ─────────────────────────────────────
function rerunImport(prefix, charUrls) {
  const scriptPath = path.join(SCRIPTS_DIR, `import_${prefix}.js`);
  if (!fs.existsSync(scriptPath)) {
    console.log(`  ⏭  import_${prefix}.js introuvable, skip.`);
    return;
  }

  // Met à jour les images[] dans le script d'import avec les vraies URLs
  let content = fs.readFileSync(scriptPath, 'utf8');
  let modified = false;

  for (const [charName, urls] of Object.entries(charUrls)) {
    const charId   = `${prefix}-${toSlug(charName)}`;
    const urlsJson = JSON.stringify(urls);
    // Remplace images: [], dans le bloc du personnage
    const re = new RegExp(
      `(id: '${escapeRegex(charId)}'[\\s\\S]*?images: )\\[\\]`,
      'g'
    );
    if (re.test(content)) {
      content  = content.replace(re, `$1${urlsJson}`);
      modified = true;
    }
  }

  if (modified) {
    fs.writeFileSync(scriptPath, content, 'utf8');
    console.log(`  ✅  import_${prefix}.js mis à jour avec les URLs d'images`);
  }

  console.log(`\n  🚀  Lancement import_${prefix}.js...`);
  const result = spawnSync('node', [scriptPath], { stdio: 'inherit', cwd: ROOT });
  if (result.status !== 0) {
    console.warn(`  ⚠️  Import échoué. Lance manuellement : node scripts/import_${prefix}.js`);
  }
}

// ── Prévisualisation URLs sans copie (dry-run) ────────────────────────────────
function computePreviewUrls(animeName, renamedImages) {
  const urls = {};
  for (const { charName, files } of renamedImages) {
    urls[charName] = files.map(f => {
      const destName = path.basename(f);
      return `${GITHUB_BASE}/${animeName}/${charName}/${destName}`;
    });
  }
  return urls;
}

// ── Point d'entrée ────────────────────────────────────────────────────────────
async function main() {
  const args     = process.argv.slice(2);
  const dryRun   = args.includes('--dry-run');
  const animeName = args.filter(a => a !== '--dry-run').join(' ');

  if (!animeName) {
    console.error('Usage : node scripts/push_images.js "My Hero Academia" [--dry-run]');
    process.exit(1);
  }

  if (dryRun) console.log('⚠️  Mode dry-run activé — aucune modification réelle ne sera effectuée\n');

  const animeDir = path.join(TEMP_IMAGES, animeName);
  if (!fs.existsSync(animeDir)) {
    console.error(`❌  Dossier introuvable : ${animeDir}`);
    console.error(`    Lance d'abord : node scripts/setup_anime.js <fichier.docx>`);
    process.exit(1);
  }

  console.log(`\n━━━ OTADEX — Push Images : ${animeName} ━━━\n`);

  const prefix = detectPrefix(animeName);
  console.log(`🏷️   Préfixe détecté : ${prefix}_\n`);

  console.log('📸  Étape A — Lecture des images...');
  const charImages = listImages(animeDir);
  if (charImages.length === 0) {
    console.error('❌  Aucune image trouvée. Dépose tes images dans temp_images/[Animé]/[Personnage]/');
    process.exit(1);
  }
  const totalImages = charImages.reduce((s, c) => s + c.files.length, 0);
  console.log(`  📁  ${charImages.length} personnages, ${totalImages} images au total\n`);

  console.log('🔄  Étape B — Renommage + conversion JPEG...');
  const renamed = await renameImages(animeName, prefix, charImages);
  console.log(`  ✅  ${renamed.reduce((s, c) => s + c.files.length, 0)} images converties\n`);

  // ── DRY-RUN : afficher la simulation et sortir ────────────────────────────
  if (dryRun) {
    const previewUrls = computePreviewUrls(animeName, renamed);

    console.log('━━━ [DRY-RUN] — Simulation (aucune modification réelle) ━━━\n');

    console.log('📋  Copies qui SERAIENT effectuées vers otadex-assets :');
    for (const { charName, files } of renamed) {
      console.log(`  ${charName} (${files.length} image(s))`);
      for (const f of files) console.log(`    → ${path.basename(f)}`);
    }

    console.log('\n🔗  URLs GitHub raw qui SERAIENT générées :');
    for (const [charName, urls] of Object.entries(previewUrls)) {
      console.log(`  ${charName} :`);
      for (const url of urls) console.log(`    ${url}`);
    }

    console.log('\n📝  Variables app_assets.dart qui SERAIENT mises à jour :');
    let appAssetsContent = '';
    try { appAssetsContent = fs.readFileSync(APP_ASSETS, 'utf8'); } catch { /* ignore */ }
    for (const [charName, urls] of Object.entries(previewUrls)) {
      const varName = toVarName(charName);
      const emptyRe  = new RegExp(`static const List<String> ${escapeRegex(varName)} = \\[\\]`);
      const existsRe = new RegExp(`static const List<String> ${escapeRegex(varName)}\\s*=`);
      if (emptyRe.test(appAssetsContent)) {
        console.log(`  ✅  ${varName} → ${urls.length} URL(s) seraient injectées`);
      } else if (existsRe.test(appAssetsContent)) {
        console.log(`  ℹ️   ${varName} → déjà remplie, ignorée`);
      } else {
        console.log(`  ⚠️  ${varName} → introuvable dans app_assets.dart`);
      }
    }

    console.log(`\n📤  git push origin main → otadex-assets (IGNORÉ en dry-run)`);
    console.log(`🔥  node scripts/import_${prefix}.js → Firestore (IGNORÉ en dry-run)`);
    console.log('\n✅  Dry-run terminé — aucune modification réelle effectuée.');
    return;
  }
  // ── FIN DRY-RUN ───────────────────────────────────────────────────────────

  console.log('🔍  Étape C — Localisation du repo otadex-assets...');
  const assetsRoot = await findOtadexAssets();
  console.log(`  📂  Trouvé : ${assetsRoot}\n`);

  console.log('📋  Copie vers otadex-assets...');
  const charUrls = copyToAssets(assetsRoot, animeName, renamed);

  console.log('\n📝  Étape D — Mise à jour app_assets.dart...');
  updateAppAssets(animeName, prefix, charUrls);

  console.log('\n📤  Étape E — Push GitHub...');
  const pushed = gitPush(assetsRoot, animeName, charImages.length);

  // Vérification URLs raw (5 sec d'attente CDN)
  if (pushed) {
    console.log('\n  ⏳  Attente 5s pour indexation GitHub CDN...');
    await new Promise(r => setTimeout(r, 5000));

    console.log('\n  🔗  URLs raw finales :');
    for (const [charName, urls] of Object.entries(charUrls)) {
      console.log(`    ${charName} : ${urls[0]}`);
    }
  }

  console.log('\n🔥  Étape F — Mise à jour Firestore...');
  rerunImport(prefix, charUrls);

  const totalRenamed = renamed.reduce((s, c) => s + c.files.length, 0);
  console.log(`
━━━ Images ${animeName} publiées ✅ ━━━
 Images renommées : ${totalRenamed}
 Pushées sur GitHub : ${pushed ? '✅' : '❌ (à faire manuellement)'}
 Firestore mis à jour : ✅

 Vérifier dans l'app → Hot restart Flutter
`);
}

main().catch(err => {
  console.error('\n❌  Erreur :', err.message);
  process.exit(1);
});
