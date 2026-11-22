#!/usr/bin/env node
/**
 * import_mha.js — Importe My Hero Academia dans Firestore
 * Généré à partir de scripts/anime_data/my-hero-academia.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_mha.js
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

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "my-hero-academia" + '.json'), 'utf8'));
const { anime, creator, studio, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const studioData = {
  ...studio,
  animeIds: ["my-hero-academia"],
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "my-hero-academia"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "mha-izuku-midoriya": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuk1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuk2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuk3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuk4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuk5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuk6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Izuku Midoriya/mha_izuk7.jpeg"
  ],
  "mha-katsuki-bakugo": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Katsuki Bakugo/mha_kats1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Katsuki Bakugo/mha_kats2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Katsuki Bakugo/mha_kats3.jpeg"
  ],
  "mha-shoto-todoroki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shoto Todoroki/mha_shot1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shoto Todoroki/mha_shot2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shoto Todoroki/mha_shot3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shoto Todoroki/mha_shot4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shoto Todoroki/mha_shot5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shoto Todoroki/mha_shot6.jpeg"
  ],
  "mha-ochaco-uraraka": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Ochaco Uraraka/mha_ocha1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Ochaco Uraraka/mha_ocha2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Ochaco Uraraka/mha_ocha3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Ochaco Uraraka/mha_ocha4.jpeg"
  ],
  "mha-tenya-ida": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tenya Ida/mha_teny1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tenya Ida/mha_teny2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tenya Ida/mha_teny3.jpeg"
  ],
  "mha-all-might": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All Might/mha_allm1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All Might/mha_allm2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All Might/mha_allm3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All Might/mha_allm4.jpeg"
  ],
  "mha-shota-aizawa": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shota Aizawa/mha_shot1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shota Aizawa/mha_shot2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shota Aizawa/mha_shot3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Shota Aizawa/mha_shot4.jpeg"
  ],
  "mha-enji-todoroki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Enji Todoroki/mha_enji1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Enji Todoroki/mha_enji2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Enji Todoroki/mha_enji3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Enji Todoroki/mha_enji4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Enji Todoroki/mha_enji5.jpeg"
  ],
  "mha-tomura-shigaraki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tomura Shigaraki/mha_tomu1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tomura Shigaraki/mha_tomu2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tomura Shigaraki/mha_tomu3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tomura Shigaraki/mha_tomu4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tomura Shigaraki/mha_tomu5.jpeg"
  ],
  "mha-all-for-one": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All For One/mha_allf1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All For One/mha_allf2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All For One/mha_allf3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All For One/mha_allf4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All For One/mha_allf5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/All For One/mha_allf6.jpeg"
  ],
  "mha-dabi": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Dabi/mha_dabi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Dabi/mha_dabi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Dabi/mha_dabi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Dabi/mha_dabi4.jpeg"
  ],
  "mha-himiko-toga": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Himiko Toga/mha_himi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Himiko Toga/mha_himi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Himiko Toga/mha_himi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Himiko Toga/mha_himi4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Himiko Toga/mha_himi5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Himiko Toga/mha_himi6.jpeg"
  ],
  "mha-keigo-takami": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Keigo Takami/mha_keig1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Keigo Takami/mha_keig2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Keigo Takami/mha_keig3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Keigo Takami/mha_keig4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Keigo Takami/mha_keig5.jpeg"
  ],
  "mha-mirio-togata": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Mirio Togata/mha_miri1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Mirio Togata/mha_miri2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Mirio Togata/mha_miri3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Mirio Togata/mha_miri4.jpeg"
  ],
  "mha-eijiro-kirishima": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Eijiro Kirishima/mha_eiji1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Eijiro Kirishima/mha_eiji2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Eijiro Kirishima/mha_eiji3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Eijiro Kirishima/mha_eiji4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Eijiro Kirishima/mha_eiji5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Eijiro Kirishima/mha_eiji6.jpeg"
  ],
  "mha-tsuyu-asui": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tsuyu Asui/mha_tsuy1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tsuyu Asui/mha_tsuy2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tsuyu Asui/mha_tsuy3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Tsuyu Asui/mha_tsuy4.jpeg"
  ],
  "mha-momo-yaoyorozu": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Momo Yaoyorozu/mha_momo1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Momo Yaoyorozu/mha_momo2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Momo Yaoyorozu/mha_momo3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Momo Yaoyorozu/mha_momo4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Momo Yaoyorozu/mha_momo5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Momo Yaoyorozu/mha_momo6.jpeg"
  ],
  "mha-fumikage-tokoyami": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Fumikage Tokoyami/mha_fumi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Fumikage Tokoyami/mha_fumi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Fumikage Tokoyami/mha_fumi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Fumikage Tokoyami/mha_fumi4.jpeg"
  ],
  "mha-denki-kaminari": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Denki Kaminari/mha_denk1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Denki Kaminari/mha_denk2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Denki Kaminari/mha_denk3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Denki Kaminari/mha_denk4.jpeg"
  ],
  "mha-minoru-mineta": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Minoru Mineta/mha_mino1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Minoru Mineta/mha_mino2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Minoru Mineta/mha_mino3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/My Hero Academia/Minoru Mineta/mha_mino4.jpeg"
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
  console.log('\n━━━ OTADEX — Import My Hero Academia ━━━\n');

  await db.collection('creators').doc("kohei-horikoshi").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  await db.collection('studios').doc("bones").set(studioData, { merge: true });
  console.log('✅  Studio ' + studioData.nom + ' importé');

  await db.collection('animes').doc("my-hero-academia").set(animeData, { merge: true });
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

  console.log('\n🎉  Import My Hero Academia terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
