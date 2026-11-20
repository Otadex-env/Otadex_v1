#!/usr/bin/env node
/**
 * import_ft.js — Importe Fairy Tail dans Firestore
 * Généré à partir de scripts/anime_data/fairy-tail.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_ft.js
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

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "fairy-tail" + '.json'), 'utf8'));
const { anime, creator, studio, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const studioData = {
  ...studio,
  animeIds: ["fairy-tail"],
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "fairy-tail"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "ft-natsu-dragneel": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Natsu Dragneel/ft_nats1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Natsu Dragneel/ft_nats2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Natsu Dragneel/ft_nats3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Natsu Dragneel/ft_nats4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Natsu Dragneel/ft_nats5.jpeg"
  ],
  "ft-lucy-heartfilia": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Lucy Heartfilia/ft_lucy1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Lucy Heartfilia/ft_lucy2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Lucy Heartfilia/ft_lucy3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Lucy Heartfilia/ft_lucy4.jpeg"
  ],
  "ft-erza-scarlet": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Erza Scarlet/ft_erza1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Erza Scarlet/ft_erza2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Erza Scarlet/ft_erza3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Erza Scarlet/ft_erza4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Erza Scarlet/ft_erza5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Erza Scarlet/ft_erza6.jpeg"
  ],
  "ft-gray-fullbuster": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gray Fullbuster/ft_gray1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gray Fullbuster/ft_gray2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gray Fullbuster/ft_gray3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gray Fullbuster/ft_gray4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gray Fullbuster/ft_gray5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gray Fullbuster/ft_gray6.jpeg"
  ],
  "ft-happy": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Happy/ft_happ1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Happy/ft_happ2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Happy/ft_happ3.jpeg"
  ],
  "ft-wendy-marvell": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Wendy Marvell/ft_wend1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Wendy Marvell/ft_wend2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Wendy Marvell/ft_wend3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Wendy Marvell/ft_wend4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Wendy Marvell/ft_wend5.jpeg"
  ],
  "ft-carla": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Carla/ft_carl1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Carla/ft_carl2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Carla/ft_carl3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Carla/ft_carl4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Carla/ft_carl5.jpeg"
  ],
  "ft-gajeel-redfox": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gajeel Redfox/ft_gaje1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gajeel Redfox/ft_gaje2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gajeel Redfox/ft_gaje3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gajeel Redfox/ft_gaje4.jpeg"
  ],
  "ft-laxus-dreyar": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Laxus Dreyar/ft_laxu1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Laxus Dreyar/ft_laxu2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Laxus Dreyar/ft_laxu3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Laxus Dreyar/ft_laxu4.jpeg"
  ],
  "ft-mirajane-strauss": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Mirajane Strauss/ft_mira1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Mirajane Strauss/ft_mira2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Mirajane Strauss/ft_mira3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Mirajane Strauss/ft_mira4.jpeg"
  ],
  "ft-makarov-dreyar": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Makarov Dreyar/ft_maka1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Makarov Dreyar/ft_maka2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Makarov Dreyar/ft_maka3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Makarov Dreyar/ft_maka4.jpeg"
  ],
  "ft-juvia-lockser": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Juvia Lockser/ft_juvi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Juvia Lockser/ft_juvi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Juvia Lockser/ft_juvi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Juvia Lockser/ft_juvi4.jpeg"
  ],
  "ft-levy-mcgarden": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Levy McGarden/ft_levy1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Levy McGarden/ft_levy2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Levy McGarden/ft_levy3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Levy McGarden/ft_levy4.jpeg"
  ],
  "ft-cana-alberona": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Cana Alberona/ft_cana1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Cana Alberona/ft_cana2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Cana Alberona/ft_cana3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Cana Alberona/ft_cana4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Cana Alberona/ft_cana5.jpeg"
  ],
  "ft-gildarts-clive": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gildarts Clive/ft_gild1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gildarts Clive/ft_gild2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gildarts Clive/ft_gild3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Gildarts Clive/ft_gild4.jpeg"
  ],
  "ft-jellal-fernandes": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Jellal Fernandes/ft_jell1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Jellal Fernandes/ft_jell2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Jellal Fernandes/ft_jell3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Jellal Fernandes/ft_jell4.jpeg"
  ],
  "ft-zeref-dragneel": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Zeref Dragneel/ft_zere1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Zeref Dragneel/ft_zere2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Zeref Dragneel/ft_zere3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Zeref Dragneel/ft_zere4.jpeg"
  ],
  "ft-mavis-vermillion": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Mavis Vermillion/ft_mavi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Mavis Vermillion/ft_mavi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Mavis Vermillion/ft_mavi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Mavis Vermillion/ft_mavi4.jpeg"
  ],
  "ft-igneel": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Igneel/ft_igne1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Igneel/ft_igne2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Igneel/ft_igne3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Igneel/ft_igne4.jpeg"
  ],
  "ft-acnologia": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Acnologia/ft_acno1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Acnologia/ft_acno2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Acnologia/ft_acno3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Fairy Tail/Acnologia/ft_acno4.jpeg"
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
  console.log('\n━━━ OTADEX — Import Fairy Tail ━━━\n');

  await db.collection('creators').doc("hiro-mashima").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  await db.collection('studios').doc("a1-pictures").set(studioData, { merge: true });
  console.log('✅  Studio ' + studioData.nom + ' importé');

  await db.collection('animes').doc("fairy-tail").set(animeData, { merge: true });
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

  console.log('\n🎉  Import Fairy Tail terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
