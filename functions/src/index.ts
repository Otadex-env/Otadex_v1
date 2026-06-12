/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {setGlobalOptions} from "firebase-functions";
import {onSchedule} from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";
import {defineSecret} from "firebase-functions/params";

setGlobalOptions({maxInstances: 10});

if (!admin.apps.length) {
  admin.initializeApp();
}

const oneSignalAppId = defineSecret("ONESIGNAL_APP_ID");
const oneSignalApiKey = defineSecret("ONESIGNAL_API_KEY");

async function sendOneSignalNotification() {
  const response = await fetch("https://onesignal.com/api/v1/notifications", {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": `Basic ${oneSignalApiKey.value()}`,
    },
    body: JSON.stringify({
      app_id: oneSignalAppId.value(),
      included_segments: ["All"],
      headings: {
        en: "🏆 Vote Fan du Mois ouvert !",
        fr: "🏆 Vote Fan du Mois ouvert !",
      },
      contents: {
        en: "Le vote mensuel est lancé. Choisis ton personnage préféré !",
        fr: "Le vote mensuel est lancé. Choisis ton personnage préféré !",
      },
      url: "otadex://home",
      data: {
        route: "/home",
        type: "monthly_vote",
      },
    }),
  });

  const json = await response.json() as {
    recipients?: number;
    errors?: unknown;
  };
  if (!response.ok || json.errors) {
    throw new Error(`OneSignal error: ${JSON.stringify(json.errors ?? json)}`);
  }
  return json.recipients ?? 0;
}

// Déclenché le 1er de chaque mois à 9h00 (heure de Douala)
export const notifyMonthlyVote = onSchedule(
  {
    schedule: "0 9 1 * *",
    timeZone: "Africa/Douala",
    secrets: [oneSignalAppId, oneSignalApiKey],
  },
  async () => {
    const db = admin.firestore();

    const usersSnapshot = await db.collection("users").get();
    const recipients = await sendOneSignalNotification();

    const batch = db.batch();
    usersSnapshot.docs.forEach((doc) => {
      const ref = db
        .collection("users")
        .doc(doc.id)
        .collection("notifications")
        .doc();
      batch.set(ref, {
        title: "🏆 Vote Fan du Mois ouvert !",
        body: "Soutenez votre personnage préféré !",
        type: "monthly_vote",
        route: "/home",
        read: false,
        created_at: admin.firestore.FieldValue.serverTimestamp(),
      });
    });
    await batch.commit();

    console.log(
      `✅ Vote notification envoyée via OneSignal à ${recipients} abonnés`,
    );
  }
);
