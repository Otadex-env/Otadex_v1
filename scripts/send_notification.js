/**
 * send_notification.js
 * Envoie une notification push à tous les abonnés OneSignal.
 *
 * Usage depuis un autre script :
 *   const sendNotification = require('./send_notification');
 *   await sendNotification({ title, body, route, type });
 *
 * Usage CLI :
 *   node scripts/send_notification.js --title "Hello" --body "World" --route /home
 */

const https = require('https');
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });

function getOneSignalConfig() {
  const appId = (
    process.env.ONESIGNAL_APP_ID ??
    process.env.APPIDONESIGNAL ??
    ''
  ).trim();
  const apiKey = (
    process.env.ONESIGNAL_API_KEY ??
    process.env.APIKEYONESIGNAL ??
    ''
  ).trim();

  if (!appId || !apiKey) {
    throw new Error(
      'Variables OneSignal manquantes. Définis ONESIGNAL_APP_ID/' +
        'ONESIGNAL_API_KEY ou APPIDONESIGNAL/APIKEYONESIGNAL.',
    );
  }

  return { appId, apiKey };
}

/**
 * @param {object} opts
 * @param {string} opts.title
 * @param {string} opts.body
 * @param {string} [opts.route]
 * @param {string} [opts.type]
 * @param {string} [opts.url]
 * @returns {Promise<object>}
 */
async function sendNotification({
  title,
  body,
  route = '/home',
  type = 'new_characters',
  url,
}) {
  if (!title || !body) {
    throw new Error(
      'title et body sont requis pour envoyer une notification OneSignal.',
    );
  }

  const { appId, apiKey } = getOneSignalConfig();
  const payload = JSON.stringify({
    app_id: appId,
    included_segments: ['All'],
    headings: { en: title, fr: title },
    contents: { en: body, fr: body },
    ...(url ? { url } : {}),
    data: { route, type },
  });

  return new Promise((resolve, reject) => {
    const req = https.request(
      {
        hostname: 'onesignal.com',
        path: '/api/v1/notifications',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          Authorization: `Basic ${apiKey}`,
          'Content-Length': Buffer.byteLength(payload),
        },
      },
      (res) => {
        const statusCode = res.statusCode ?? 0;
        let data = '';
        res.on('data', (chunk) => (data += chunk));
        res.on('end', () => {
          let json;
          try {
            json = data ? JSON.parse(data) : {};
          } catch (err) {
            reject(
              new Error(
                `Réponse OneSignal invalide (${statusCode}) : ${data}`,
              ),
            );
            return;
          }

          if (statusCode < 200 || statusCode >= 300 || json.errors) {
            reject(
              new Error(
                `Erreur OneSignal (${statusCode}) : ` +
                  JSON.stringify(json.errors ?? json),
              ),
            );
            return;
          }

          console.log(
            `✅ Notification OneSignal envoyée — recipients: ${json.recipients ?? '?'}`,
          );
          resolve(json);
        });
      },
    );

    req.on('error', reject);
    req.write(payload);
    req.end();
  });
}

module.exports = sendNotification;

if (require.main === module) {
  const args = process.argv.slice(2);
  /**
   * @param {string} flag
   * @returns {string | undefined}
   */
  const get = (flag) => {
    const i = args.indexOf(flag);
    return i !== -1 ? args[i + 1] : undefined;
  };

  sendNotification({
    title: get('--title') ?? 'OTADEX',
    body: get('--body') ?? 'Nouvelle mise à jour disponible !',
    route: get('--route') ?? '/home',
    type: get('--type') ?? 'new_characters',
    url: get('--url'),
  })
    .then(() => process.exit(0))
    .catch((err) => {
      console.error('❌ Erreur OneSignal :', err.message);
      process.exit(1);
    });
}
