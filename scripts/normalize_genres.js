#!/usr/bin/env node
/**
 * normalize_genres.js — Normalise les genres de tous les animés Firestore
 * selon le vocabulaire canonique (scripts/anime_workflow/genres.js).
 *
 * Par défaut : DRY-RUN (aucune écriture, affiche le diff).
 * Écriture réelle : --apply (sauvegarde d'abord les valeurs actuelles dans
 * scripts/backups/genres_backup_<horodatage>.json).
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     node scripts/normalize_genres.js --dry-run
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     node scripts/normalize_genres.js --apply
 *
 * Les valeurs hors vocabulaire ne sont JAMAIS supprimées : elles sont
 * signalées et laissées telles quelles (à trancher : alias ou nouveau genre).
 * Les personnages n'ont pas de champ genre ; le script vérifie qu'aucun n'en
 * porte un (`genres` / `genre`) et le signale sinon.
 */

'use strict';

const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');
const { normalizeGenres, CANONICAL } = require('./anime_workflow/genres');

const args = new Set(process.argv.slice(2));
const APPLY = args.has('--apply');
if (APPLY && args.has('--dry-run')) {
  console.error('❌  --apply et --dry-run sont exclusifs.');
  process.exit(1);
}

const KEY = path.resolve(__dirname, '..', 'serviceAccountKey.json');
if (!fs.existsSync(KEY)) {
  console.error('❌  serviceAccountKey.json introuvable à la racine.');
  process.exit(1);
}
admin.initializeApp({ credential: admin.credential.cert(require(KEY)) });
const db = admin.firestore();

const same = (a, b) => a.length === b.length && a.every((v, i) => v === b[i]);

async function main() {
  console.log(APPLY ? '⚠️  MODE ÉCRITURE (--apply)\n' : '🔎  DRY-RUN (aucune écriture)\n');

  const snap = await db.collection('animes').get();
  const changes = [];
  const unknownAll = new Map(); // valeur hors vocabulaire → [animeIds]
  let unchanged = 0;

  for (const doc of snap.docs) {
    const current = doc.get('genres');
    if (!Array.isArray(current)) {
      console.log(`  ⚠️  ${doc.id} : pas de champ genres[] (ignoré)`);
      continue;
    }
    const { unknown } = normalizeGenres(current);
    for (const u of unknown) {
      if (!unknownAll.has(u)) unknownAll.set(u, []);
      unknownAll.get(u).push(doc.id);
    }
    // Les valeurs inconnues sont conservées à leur place (jamais perdues).
    const next = canonicalizeKeepingUnknown(current);

    if (same(current, next)) {
      unchanged++;
      continue;
    }
    changes.push({ id: doc.id, before: current, after: next });
  }

  for (const c of changes) {
    console.log(`  ✏️  ${c.id}`);
    console.log(`      avant : ${JSON.stringify(c.before)}`);
    console.log(`      après : ${JSON.stringify(c.after)}`);
  }
  console.log(
    `\n${snap.size} animés · ${changes.length} à modifier · ${unchanged} déjà conformes`
  );

  if (unknownAll.size > 0) {
    console.log('\n❗ Valeurs hors vocabulaire (laissées telles quelles) :');
    for (const [value, ids] of unknownAll) {
      console.log(`   "${value}" ← ${ids.join(', ')}`);
    }
    console.log(`   Vocabulaire : ${CANONICAL.join(', ')}`);
  }

  // Les personnages ne doivent pas porter de genre : on vérifie.
  const chars = await db.collection('characters').get();
  const withGenre = chars.docs.filter(
    (d) => d.get('genres') !== undefined || d.get('genre') !== undefined
  );
  console.log(
    `\n${chars.size} personnages · ${withGenre.length} portent un champ genre(s)` +
      (withGenre.length ? ` : ${withGenre.map((d) => d.id).join(', ')}` : '')
  );

  if (!APPLY) {
    console.log('\nDry-run terminé. Relance avec --apply pour écrire.');
    return;
  }
  if (changes.length === 0) {
    console.log('\nRien à écrire.');
    return;
  }

  const dir = path.resolve(__dirname, 'backups');
  fs.mkdirSync(dir, { recursive: true });
  const stamp = new Date().toISOString().replace(/[:.]/g, '-');
  const backup = path.join(dir, `genres_backup_${stamp}.json`);
  fs.writeFileSync(
    backup,
    JSON.stringify(
      Object.fromEntries(changes.map((c) => [c.id, c.before])),
      null,
      2
    )
  );
  console.log(`\n💾  Sauvegarde : ${path.relative(process.cwd(), backup)}`);

  const batch = db.batch();
  for (const c of changes) {
    batch.update(db.collection('animes').doc(c.id), { genres: c.after });
  }
  await batch.commit();
  console.log(`✅  ${changes.length} animé(s) mis à jour.`);
}

/** Canonise en conservant, à leur position, les valeurs hors vocabulaire. */
function canonicalizeKeepingUnknown(current) {
  const out = [];
  for (const raw of current) {
    const { genres } = normalizeGenres([raw]);
    const value = genres.length ? genres[0] : String(raw).trim();
    if (value && !out.includes(value)) out.push(value);
  }
  return out;
}

main().catch((e) => {
  console.error('❌ ', e);
  process.exit(1);
});
