#!/usr/bin/env node
/**
 * import_db.js — Importe Dragon Ball dans Firestore
 * Généré à partir de scripts/anime_data/dragon-ball.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_db.js
 *
 * Note : le studio Toei Animation est déjà importé (partagé avec One Piece).
 * On ne touche qu'au champ animeIds (arrayUnion), jamais au reste du doc.
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

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "dragon-ball" + '.json'), 'utf8'));
const { anime, creator, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "dragon-ball"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "db-son-goku": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goku/db_goku1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goku/db_goku2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goku/db_goku3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goku/db_goku4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goku/db_goku5.jpeg"
  ],
  "db-vegeta": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Vegeta/db_vege1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Vegeta/db_vege2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Vegeta/db_vege3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Vegeta/db_vege4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Vegeta/db_vege5.jpeg"
  ],
  "db-son-gohan": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Gohan/db_goha1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Gohan/db_goha2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Gohan/db_goha3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Gohan/db_goha4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Gohan/db_goha5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Gohan/db_goha6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Gohan/db_goha7.jpeg"
  ],
  "db-piccolo": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Piccolo/db_picc1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Piccolo/db_picc2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Piccolo/db_picc3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Piccolo/db_picc4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Piccolo/db_picc5.jpeg"
  ],
  "db-krillin": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Krillin/db_kril1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Krillin/db_kril2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Krillin/db_kril3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Krillin/db_kril4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Krillin/db_kril5.jpeg"
  ],
  "db-bulma": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Bulma/db_bulm1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Bulma/db_bulm2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Bulma/db_bulm3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Bulma/db_bulm4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Bulma/db_bulm5.jpeg"
  ],
  "db-freezer": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Freezer/db_free1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Freezer/db_free2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Freezer/db_free3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Freezer/db_free4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Freezer/db_free5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Freezer/db_free6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Freezer/db_free7.jpeg"
  ],
  "db-trunks": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Trunks/db_trun1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Trunks/db_trun2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Trunks/db_trun3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Trunks/db_trun4.jpeg"
  ],
  "db-cell": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Cell/db_cell1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Cell/db_cell2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Cell/db_cell3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Cell/db_cell4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Cell/db_cell5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Cell/db_cell6.jpeg"
  ],
  "db-majin-buu": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Majin Buu/db_maji1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Majin Buu/db_maji2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Majin Buu/db_maji3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Majin Buu/db_maji4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Majin Buu/db_maji5.jpeg"
  ],
  "db-beerus": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Beerus/db_beer1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Beerus/db_beer2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Beerus/db_beer3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Beerus/db_beer4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Beerus/db_beer5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Beerus/db_beer6.jpeg"
  ],
  "db-whis": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Whis/db_whis1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Whis/db_whis2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Whis/db_whis3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Whis/db_whis4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Whis/db_whis5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Whis/db_whis6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Whis/db_whis7.jpeg"
  ],
  "db-kame-sennin": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Kame Sennin/db_kame1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Kame Sennin/db_kame2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Kame Sennin/db_kame3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Kame Sennin/db_kame4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Kame Sennin/db_kame5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Kame Sennin/db_kame6.jpeg"
  ],
  "db-tenshinhan": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Tenshinhan/db_tens1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Tenshinhan/db_tens2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Tenshinhan/db_tens3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Tenshinhan/db_tens4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Tenshinhan/db_tens5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Tenshinhan/db_tens6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Tenshinhan/db_tens7.jpeg"
  ],
  "db-yamcha": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Yamcha/db_yamc1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Yamcha/db_yamc2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Yamcha/db_yamc3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Yamcha/db_yamc4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Yamcha/db_yamc5.jpeg"
  ],
  "db-chi-chi": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Chi-Chi/db_chic1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Chi-Chi/db_chic2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Chi-Chi/db_chic3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Chi-Chi/db_chic4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Chi-Chi/db_chic5.jpeg"
  ],
  "db-son-goten": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goten/db_gote1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goten/db_gote2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goten/db_gote3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goten/db_gote4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Son Goten/db_gote5.jpeg"
  ],
  "db-mr-satan": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Mr. Satan/db_sata1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Mr. Satan/db_sata2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Mr. Satan/db_sata3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Mr. Satan/db_sata4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Mr. Satan/db_sata5.jpeg"
  ],
  "db-videl": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Videl/db_vide1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Videl/db_vide2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Videl/db_vide3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Videl/db_vide4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Dragon Ball/Videl/db_vide5.jpeg"
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
  console.log('\n━━━ OTADEX — Import Dragon Ball ━━━\n');

  await db.collection('creators').doc("akira-toriyama").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  // Toei Animation existe déjà (partagé avec One Piece) : on ajoute juste
  // "dragon-ball" à son animeIds sans toucher au reste du document.
  await db.collection('studios').doc("toei-animation").set(
    { animeIds: FieldValue.arrayUnion("dragon-ball") },
    { merge: true },
  );
  console.log('✅  Studio Toei Animation mis à jour (animeIds += dragon-ball)');

  await db.collection('animes').doc("dragon-ball").set(animeData, { merge: true });
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

  console.log('\n🎉  Import Dragon Ball terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
