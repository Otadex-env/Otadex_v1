#!/usr/bin/env node
/**
 * import_tr.js — Importe Tokyo Revengers dans Firestore
 * Généré à partir de scripts/anime_data/tokyo-revengers.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_tr.js
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

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "tokyo-revengers" + '.json'), 'utf8'));
const { anime, creator, studio, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const studioData = {
  ...studio,
  animeIds: ["tokyo-revengers"],
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "tokyo-revengers"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "tr-takemichi-hanagaki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takemichi Hanagaki/tr_take1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takemichi Hanagaki/tr_take2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takemichi Hanagaki/tr_take3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takemichi Hanagaki/tr_take4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takemichi Hanagaki/tr_take5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takemichi Hanagaki/tr_take6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takemichi Hanagaki/tr_take7.jpeg"
  ],
  "tr-manjiro-sano-mikey": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj7.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj8.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj9.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj10.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Manjiro Sano « Mikey »/tr_manj11.jpeg"
  ],
  "tr-ken-ryuguji-draken": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ken Ryūgūji « Draken »/tr_kenr1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ken Ryūgūji « Draken »/tr_kenr2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ken Ryūgūji « Draken »/tr_kenr3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ken Ryūgūji « Draken »/tr_kenr4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ken Ryūgūji « Draken »/tr_kenr5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ken Ryūgūji « Draken »/tr_kenr6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ken Ryūgūji « Draken »/tr_kenr7.jpeg"
  ],
  "tr-keisuke-baji": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Keisuke Baji/tr_keis1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Keisuke Baji/tr_keis2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Keisuke Baji/tr_keis3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Keisuke Baji/tr_keis4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Keisuke Baji/tr_keis5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Keisuke Baji/tr_keis6.jpeg"
  ],
  "tr-chifuyu-matsuno": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Chifuyu Matsuno/tr_chif1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Chifuyu Matsuno/tr_chif2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Chifuyu Matsuno/tr_chif3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Chifuyu Matsuno/tr_chif4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Chifuyu Matsuno/tr_chif5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Chifuyu Matsuno/tr_chif6.jpeg"
  ],
  "tr-hinata-tachibana": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hinata Tachibana/tr_hina1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hinata Tachibana/tr_hina2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hinata Tachibana/tr_hina3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hinata Tachibana/tr_hina4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hinata Tachibana/tr_hina5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hinata Tachibana/tr_hina6.jpeg"
  ],
  "tr-tetta-kisaki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Tetta Kisaki/tr_tett1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Tetta Kisaki/tr_tett2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Tetta Kisaki/tr_tett3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Tetta Kisaki/tr_tett4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Tetta Kisaki/tr_tett5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Tetta Kisaki/tr_tett6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Tetta Kisaki/tr_tett7.jpeg"
  ],
  "tr-izana-kurokawa": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Izana Kurokawa/tr_izan1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Izana Kurokawa/tr_izan2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Izana Kurokawa/tr_izan3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Izana Kurokawa/tr_izan4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Izana Kurokawa/tr_izan5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Izana Kurokawa/tr_izan6.jpeg"
  ],
  "tr-kazutora-hanemiya": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kazutora Hanemiya/tr_kazu1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kazutora Hanemiya/tr_kazu2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kazutora Hanemiya/tr_kazu3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kazutora Hanemiya/tr_kazu4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kazutora Hanemiya/tr_kazu5.jpeg"
  ],
  "tr-shinichiro-sano": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Shinichiro Sano/tr_shin1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Shinichiro Sano/tr_shin2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Shinichiro Sano/tr_shin3.jpeg"
  ],
  "tr-naoto-tachibana": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Naoto Tachibana/tr_naot1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Naoto Tachibana/tr_naot2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Naoto Tachibana/tr_naot3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Naoto Tachibana/tr_naot4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Naoto Tachibana/tr_naot5.jpeg"
  ],
  "tr-emma-sano": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Emma Sano/tr_emma1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Emma Sano/tr_emma2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Emma Sano/tr_emma3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Emma Sano/tr_emma4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Emma Sano/tr_emma5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Emma Sano/tr_emma6.jpeg"
  ],
  "tr-haruchiyo-sanzu": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Haruchiyo Sanzu/tr_haru1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Haruchiyo Sanzu/tr_haru2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Haruchiyo Sanzu/tr_haru3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Haruchiyo Sanzu/tr_haru4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Haruchiyo Sanzu/tr_haru5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Haruchiyo Sanzu/tr_haru6.jpeg"
  ],
  "tr-shuji-hanma": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Shuji Hanma/tr_shuj1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Shuji Hanma/tr_shuj2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Shuji Hanma/tr_shuj3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Shuji Hanma/tr_shuj4.jpeg"
  ],
  "tr-takashi-mitsuya": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takashi Mitsuya/tr_taka1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takashi Mitsuya/tr_taka2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takashi Mitsuya/tr_taka3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takashi Mitsuya/tr_taka4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takashi Mitsuya/tr_taka5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takashi Mitsuya/tr_taka6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Takashi Mitsuya/tr_taka7.jpeg"
  ],
  "tr-kakucho": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kakuchō/tr_kaku1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kakuchō/tr_kaku2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kakuchō/tr_kaku3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kakuchō/tr_kaku4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kakuchō/tr_kaku5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Kakuchō/tr_kaku6.jpeg"
  ],
  "tr-hajime-kokonoi-koko": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hajime Kokonoi « Koko »/tr_haji1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hajime Kokonoi « Koko »/tr_haji2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hajime Kokonoi « Koko »/tr_haji3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hajime Kokonoi « Koko »/tr_haji4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hajime Kokonoi « Koko »/tr_haji5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hajime Kokonoi « Koko »/tr_haji6.jpeg"
  ],
  "tr-seishu-inui-inupi": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Seishu Inui « Inupi »/tr_seis1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Seishu Inui « Inupi »/tr_seis2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Seishu Inui « Inupi »/tr_seis3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Seishu Inui « Inupi »/tr_seis4.jpeg"
  ],
  "tr-hakkai-shiba": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hakkai Shiba/tr_hakk1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hakkai Shiba/tr_hakk2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hakkai Shiba/tr_hakk3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hakkai Shiba/tr_hakk4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hakkai Shiba/tr_hakk5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Hakkai Shiba/tr_hakk6.jpeg"
  ],
  "tr-ran-haitani": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ran Haitani/tr_ranh1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ran Haitani/tr_ranh2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Revengers/Ran Haitani/tr_ranh3.jpeg"
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
  console.log('\n━━━ OTADEX — Import Tokyo Revengers ━━━\n');

  await db.collection('creators').doc("ken-wakui").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  await db.collection('studios').doc("liden-films").set(studioData, { merge: true });
  console.log('✅  Studio ' + studioData.nom + ' importé');

  await db.collection('animes').doc("tokyo-revengers").set(animeData, { merge: true });
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

  console.log('\n🎉  Import Tokyo Revengers terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
