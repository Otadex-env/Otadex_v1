/**
 * notify_monthly_vote.js
 * Envoie la notification "Vote Fan du Mois ouvert" via l'API REST OneSignal.
 * Compatible GitHub Actions (variables d'env CI) et usage local (.env).
 *
 * Lancement direct :
 *   node scripts/notify_monthly_vote.js
 */

const https = require('https');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });

const ONESIGNAL_API_KEY = process.env.ONESIGNAL_API_KEY;
const ONESIGNAL_APP_ID = process.env.ONESIGNAL_APP_ID;

if (!ONESIGNAL_API_KEY || !ONESIGNAL_APP_ID) {
  console.error(
    "❌ Variables d'env manquantes : ONESIGNAL_API_KEY et ONESIGNAL_APP_ID sont requis.",
  );
  process.exit(1);
}

const now = new Date();
const month = now.toLocaleString('fr-FR', { month: 'long' });
const monthCapitalized = month.charAt(0).toUpperCase() + month.slice(1);

const TITLE = '🏆 Vote Fan du Mois ouvert !';
const BODY = 'Soutenez votre personnage préféré et devenez Fan #1 ce mois-ci !';
const DEEP_LINK = 'otadex://home';

(async () => {
  console.log(
    `🗳️  Envoi de la notification Vote Fan du Mois — ${monthCapitalized} ${now.getFullYear()}...\n`,
  );

  const payload = JSON.stringify({
    app_id: ONESIGNAL_APP_ID,
    included_segments: ['All'],
    headings: { en: TITLE, fr: TITLE },
    contents: { en: BODY, fr: BODY },
    url: DEEP_LINK,
    data: { route: '/home', type: 'monthly_vote' },
  });

  await new Promise((resolve, reject) => {
    const options = {
      hostname: 'onesignal.com',
      path: '/api/v1/notifications',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        Authorization: `Key ${ONESIGNAL_API_KEY}`,
        'Content-Length': Buffer.byteLength(payload),
      },
    };

    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', (chunk) => (data += chunk));
      res.on('end', () => {
        const json = JSON.parse(data);
        if (json.errors) {
          console.warn('⚠️  OneSignal warning:', JSON.stringify(json.errors));
        } else {
          console.log(`✅ Notification envoyée — recipients: ${json.recipients ?? '?'}`);
        }
        resolve();
      });
    });

    req.on('error', (err) => {
      console.error('❌ Erreur OneSignal :', err.message);
      reject(err);
    });

    req.write(payload);
    req.end();
  });

  console.log('\n✅ Notification vote mensuel envoyée avec succès !');
  process.exit(0);
})().catch((err) => {
  console.error('❌ Erreur :', err.message);
  process.exit(1);
});
