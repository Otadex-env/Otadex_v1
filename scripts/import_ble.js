#!/usr/bin/env node
/**
 * import_ble.js — Importe Bleach dans Firestore
 * Généré à partir de scripts/anime_data/bleach.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_ble.js
 *
 * Note : Studio Pierrot est déjà importé (partagé avec Naruto Shippuden et
 * Tokyo Ghoul). On ne touche qu'au champ animeIds (arrayUnion).
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

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "bleach" + '.json'), 'utf8'));
const { anime, creator, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "bleach"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "ble-ichigo-kurosaki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo7.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo8.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo9.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo10.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo11.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo12.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo13.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Ichigo Kurosaki/ble_ichigo14.jpeg"
  ],
  "ble-rukia-kuchiki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rukia Kuchiki/ble_rukia1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rukia Kuchiki/ble_rukia2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rukia Kuchiki/ble_rukia3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rukia Kuchiki/ble_rukia4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rukia Kuchiki/ble_rukia5.jpeg"
  ],
  "ble-orihime-inoue": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Orihime Inoue/ble_orihime1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Orihime Inoue/ble_orihime2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Orihime Inoue/ble_orihime3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Orihime Inoue/ble_orihime4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Orihime Inoue/ble_orihime5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Orihime Inoue/ble_orihime6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Orihime Inoue/ble_orihime7.jpeg"
  ],
  "ble-yasutora-sado": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yasutora Sado (Chad)/ble_chad1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yasutora Sado (Chad)/ble_chad2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yasutora Sado (Chad)/ble_chad3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yasutora Sado (Chad)/ble_chad4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yasutora Sado (Chad)/ble_chad5.jpeg"
  ],
  "ble-uryu-ishida": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Uryu Ishida/ble_uryu1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Uryu Ishida/ble_uryu2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Uryu Ishida/ble_uryu3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Uryu Ishida/ble_uryu4.jpeg"
  ],
  "ble-renji-abarai": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Renji Abarai/ble_renji1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Renji Abarai/ble_renji2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Renji Abarai/ble_renji3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Renji Abarai/ble_renji4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Renji Abarai/ble_renji5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Renji Abarai/ble_renji6.jpeg"
  ],
  "ble-byakuya-kuchiki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Byakuya Kuchiki/ble_byaku1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Byakuya Kuchiki/ble_byaku2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Byakuya Kuchiki/ble_byaku3.jpeg"
  ],
  "ble-kenpachi-zaraki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kenpachi Zaraki/ble_kenpa1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kenpachi Zaraki/ble_kenpa2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kenpachi Zaraki/ble_kenpa3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kenpachi Zaraki/ble_kenpa4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kenpachi Zaraki/ble_kenpa5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kenpachi Zaraki/ble_kenpa6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kenpachi Zaraki/ble_kenpa7.jpeg"
  ],
  "ble-toshiro-hitsugaya": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Toshiro Hitsugaya/ble_toshi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Toshiro Hitsugaya/ble_toshi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Toshiro Hitsugaya/ble_toshi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Toshiro Hitsugaya/ble_toshi4.jpeg"
  ],
  "ble-sosuke-aizen": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Sosuke Aizen/ble_aizen1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Sosuke Aizen/ble_aizen2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Sosuke Aizen/ble_aizen3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Sosuke Aizen/ble_aizen4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Sosuke Aizen/ble_aizen5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Sosuke Aizen/ble_aizen6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Sosuke Aizen/ble_aizen7.jpeg"
  ],
  "ble-kisuke-urahara": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kisuke Urahara/ble_kisuke1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kisuke Urahara/ble_kisuke2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kisuke Urahara/ble_kisuke3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kisuke Urahara/ble_kisuke4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kisuke Urahara/ble_kisuke5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kisuke Urahara/ble_kisuke6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Kisuke Urahara/ble_kisuke7.jpeg"
  ],
  "ble-yoruichi-shihoin": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yoruichi Shihoin/ble_yoruichi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yoruichi Shihoin/ble_yoruichi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yoruichi Shihoin/ble_yoruichi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yoruichi Shihoin/ble_yoruichi4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yoruichi Shihoin/ble_yoruichi5.jpeg"
  ],
  "ble-isshin-kurosaki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Isshin Kurosaki/ble_isshin1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Isshin Kurosaki/ble_isshin2.jpeg"
  ],
  "ble-genryusai-yamamoto": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Genryusai Shigekuni Yamamoto/ble_yamamoto1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Genryusai Shigekuni Yamamoto/ble_yamamoto2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Genryusai Shigekuni Yamamoto/ble_yamamoto3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Genryusai Shigekuni Yamamoto/ble_yamamoto4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Genryusai Shigekuni Yamamoto/ble_yamamoto5.jpeg"
  ],
  "ble-retsu-unohana": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Retsu Unohana/ble_unohana1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Retsu Unohana/ble_unohana2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Retsu Unohana/ble_unohana3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Retsu Unohana/ble_unohana4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Retsu Unohana/ble_unohana5.jpeg"
  ],
  "ble-shunsui-kyoraku": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Shunsui Kyoraku/ble_shunsui1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Shunsui Kyoraku/ble_shunsui2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Shunsui Kyoraku/ble_shunsui3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Shunsui Kyoraku/ble_shunsui4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Shunsui Kyoraku/ble_shunsui5.jpeg"
  ],
  "ble-mayuri-kurotsuchi": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Mayuri Kurotsuchi/ble_mayuri1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Mayuri Kurotsuchi/ble_mayuri2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Mayuri Kurotsuchi/ble_mayuri3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Mayuri Kurotsuchi/ble_mayuri4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Mayuri Kurotsuchi/ble_mayuri5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Mayuri Kurotsuchi/ble_mayuri6.jpeg"
  ],
  "ble-yhwach": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yhwach/ble_yhwach1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yhwach/ble_yhwach2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yhwach/ble_yhwach3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yhwach/ble_yhwach4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yhwach/ble_yhwach5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Yhwach/ble_yhwach6.jpeg"
  ],
  "ble-rangiku-matsumoto": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rangiku Matsumoto/ble_rangiku1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rangiku Matsumoto/ble_rangiku2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rangiku Matsumoto/ble_rangiku3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rangiku Matsumoto/ble_rangiku4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rangiku Matsumoto/ble_rangiku5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Rangiku Matsumoto/ble_rangiku6.jpeg"
  ],
  "ble-momo-hinamori": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Momo Hinamori/ble_momo1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Momo Hinamori/ble_momo2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Momo Hinamori/ble_momo3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Bleach/Momo Hinamori/ble_momo4.jpeg"
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
  console.log('\n━━━ OTADEX — Import Bleach ━━━\n');

  await db.collection('creators').doc("tite-kubo").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  await db.collection('studios').doc("studio-pierrot").set(
    { animeIds: FieldValue.arrayUnion("bleach") },
    { merge: true },
  );
  console.log('✅  Studio Pierrot mis à jour (animeIds += bleach)');

  await db.collection('animes').doc("bleach").set(animeData, { merge: true });
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

  console.log('\n🎉  Import Bleach terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
