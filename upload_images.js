// @ts-nocheck
const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'tilqui.appspot.com'
});

const bucket = admin.storage().bucket();
const baseDir = process.argv[2] || './assets/upload/characters';

/** @param {string} filename */
function contentTypeFor(filename) {
  return filename.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';
}

async function uploadAll() {
  if (!fs.existsSync(baseDir)) {
    throw new Error(
      `Dossier introuvable: ${baseDir}. Passe le dossier source en argument.`
    );
  }
  const animes = fs.readdirSync(baseDir);
  for (const anime of animes) {
    const animePath = path.join(baseDir, anime);
    if (!fs.statSync(animePath).isDirectory()) continue;
    const characters = fs.readdirSync(animePath);
    for (const character of characters) {
      const charPath = path.join(animePath, character);
      if (!fs.statSync(charPath).isDirectory()) continue;
      const images = fs.readdirSync(charPath)
        .filter(f => f.match(/\.(jpg|jpeg|png)$/i));
      for (const image of images) {
        const localPath = path.join(charPath, image);
        const cleanAnime = anime.replace(/[^a-zA-Z0-9]/g, '_');
        const cleanChar = character.replace(/[^a-zA-Z0-9]/g, '_');
        const cleanImg = image.replace(/[^a-zA-Z0-9.]/g, '_');
        const storagePath =
          `characters/${cleanAnime}/${cleanChar}/${cleanImg}`;
        try {
          await bucket.upload(localPath, {
            destination: storagePath,
            metadata: { contentType: contentTypeFor(image) },
            predefinedAcl: 'publicRead',
          });
          console.log(`✅ ${storagePath}`);
        } catch (e) {
          console.log(`❌ ${storagePath} — ${e.message}`);
        }
      }
    }
  }
  console.log('Upload terminé !');
}

uploadAll();
