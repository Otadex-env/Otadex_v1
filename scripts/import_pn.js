#!/usr/bin/env node
/**
 * import_pn.js — Importe The Promised Neverland dans Firestore
 * Généré à partir de scripts/anime_data/promised-neverland.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_pn.js
 */

'use strict';

const admin = require('firebase-admin');
const path  = require('path');
const fs    = require('fs');
const sendNotification = require('./send_notification');
const { normalizeGenresStrict } = require('./anime_workflow/genres');

const KEY = path.resolve(__dirname, '..', 'serviceAccountKey.json');
if (!fs.existsSync(KEY)) {
  console.error('❌  serviceAccountKey.json introuvable à la racine.');
  process.exit(1);
}

admin.initializeApp({ credential: admin.credential.cert(require(KEY)) });
const db = admin.firestore();
const { FieldValue } = admin.firestore;

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "promised-neverland" + '.json'), 'utf8'));
const { anime, creator, studio, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const studioData = {
  ...studio,
  animeIds: ["the-promised-neverland"],
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "the-promised-neverland"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "pn-emma": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Emma/pn_emma1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Emma/pn_emma2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Emma/pn_emma3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Emma/pn_emma4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Emma/pn_emma5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Emma/pn_emma6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Emma/pn_emma7.jpeg"
  ],
  "pn-norman": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Norman/pn_norm1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Norman/pn_norm2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Norman/pn_norm3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Norman/pn_norm4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Norman/pn_norm5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Norman/pn_norm6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Norman/pn_norm7.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Norman/pn_norm8.jpeg"
  ],
  "pn-ray": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Ray/pn_ray1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Ray/pn_ray2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Ray/pn_ray3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Ray/pn_ray4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Ray/pn_ray5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Ray/pn_ray6.jpeg"
  ],
  "pn-isabella": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Isabella/pn_isab1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Isabella/pn_isab2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Isabella/pn_isab3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Isabella/pn_isab4.jpeg"
  ],
  "pn-don": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Don/pn_don1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Don/pn_don2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Don/pn_don3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Don/pn_don4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Don/pn_don5.jpeg"
  ],
  "pn-gilda": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Gilda/pn_gild1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Gilda/pn_gild2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Gilda/pn_gild3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Gilda/pn_gild4.jpeg"
  ],
  "pn-sister-krone": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sister Krone/pn_kron1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sister Krone/pn_kron2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sister Krone/pn_kron3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sister Krone/pn_kron4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sister Krone/pn_kron5.jpeg"
  ],
  "pn-phil": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Phil/pn_phil1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Phil/pn_phil2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Phil/pn_phil3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Phil/pn_phil4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Phil/pn_phil5.jpeg"
  ],
  "pn-mujika": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Mujika/pn_muji1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Mujika/pn_muji2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Mujika/pn_muji3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Mujika/pn_muji4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Mujika/pn_muji5.jpeg"
  ],
  "pn-sonju": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sonju/pn_sonj1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sonju/pn_sonj2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sonju/pn_sonj3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sonju/pn_sonj4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Sonju/pn_sonj5.jpeg"
  ],
  "pn-peter-ratri": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Peter Ratri/pn_petr1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Peter Ratri/pn_petr2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Peter Ratri/pn_petr3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Peter Ratri/pn_petr4.jpeg"
  ],
  "pn-anna": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Anna/pn_anna1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Anna/pn_anna2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Anna/pn_anna3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Anna/pn_anna4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Anna/pn_anna5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Anna/pn_anna6.jpeg"
  ],
  "pn-thoma": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Thoma/pn_thom1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Thoma/pn_thom2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Thoma/pn_thom3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Thoma/pn_thom4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Thoma/pn_thom5.jpeg"
  ],
  "pn-lannion": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Lannion/pn_lann1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Lannion/pn_lann2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Lannion/pn_lann3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Lannion/pn_lann4.jpeg"
  ],
  "pn-conny": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Conny/pn_conn1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Conny/pn_conn2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Conny/pn_conn3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Conny/pn_conn4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Conny/pn_conn5.jpeg"
  ],
  "pn-barbara": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Barbara/pn_barb1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Barbara/pn_barb2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Barbara/pn_barb3.jpeg"
  ],
  "pn-zazie": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Zazie/pn_zazi1.jpeg"
  ],
  "pn-cislo": [],
  "pn-leslie": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Leslie/pn_lesl1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Leslie/pn_lesl2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Leslie/pn_lesl3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Leslie/pn_lesl4.jpeg"
  ],
  "pn-jemima": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Jemima/pn_jemi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Jemima/pn_jemi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Jemima/pn_jemi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Jemima/pn_jemi4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/The Promised Neverland/Jemima/pn_jemi5.jpeg"
  ]
};

const charactersData = characters.map((c) => {
  const images = IMAGES_BY_ID[c.id] || [];
  return {
    ...c,
    images,
    imagePath: images[0] || '',
    created_at: FieldValue.serverTimestamp(),
  };
});

async function main() {
  console.log('\n━━━ OTADEX — Import The Promised Neverland ━━━\n');

  await db.collection('creators').doc("kaiu-shirai").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  await db.collection('studios').doc("cloverworks").set(studioData, { merge: true });
  console.log('✅  Studio ' + studioData.nom + ' importé');

  await db.collection('animes').doc("the-promised-neverland").set(animeData, { merge: true });
  console.log('✅  Animé ' + animeData.titre + ' importé');

  const BATCH_SIZE = 20;
  for (let i = 0; i < charactersData.length; i += BATCH_SIZE) {
    const batch = db.batch();
    const slice = charactersData.slice(i, i + BATCH_SIZE);
    for (const c of slice) {
      const { id, ...fields } = c;
      batch.set(db.collection('characters').doc(id), fields, { merge: true });
      console.log(`  → ${c.nom} (${id}) — ${fields.images.length} image(s)`);
    }
    await batch.commit();
  }
  console.log(`✅  ${charactersData.length} personnages importés`);

  console.log('\n🎉  Import The Promised Neverland terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
