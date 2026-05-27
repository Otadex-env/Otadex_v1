/**
 * send_notification.js
 * Envoie une notification push à tous les abonnés OneSignal.
 *
 * Usage depuis un autre script :
 *   const sendNotification = require('./send_notification');
 *   await sendNotification({ title, body, route, type });
 *
 * Usage CLI (test direct) :
 *   node scripts/send_notification.js --title "Hello" --body "World" --route /home
 */

const https = require("https");

const ONESIGNAL_APP_ID = "cfc58648-689b-432f-9afa-c4f49e69199f";
const ONESIGNAL_REST_API_KEY =
  "os_v2_app_z7cymsditnbs7gx2yt2j42izt4neg33xnicezbuj4rjtexvwjh5rusmzdjw2t5ssrtszevfw6lif6b5qiypy4oaywwthibctmoosqjq";

/**
 * @param {object} opts
 * @param {string} opts.title   - Titre de la notification
 * @param {string} opts.body    - Corps de la notification
 * @param {string} [opts.route] - Route in-app (ex: /anime/jujutsu-kaisen)
 * @param {string} [opts.type]  - Type : new_characters | monthly_vote | subscription
 * @returns {Promise<void>}
 */
async function sendNotification({ title, body, route = "", type = "new_characters" }) {
  const payload = JSON.stringify({
    app_id: ONESIGNAL_APP_ID,
    included_segments: ["All"],
    headings: { en: title, fr: title },
    contents: { en: body, fr: body },
    data: { route, type },
  });

  return new Promise((resolve, reject) => {
    const options = {
      hostname: "onesignal.com",
      path: "/api/v1/notifications",
      method: "POST",
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        Authorization: `Basic ${ONESIGNAL_REST_API_KEY}`,
        "Content-Length": Buffer.byteLength(payload),
      },
    };

    const req = https.request(options, (res) => {
      let data = "";
      res.on("data", (chunk) => (data += chunk));
      res.on("end", () => {
        const json = JSON.parse(data);
        if (json.errors) {
          console.warn("⚠️  OneSignal warning:", JSON.stringify(json.errors));
        } else {
          console.log(
            `✅ Notification OneSignal envoyée — recipients: ${json.recipients ?? "?"}`,
          );
        }
        resolve();
      });
    });

    req.on("error", (err) => {
      console.error("❌ Erreur OneSignal :", err.message);
      reject(err);
    });

    req.write(payload);
    req.end();
  });
}

module.exports = sendNotification;

// ─── Appel direct CLI ──────────────────────────────────────────────────────
if (require.main === module) {
  const args = process.argv.slice(2);
  const get = (flag) => {
    const i = args.indexOf(flag);
    return i !== -1 ? args[i + 1] : undefined;
  };

  const title = get("--title") ?? "OTADEX";
  const body = get("--body") ?? "Nouvelle mise à jour disponible !";
  const route = get("--route") ?? "/home";
  const type = get("--type") ?? "new_characters";

  sendNotification({ title, body, route, type })
    .then(() => process.exit(0))
    .catch(() => process.exit(1));
}
