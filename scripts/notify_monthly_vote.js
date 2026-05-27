/**
 * notify_monthly_vote.js
 * Envoie la notification "Vote Fan du Mois ouvert" via OneSignal.
 *
 * À lancer manuellement le 1er de chaque mois ou via crontab :
 *   0 9 1 * * /home/tilstack/.cache/ms-playwright-go/1.50.1/node /home/tilstack/Bureau/Otadex_v1/scripts/notify_monthly_vote.js
 *
 * Lancement direct :
 *   node scripts/notify_monthly_vote.js
 */

const sendNotification = require("./send_notification");

const now = new Date();
const month = now.toLocaleString("fr-FR", { month: "long" });
const monthCapitalized = month.charAt(0).toUpperCase() + month.slice(1);

(async () => {
  console.log(`🗳️  Envoi de la notification Vote Fan du Mois — ${monthCapitalized} ${now.getFullYear()}...\n`);

  await sendNotification({
    title: `🏆 Vote Fan du Mois ouvert !`,
    body: `Le vote ${monthCapitalized} est lancé. Choisis ton personnage préféré et soutiens-le !`,
    route: "/home",
    type: "monthly_vote",
  });

  console.log("\n✅ Notification vote mensuel envoyée avec succès !");
  process.exit(0);
})().catch((err) => {
  console.error("❌ Erreur :", err.message);
  process.exit(1);
});
