#!/usr/bin/env node
/**
 * import_aot.js — Importe L'Attaque des Titans dans Firestore
 * Généré à partir de scripts/anime_data/attack-on-titan.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_aot.js
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

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "attack-on-titan" + '.json'), 'utf8'));
const { anime, creator, studio, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const studioData = {
  ...studio,
  animeIds: ["attack-on-titan"],
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "attack-on-titan"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "aot-eren-yeager": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Eren Yeager/aot_eren1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Eren Yeager/aot_eren2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Eren Yeager/aot_eren3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Eren Yeager/aot_eren4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Eren Yeager/aot_eren5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Eren Yeager/aot_eren6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Eren Yeager/aot_eren7.jpeg"
  ],
  "aot-levi-ackerman": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Levi Ackerman/aot_levi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Levi Ackerman/aot_levi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Levi Ackerman/aot_levi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Levi Ackerman/aot_levi4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Levi Ackerman/aot_levi5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Levi Ackerman/aot_levi6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Levi Ackerman/aot_levi7.jpeg"
  ],
  "aot-mikasa-ackerman": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Mikasa Ackerman/aot_mika1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Mikasa Ackerman/aot_mika2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Mikasa Ackerman/aot_mika3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Mikasa Ackerman/aot_mika4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Mikasa Ackerman/aot_mika5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Mikasa Ackerman/aot_mika6.jpeg"
  ],
  "aot-armin-arlert": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Armin Arlert/aot_armi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Armin Arlert/aot_armi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Armin Arlert/aot_armi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Armin Arlert/aot_armi4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Armin Arlert/aot_armi5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Armin Arlert/aot_armi6.jpeg"
  ],
  "aot-erwin-smith": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Erwin Smith/aot_erwi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Erwin Smith/aot_erwi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Erwin Smith/aot_erwi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Erwin Smith/aot_erwi4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Erwin Smith/aot_erwi5.jpeg"
  ],
  "aot-hange-zoe": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Hange Zoë/aot_hang1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Hange Zoë/aot_hang2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Hange Zoë/aot_hang3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Hange Zoë/aot_hang4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Hange Zoë/aot_hang5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Hange Zoë/aot_hang6.jpeg"
  ],
  "aot-reiner-braun": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Reiner Braun/aot_rein1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Reiner Braun/aot_rein2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Reiner Braun/aot_rein3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Reiner Braun/aot_rein4.jpeg"
  ],
  "aot-annie-leonhart": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Annie Leonhart/aot_anni1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Annie Leonhart/aot_anni2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Annie Leonhart/aot_anni3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Annie Leonhart/aot_anni4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Annie Leonhart/aot_anni5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Annie Leonhart/aot_anni6.jpeg"
  ],
  "aot-zeke-yeager": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Zeke Yeager/aot_zeke1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Zeke Yeager/aot_zeke2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Zeke Yeager/aot_zeke3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Zeke Yeager/aot_zeke4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Zeke Yeager/aot_zeke5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Zeke Yeager/aot_zeke6.jpeg"
  ],
  "aot-jean-kirstein": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Jean Kirstein/aot_jean1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Jean Kirstein/aot_jean2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Jean Kirstein/aot_jean3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Jean Kirstein/aot_jean4.jpeg"
  ],
  "aot-historia-reiss": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Historia Reiss/aot_hist1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Historia Reiss/aot_hist2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Historia Reiss/aot_hist3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Historia Reiss/aot_hist4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Historia Reiss/aot_hist5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Historia Reiss/aot_hist6.jpeg"
  ],
  "aot-sasha-blouse": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Sasha Blouse/aot_sash1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Sasha Blouse/aot_sash2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Sasha Blouse/aot_sash3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Sasha Blouse/aot_sash4.jpeg"
  ],
  "aot-connie-springer": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Connie Springer/aot_conn1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Connie Springer/aot_conn2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Connie Springer/aot_conn3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Connie Springer/aot_conn4.jpeg"
  ],
  "aot-bertholdt-hoover": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Bertholdt Hoover/aot_bert1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Bertholdt Hoover/aot_bert2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Bertholdt Hoover/aot_bert3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Bertholdt Hoover/aot_bert4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Bertholdt Hoover/aot_bert5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Bertholdt Hoover/aot_bert6.jpeg"
  ],
  "aot-ymir": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Ymir/aot_ymir1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Ymir/aot_ymir2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Ymir/aot_ymir3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Ymir/aot_ymir4.jpeg"
  ],
  "aot-grisha-yeager": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Grisha Yeager/aot_gris1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Grisha Yeager/aot_gris2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Grisha Yeager/aot_gris3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Grisha Yeager/aot_gris4.jpeg"
  ],
  "aot-falco-grice": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Falco Grice/aot_falc1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Falco Grice/aot_falc2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Falco Grice/aot_falc3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Falco Grice/aot_falc4.jpeg"
  ],
  "aot-gabi-braun": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Gabi Braun/aot_gabi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Gabi Braun/aot_gabi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Gabi Braun/aot_gabi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Gabi Braun/aot_gabi4.jpeg"
  ],
  "aot-pieck-finger": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Pieck Finger/aot_piec1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Pieck Finger/aot_piec2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Pieck Finger/aot_piec3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Pieck Finger/aot_piec4.jpeg"
  ],
  "aot-porco-galliard": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Porco Galliard/aot_porc1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Porco Galliard/aot_porc2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Porco Galliard/aot_porc3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Attaque des Titans/Porco Galliard/aot_porc4.jpeg"
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
  console.log('\n━━━ OTADEX — Import L'Attaque des Titans ━━━\n');

  await db.collection('creators').doc("hajime-isayama").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  await db.collection('studios').doc("wit-studio").set(studioData, { merge: true });
  console.log('✅  Studio ' + studioData.nom + ' importé');

  await db.collection('animes').doc("attack-on-titan").set(animeData, { merge: true });
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

  console.log('\n🎉  Import L'Attaque des Titans terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
