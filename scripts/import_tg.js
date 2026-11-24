#!/usr/bin/env node
/**
 * import_tg.js — Importe Tokyo Ghoul dans Firestore
 * Généré à partir de scripts/anime_data/tokyo-ghoul.json
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     /home/tilstack/.cache/ms-playwright-go/1.50.1/node \
 *     scripts/import_tg.js
 *
 * Note : le studio Studio Pierrot est déjà importé (partagé avec Naruto
 * Shippuden). On ne touche qu'au champ animeIds (arrayUnion), jamais au
 * reste du doc.
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

const data = JSON.parse(fs.readFileSync(path.join(__dirname, 'anime_data', "tokyo-ghoul" + '.json'), 'utf8'));
const { anime, creator, characters } = data;

const creatorData = {
  ...creator,
  created_at: FieldValue.serverTimestamp(),
};

const animeData = {
  ...anime,
  genres: normalizeGenresStrict(anime.genres, "tokyo-ghoul"),
  created_at: FieldValue.serverTimestamp(),
};

const IMAGES_BY_ID = {
  "tg-ken-kaneki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane7.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane8.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ken Kaneki/tg_kane9.jpeg"
  ],
  "tg-touka-kirishima": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Touka Kirishima/tg_touk1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Touka Kirishima/tg_touk2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Touka Kirishima/tg_touk3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Touka Kirishima/tg_touk4.jpeg"
  ],
  "tg-hideyoshi-hide-nagachika": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hideyoshi « Hide » Nagachika/tg_hide1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hideyoshi « Hide » Nagachika/tg_hide2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hideyoshi « Hide » Nagachika/tg_hide3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hideyoshi « Hide » Nagachika/tg_hide4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hideyoshi « Hide » Nagachika/tg_hide5.jpeg"
  ],
  "tg-rize-kamishiro": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Rize Kamishiro/tg_rize1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Rize Kamishiro/tg_rize2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Rize Kamishiro/tg_rize3.jpeg"
  ],
  "tg-yoshimura": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yoshimura/tg_yoshi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yoshimura/tg_yoshi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yoshimura/tg_yoshi3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yoshimura/tg_yoshi4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yoshimura/tg_yoshi5.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yoshimura/tg_yoshi6.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yoshimura/tg_yoshi7.jpeg"
  ],
  "tg-nishiki-nishio": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Nishiki Nishio/tg_nishi1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Nishiki Nishio/tg_nishi2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Nishiki Nishio/tg_nishi3.jpeg"
  ],
  "tg-shuu-tsukiyama": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Shuu Tsukiyama/tg_tsuki1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Shuu Tsukiyama/tg_tsuki2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Shuu Tsukiyama/tg_tsuki3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Shuu Tsukiyama/tg_tsuki4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Shuu Tsukiyama/tg_tsuki5.jpeg"
  ],
  "tg-uta": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Uta/tg_uta1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Uta/tg_uta2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Uta/tg_uta3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Uta/tg_uta4.jpeg"
  ],
  "tg-eto-yoshimura": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Eto Yoshimura/tg_eto1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Eto Yoshimura/tg_eto2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Eto Yoshimura/tg_eto3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Eto Yoshimura/tg_eto4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Eto Yoshimura/tg_eto5.jpeg"
  ],
  "tg-koutarou-amon": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Koutarou Amon/tg_amon1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Koutarou Amon/tg_amon2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Koutarou Amon/tg_amon3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Koutarou Amon/tg_amon4.jpeg"
  ],
  "tg-akira-mado": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Akira Mado/tg_akira1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Akira Mado/tg_akira2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Akira Mado/tg_akira3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Akira Mado/tg_akira4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Akira Mado/tg_akira5.jpeg"
  ],
  "tg-kishou-arima": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kishou Arima/tg_arima1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kishou Arima/tg_arima2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kishou Arima/tg_arima3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kishou Arima/tg_arima4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kishou Arima/tg_arima5.jpeg"
  ],
  "tg-juuzou-suzuya": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Juuzou Suzuya/tg_juzo1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Juuzou Suzuya/tg_juzo2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Juuzou Suzuya/tg_juzo3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Juuzou Suzuya/tg_juzo4.jpeg"
  ],
  "tg-ayato-kirishima": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ayato Kirishima/tg_ayato1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ayato Kirishima/tg_ayato2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ayato Kirishima/tg_ayato3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ayato Kirishima/tg_ayato4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Ayato Kirishima/tg_ayato5.jpeg"
  ],
  "tg-hinami-fueguchi": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hinami Fueguchi/tg_hinami1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hinami Fueguchi/tg_hinami2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hinami Fueguchi/tg_hinami3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Hinami Fueguchi/tg_hinami4.jpeg"
  ],
  "tg-renji-yomo": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Renji Yomo/tg_renji1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Renji Yomo/tg_renji2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Renji Yomo/tg_renji3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Renji Yomo/tg_renji4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Renji Yomo/tg_renji5.jpeg"
  ],
  "tg-yakumo-oomori": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yakumo Oomori/tg_yamori1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yakumo Oomori/tg_yamori2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yakumo Oomori/tg_yamori3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yakumo Oomori/tg_yamori4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Yakumo Oomori/tg_yamori5.jpeg"
  ],
  "tg-kureo-mado": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kureo Mado/tg_kureo1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kureo Mado/tg_kureo2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kureo Mado/tg_kureo3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Kureo Mado/tg_kureo4.jpeg"
  ],
  "tg-tatara": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Tatara/tg_tatara1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Tatara/tg_tatara2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Tatara/tg_tatara3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Tatara/tg_tatara4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Tatara/tg_tatara5.jpeg"
  ],
  "tg-naki": [
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Naki/tg_naki1.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Naki/tg_naki2.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Naki/tg_naki3.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Naki/tg_naki4.jpeg",
    "https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Tokyo Ghoul/Naki/tg_naki5.jpeg"
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
  console.log('\n━━━ OTADEX — Import Tokyo Ghoul ━━━\n');

  await db.collection('creators').doc("sui-ishida").set(creatorData, { merge: true });
  console.log('✅  Créateur ' + creatorData.nom + ' importé');

  // Studio Pierrot existe déjà (partagé avec Naruto Shippuden) : on ajoute
  // juste "tokyo-ghoul" à son animeIds sans toucher au reste du document.
  await db.collection('studios').doc("studio-pierrot").set(
    { animeIds: FieldValue.arrayUnion("tokyo-ghoul") },
    { merge: true },
  );
  console.log('✅  Studio Pierrot mis à jour (animeIds += tokyo-ghoul)');

  await db.collection('animes').doc("tokyo-ghoul").set(animeData, { merge: true });
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

  console.log('\n🎉  Import Tokyo Ghoul terminé !');
  process.exit(0);
}

main().catch((e) => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
