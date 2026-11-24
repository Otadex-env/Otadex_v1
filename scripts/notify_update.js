#!/usr/bin/env node
/**
 * notify_update.js — Notifie tous les utilisateurs qu'une nouvelle version
 * d'OTADEX est disponible. À lancer après chaque publication sur le Play
 * Store (ou l'App Store).
 *
 * Usage :
 *   node scripts/notify_update.js
 *   node scripts/notify_update.js --notes "Tokyo Ghoul, corrections de bugs"
 *   node scripts/notify_update.js --title "..." --body "..."   (texte complet sur mesure)
 *   node scripts/notify_update.js --dry-run                    (aperçu, n'envoie rien)
 */

'use strict';

const fs = require('fs');
const path = require('path');
const sendNotification = require('./send_notification');

function getArg(flag) {
  const i = process.argv.indexOf(flag);
  return i !== -1 ? process.argv[i + 1] : undefined;
}
function hasFlag(flag) {
  return process.argv.includes(flag);
}

function getVersion() {
  try {
    const pubspec = fs.readFileSync(path.resolve(__dirname, '..', 'pubspec.yaml'), 'utf8');
    const m = pubspec.match(/^version:\s*(.+)$/m);
    return m ? m[1].trim() : null;
  } catch {
    return null;
  }
}

const version = getVersion();
const notes = getArg('--notes');
const dryRun = hasFlag('--dry-run');

const title = getArg('--title') ?? 'Nouvelle mise à jour disponible !';
const defaultBody = notes
  ? `Mets à jour OTADEX pour profiter de : ${notes}.`
  : 'Mets à jour OTADEX pour profiter des dernières nouveautés et corrections.';
const body = getArg('--body') ?? defaultBody;

console.log(`\n━━━ OTADEX — Notification mise à jour${version ? ` (v${version})` : ''} ━━━\n`);
console.log(`Titre : ${title}`);
console.log(`Corps : ${body}`);

if (dryRun) {
  console.log('\n(dry-run : rien n\'a été envoyé)');
  process.exit(0);
}

sendNotification({
  title,
  body,
  route: '/home',
  type: 'update_available',
})
  .then(() => {
    console.log('\n🎉  Notification de mise à jour envoyée avec succès.');
    process.exit(0);
  })
  .catch((e) => {
    console.error('❌ ', e.message || e);
    process.exit(1);
  });
