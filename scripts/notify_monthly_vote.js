/**
 * notify_monthly_vote.js
 * Envoie la notification "Vote Fan du Mois ouvert" via OneSignal.
 * Compatible GitHub Actions (variables d'env CI) et usage local (.env).
 *
 * À lancer manuellement le 1er de chaque mois ou via crontab :
 *   0 9 1 * * /home/tilstack/.cache/ms-playwright-go/1.50.1/node /home/tilstack/Bureau/Otadex_v1/scripts/notify_monthly_vote.js
 *
 * Lancement direct :
 *   node scripts/notify_monthly_vote.js
 */

const sendNotification = require('./send_notification');

const now = new Date();
const month = now.toLocaleString('fr-FR', { month: 'long' });
const monthCapitalized = month.charAt(0).toUpperCase() + month.slice(1);

const TITLE = '🏆 Vote Fan du Mois ouvert !';
const BODY =
  `Le vote ${monthCapitalized} est lancé. ` +
  'Choisis ton personnage préféré et soutiens-le !';
const DEEP_LINK = 'otadex://home';

(async () => {
  console.log(
    '🗳️  Envoi de la notification Vote Fan du Mois — ' +
      `${monthCapitalized} ${now.getFullYear()}...\n`,
  );

  await sendNotification({
    title: TITLE,
    body: BODY,
    route: '/home',
    type: 'monthly_vote',
    url: DEEP_LINK,
  });

  console.log('\n✅ Notification vote mensuel envoyée avec succès !');
  process.exit(0);
})().catch((err) => {
  console.error('❌ Erreur :', err.message);
  process.exit(1);
});
