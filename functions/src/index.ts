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

setGlobalOptions({maxInstances: 10});

if (!admin.apps.length) {
  admin.initializeApp();
}

// Déclenché le 1er de chaque mois à 9h00 (heure de Douala)
export const notifyMonthlyVote = onSchedule(
  {schedule: "0 9 1 * *", timeZone: "Africa/Douala"},
  async () => {
    const db = admin.firestore();
    const messaging = admin.messaging();

    const usersSnapshot = await db.collection("users").get();
    const tokens = usersSnapshot.docs
      .map((doc) => doc.data().fcmToken as string | undefined)
      .filter((token): token is string => !!token && token.length > 0);

    if (tokens.length > 0) {
      await messaging.sendEachForMulticast({
        tokens,
        notification: {
          title: "🏆 Vote Fan du Mois ouvert !",
          body: "Soutenez votre personnage préféré ce mois-ci !",
        },
        data: {
          route: "/home",
          type: "monthly_vote",
        },
      });
    }

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

    console.log(`✅ Vote notification envoyée à ${tokens.length} users`);
  }
);
