#!/usr/bin/env node
/**
 * import_rz.js — Importe Re:Zero − Starting Life in Another World dans Firestore
 * Généré à partir de scripts/anime_data/re-zero.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_rz.js
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

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "re-zero" + '.json'), 'utf8'));
const { anime, creator, studio, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const studioData = {
  ...studio,
  animeIds: ["re-zero"],
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "re-zero"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "rz-natsuki-subaru": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Natsuki Subaru/rz_nats1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Natsuki Subaru/rz_nats2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Natsuki Subaru/rz_nats3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Natsuki Subaru/rz_nats4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Natsuki Subaru/rz_nats5.jpeg"
  ],
  "rz-emilia": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Emilia/rz_emil1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Emilia/rz_emil2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Emilia/rz_emil3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Emilia/rz_emil4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Emilia/rz_emil5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Emilia/rz_emil6.jpeg"
  ],
  "rz-rem": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Rem/rz_rem1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Rem/rz_rem2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Rem/rz_rem3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Rem/rz_rem4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Rem/rz_rem5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Rem/rz_rem6.jpeg"
  ],
  "rz-ram": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Ram/rz_ram1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Ram/rz_ram2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Ram/rz_ram3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Ram/rz_ram4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Ram/rz_ram5.jpeg"
  ],
  "rz-beatrice": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Beatrice/rz_beat1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Beatrice/rz_beat2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Beatrice/rz_beat3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Beatrice/rz_beat4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Beatrice/rz_beat5.jpeg"
  ],
  "rz-puck": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Puck/rz_puck1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Puck/rz_puck2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Puck/rz_puck3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Puck/rz_puck4.jpeg"
  ],
  "rz-roswaal-l-mathers": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Roswaal L. Mathers/rz_rosw1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Roswaal L. Mathers/rz_rosw2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Roswaal L. Mathers/rz_rosw3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Roswaal L. Mathers/rz_rosw4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Roswaal L. Mathers/rz_rosw5.jpeg"
  ],
  "rz-reinhard-van-astrea": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Reinhard van Astrea/rz_rein1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Reinhard van Astrea/rz_rein2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Reinhard van Astrea/rz_rein3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Reinhard van Astrea/rz_rein4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Reinhard van Astrea/rz_rein5.jpeg"
  ],
  "rz-wilhelm-van-astrea": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Wilhelm van Astrea/rz_wilh1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Wilhelm van Astrea/rz_wilh2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Wilhelm van Astrea/rz_wilh3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Wilhelm van Astrea/rz_wilh4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Wilhelm van Astrea/rz_wilh5.jpeg"
  ],
  "rz-crusch-karsten": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Crusch Karsten/rz_crus1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Crusch Karsten/rz_crus2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Crusch Karsten/rz_crus3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Crusch Karsten/rz_crus4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Crusch Karsten/rz_crus5.jpeg"
  ],
  "rz-felt": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Felt/rz_felt1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Felt/rz_felt2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Felt/rz_felt3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Felt/rz_felt4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Felt/rz_felt5.jpeg"
  ],
  "rz-priscilla-barielle": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Priscilla Barielle/rz_pris1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Priscilla Barielle/rz_pris2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Priscilla Barielle/rz_pris3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Priscilla Barielle/rz_pris4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Priscilla Barielle/rz_pris5.jpeg"
  ],
  "rz-anastasia-hoshin": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Anastasia Hoshin/rz_anas1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Anastasia Hoshin/rz_anas2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Anastasia Hoshin/rz_anas3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Anastasia Hoshin/rz_anas4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Anastasia Hoshin/rz_anas5.jpeg"
  ],
  "rz-julius-euclius": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Julius Euclius/rz_juli1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Julius Euclius/rz_juli2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Julius Euclius/rz_juli3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Julius Euclius/rz_juli4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Julius Euclius/rz_juli5.jpeg"
  ],
  "rz-otto-suwen": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Otto Suwen/rz_otto1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Otto Suwen/rz_otto2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Otto Suwen/rz_otto3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Otto Suwen/rz_otto4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Otto Suwen/rz_otto5.jpeg"
  ],
  "rz-garfiel-tinsel": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Garfiel Tinsel/rz_garf1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Garfiel Tinsel/rz_garf2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Garfiel Tinsel/rz_garf3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Garfiel Tinsel/rz_garf4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Garfiel Tinsel/rz_garf5.jpeg"
  ],
  "rz-echidna": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Echidna/rz_echi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Echidna/rz_echi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Echidna/rz_echi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Echidna/rz_echi4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Echidna/rz_echi5.jpeg"
  ],
  "rz-satella": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Satella/rz_sate1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Satella/rz_sate2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Satella/rz_sate3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Satella/rz_sate4.jpeg"
  ],
  "rz-petelgeuse-romanee-conti": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Petelgeuse Romanée-Conti/rz_pete1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Petelgeuse Romanée-Conti/rz_pete2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Petelgeuse Romanée-Conti/rz_pete3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Petelgeuse Romanée-Conti/rz_pete4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Petelgeuse Romanée-Conti/rz_pete5.jpeg"
  ],
  "rz-elsa-granhiert": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Elsa Granhiert/rz_elsa1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Elsa Granhiert/rz_elsa2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Elsa Granhiert/rz_elsa3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Elsa Granhiert/rz_elsa4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Re Zero/Elsa Granhiert/rz_elsa5.jpeg"
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
  console.log('\n━━━ OTADEX — Import Re:Zero − Starting Life in Another World ━━━\n');

  await db.collection('creators').doc("tappei-nagatsuki").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  await db.collection('studios').doc("white-fox").set(studioData, { merge: true });
  console.log('✅  Studio ' + studioData.nom + ' importé');

  await db.collection('animes').doc("re-zero").set(animeData, { merge: true });
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

  console.log('\n🎉  Import Re:Zero − Starting Life in Another World terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
