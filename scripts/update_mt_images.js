#!/usr/bin/env node
/**
 * update_mt_images.js — Patch les images[] et imagePath dans Firestore pour les persos MT
 *
 * Usage :
 *   env NODE_OPTIONS='--require ./scripts/google_time_offset.js' \
 *     node scripts/update_mt_images.js
 */

'use strict';

const admin = require('firebase-admin');
const path  = require('path');
const fs    = require('fs');

const KEY = path.resolve(__dirname, '..', 'serviceAccountKey.json');
if (!fs.existsSync(KEY)) {
  console.error('❌  serviceAccountKey.json introuvable.');
  process.exit(1);
}

admin.initializeApp({ credential: admin.credential.cert(require(KEY)) });
const db = admin.firestore();

const BASE = 'https://raw.githubusercontent.com/Otadex-env/otadex-assets/main/Animé pictures/Mushoku Tensei';

const imageMap = {
  'mt-rudeus-greyrat': [
    `${BASE}/Rudeus Greyrat/mt_rude1.jpeg`,
    `${BASE}/Rudeus Greyrat/mt_rude2.jpeg`,
    `${BASE}/Rudeus Greyrat/mt_rude3.jpeg`,
    `${BASE}/Rudeus Greyrat/mt_rude4.jpeg`,
    `${BASE}/Rudeus Greyrat/mt_rude5.jpeg`,
    `${BASE}/Rudeus Greyrat/mt_rude6.jpeg`,
    `${BASE}/Rudeus Greyrat/mt_rude7.jpeg`,
  ],
  'mt-roxy-migurdia': [
    `${BASE}/Roxy Migurdia/mt_roxy1.jpeg`,
    `${BASE}/Roxy Migurdia/mt_roxy2.jpeg`,
    `${BASE}/Roxy Migurdia/mt_roxy3.jpeg`,
    `${BASE}/Roxy Migurdia/mt_roxy4.jpeg`,
    `${BASE}/Roxy Migurdia/mt_roxy5.jpeg`,
    `${BASE}/Roxy Migurdia/mt_roxy6.jpeg`,
    `${BASE}/Roxy Migurdia/mt_roxy7.jpeg`,
  ],
  'mt-sylphiette-greyrat': [
    `${BASE}/Sylphiette Greyrat/mt_sylp1.jpeg`,
    `${BASE}/Sylphiette Greyrat/mt_sylp2.jpeg`,
    `${BASE}/Sylphiette Greyrat/mt_sylp3.jpeg`,
    `${BASE}/Sylphiette Greyrat/mt_sylp4.jpeg`,
    `${BASE}/Sylphiette Greyrat/mt_sylp5.jpeg`,
    `${BASE}/Sylphiette Greyrat/mt_sylp6.jpeg`,
    `${BASE}/Sylphiette Greyrat/mt_sylp7.jpeg`,
    `${BASE}/Sylphiette Greyrat/mt_sylp8.jpeg`,
  ],
  'mt-eris-boreas-greyrat': [
    `${BASE}/Eris Boreas Greyrat/mt_eris1.jpeg`,
    `${BASE}/Eris Boreas Greyrat/mt_eris2.jpeg`,
    `${BASE}/Eris Boreas Greyrat/mt_eris3.jpeg`,
    `${BASE}/Eris Boreas Greyrat/mt_eris4.jpeg`,
    `${BASE}/Eris Boreas Greyrat/mt_eris5.jpeg`,
    `${BASE}/Eris Boreas Greyrat/mt_eris6.jpeg`,
    `${BASE}/Eris Boreas Greyrat/mt_eris7.jpeg`,
  ],
  'mt-ruijerd-superdia': [
    `${BASE}/Ruijerd Superdia/mt_ruij1.jpeg`,
    `${BASE}/Ruijerd Superdia/mt_ruij2.jpeg`,
    `${BASE}/Ruijerd Superdia/mt_ruij3.jpeg`,
    `${BASE}/Ruijerd Superdia/mt_ruij4.jpeg`,
    `${BASE}/Ruijerd Superdia/mt_ruij5.jpeg`,
    `${BASE}/Ruijerd Superdia/mt_ruij6.jpeg`,
  ],
  'mt-paul-greyrat': [
    `${BASE}/Paul Greyrat/mt_paul1.jpeg`,
    `${BASE}/Paul Greyrat/mt_paul2.jpeg`,
    `${BASE}/Paul Greyrat/mt_paul3.jpeg`,
    `${BASE}/Paul Greyrat/mt_paul4.jpeg`,
    `${BASE}/Paul Greyrat/mt_paul5.jpeg`,
    `${BASE}/Paul Greyrat/mt_paul6.jpeg`,
  ],
  'mt-orsted': [
    `${BASE}/Orsted/mt_orst1.jpeg`,
    `${BASE}/Orsted/mt_orst2.jpeg`,
    `${BASE}/Orsted/mt_orst3.jpeg`,
    `${BASE}/Orsted/mt_orst4.jpeg`,
    `${BASE}/Orsted/mt_orst5.jpeg`,
    `${BASE}/Orsted/mt_orst6.jpeg`,
  ],
  'mt-hitogami': [
    `${BASE}/Hitogami/mt_hito1.jpeg`,
    `${BASE}/Hitogami/mt_hito2.jpeg`,
  ],
  'mt-ghislaine-dedoldia': [
    `${BASE}/Ghislaine Dedoldia/mt_ghis1.jpeg`,
    `${BASE}/Ghislaine Dedoldia/mt_ghis2.jpeg`,
    `${BASE}/Ghislaine Dedoldia/mt_ghis3.jpeg`,
    `${BASE}/Ghislaine Dedoldia/mt_ghis4.jpeg`,
    `${BASE}/Ghislaine Dedoldia/mt_ghis5.jpeg`,
  ],
  'mt-perugius-dola': [],
  'mt-zenith-greyrat': [
    `${BASE}/Zenith Greyrat/mt_zeni1.jpeg`,
    `${BASE}/Zenith Greyrat/mt_zeni2.jpeg`,
    `${BASE}/Zenith Greyrat/mt_zeni3.jpeg`,
    `${BASE}/Zenith Greyrat/mt_zeni4.jpeg`,
    `${BASE}/Zenith Greyrat/mt_zeni5.jpeg`,
  ],
  'mt-norn-greyrat': [
    `${BASE}/Norn Greyrat/mt_norn1.jpeg`,
    `${BASE}/Norn Greyrat/mt_norn2.jpeg`,
    `${BASE}/Norn Greyrat/mt_norn3.jpeg`,
    `${BASE}/Norn Greyrat/mt_norn4.jpeg`,
    `${BASE}/Norn Greyrat/mt_norn5.jpeg`,
    `${BASE}/Norn Greyrat/mt_norn6.jpeg`,
  ],
  'mt-aisha-greyrat': [
    `${BASE}/Aisha Greyrat/mt_aish1.jpeg`,
    `${BASE}/Aisha Greyrat/mt_aish2.jpeg`,
    `${BASE}/Aisha Greyrat/mt_aish3.jpeg`,
    `${BASE}/Aisha Greyrat/mt_aish4.jpeg`,
    `${BASE}/Aisha Greyrat/mt_aish5.jpeg`,
  ],
  'mt-elinalise-dragonroad': [
    `${BASE}/Elinalise Dragonroad/mt_elin1.jpeg`,
    `${BASE}/Elinalise Dragonroad/mt_elin2.jpeg`,
    `${BASE}/Elinalise Dragonroad/mt_elin3.jpeg`,
    `${BASE}/Elinalise Dragonroad/mt_elin4.jpeg`,
    `${BASE}/Elinalise Dragonroad/mt_elin5.jpeg`,
    `${BASE}/Elinalise Dragonroad/mt_elin6.jpeg`,
  ],
  'mt-cliff-grimoire': [
    `${BASE}/Cliff Grimoire/mt_clif1.jpeg`,
    `${BASE}/Cliff Grimoire/mt_clif2.jpeg`,
    `${BASE}/Cliff Grimoire/mt_clif3.jpeg`,
    `${BASE}/Cliff Grimoire/mt_clif4.jpeg`,
    `${BASE}/Cliff Grimoire/mt_clif5.jpeg`,
    `${BASE}/Cliff Grimoire/mt_clif6.jpeg`,
  ],
  'mt-zanoba-shirone': [
    `${BASE}/Zanoba Shirone/mt_zano1.jpeg`,
    `${BASE}/Zanoba Shirone/mt_zano2.jpeg`,
    `${BASE}/Zanoba Shirone/mt_zano3.jpeg`,
    `${BASE}/Zanoba Shirone/mt_zano4.jpeg`,
    `${BASE}/Zanoba Shirone/mt_zano5.jpeg`,
  ],
  'mt-nanahoshi-shizuka': [
    `${BASE}/Nanahoshi Shizuka/mt_nana1.jpeg`,
    `${BASE}/Nanahoshi Shizuka/mt_nana2.jpeg`,
    `${BASE}/Nanahoshi Shizuka/mt_nana3.jpeg`,
    `${BASE}/Nanahoshi Shizuka/mt_nana4.jpeg`,
    `${BASE}/Nanahoshi Shizuka/mt_nana5.jpeg`,
    `${BASE}/Nanahoshi Shizuka/mt_nana6.jpeg`,
  ],
  'mt-ariel-anemoi-asura': [
    `${BASE}/Ariel Anemoi Asura/mt_arie1.jpeg`,
    `${BASE}/Ariel Anemoi Asura/mt_arie2.jpeg`,
    `${BASE}/Ariel Anemoi Asura/mt_arie3.jpeg`,
    `${BASE}/Ariel Anemoi Asura/mt_arie4.jpeg`,
    `${BASE}/Ariel Anemoi Asura/mt_arie5.jpeg`,
    `${BASE}/Ariel Anemoi Asura/mt_arie6.jpeg`,
  ],
  'mt-lilia-greyrat': [
    `${BASE}/Lilia Greyrat/mt_lili1.jpeg`,
    `${BASE}/Lilia Greyrat/mt_lili2.jpeg`,
    `${BASE}/Lilia Greyrat/mt_lili3.jpeg`,
    `${BASE}/Lilia Greyrat/mt_lili4.jpeg`,
    `${BASE}/Lilia Greyrat/mt_lili5.jpeg`,
  ],
  'mt-badigadi': [
    `${BASE}/Badigadi/mt_badi1.jpeg`,
    `${BASE}/Badigadi/mt_badi2.jpeg`,
    `${BASE}/Badigadi/mt_badi3.jpeg`,
    `${BASE}/Badigadi/mt_badi4.jpeg`,
  ],
};

async function main() {
  console.log('\n━━━ OTADEX — Patch images MT dans Firestore ━━━\n');

  const batch = db.batch();
  let count = 0;

  for (const [id, images] of Object.entries(imageMap)) {
    const ref = db.collection('characters').doc(id);
    batch.update(ref, {
      images,
      imagePath: images[0] ?? '',
    });
    console.log(`  → ${id} (${images.length} images)`);
    count++;
  }

  await batch.commit();
  console.log(`\n✅  ${count} personnages mis à jour`);
  process.exit(0);
}

main().catch(e => {
  console.error('❌ ', e.message || e);
  process.exit(1);
});
