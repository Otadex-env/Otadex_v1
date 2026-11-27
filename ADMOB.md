# Publicités AdMob (rang Genin uniquement)

Bannière adaptative sur Accueil, Recherche et Collection (`lib/core/ads/`).
Jonin et Kage : ni bannière, ni formulaire de consentement, ni requête publicitaire.

## À faire par toi (dans cet ordre)

1. Créer le compte sur <https://admob.google.com> et **vérifier avant de valider
   que ton pays est accepté pour les paiements** (le pays du compte de paiement
   ne se change pas ensuite).
2. AdMob → Applications → ajouter OTADEX (Android, `com.otadex.otadex`).
3. Créer un bloc d'annonces **Bannière**.
4. AdMob → Confidentialité et messages → créer et **publier** le message RGPD
   (règlement européen). Sans lui, aucun formulaire n'est affiché aux vrais
   utilisateurs européens.
5. Renseigner les identifiants (publics, pas secrets) :
   - `android/local.properties` : `admob.appId=ca-app-pub-…~…`
   - `.env` : `ADMOB_BANNER_ID=ca-app-pub-…/…`
6. Publier `app-ads.txt` à la racine du site déclaré dans la fiche Play
   (ligne fournie par AdMob) : `web/public/app-ads.txt`.

Debug et profile utilisent toujours les identifiants de test de Google. En
release, sans `ADMOB_BANNER_ID`, aucune publicité n'est affichée.
**Ne clique jamais sur tes propres vraies annonces.**

## Play Console

À mettre à jour au moment de publier la version qui contient le SDK.

- **Contenu de l'application → Annonces** : « Oui, mon application contient des annonces ».
- **Identifiant publicitaire** : oui. La permission
  `com.google.android.gms.permission.AD_ID` est ajoutée par le SDK.
  Motifs : publicité ou marketing, analyse, prévention des fraudes.
- **Sécurité des données** : données **collectées et partagées** par le SDK
  Google Mobile Ads, chiffrées en transit :

  | Type | Catégorie Play |
  |---|---|
  | Adresse IP (localisation approximative) | Position → approximative |
  | Interactions avec l'app et les annonces | Activité dans les applications |
  | Journaux de plantage, diagnostics | Infos et performances |
  | Identifiant publicitaire, App Set ID | Appareil ou autres ID |

  Finalités : publicité ou marketing, analyse, prévention des fraudes.
  Recouper avec la page officielle (elle évolue) :
  <https://developers.google.com/admob/android/privacy/play-data-disclosure>
- **Public cible** : l'app accepte les 13 ans et plus. Les annonces sont
  limitées à la classification T ; sous 16 ans (âge saisi à l'inscription), le
  traitement « adolescent » est demandé.

## Politique de confidentialité (à ajouter, rien n'a été modifié)

`web/public/privacy-policy.html` (FR et EN) et l'écran
`lib/features/legal/presentation/privacy_policy_screen.dart` :

- Les utilisateurs du rang gratuit Genin voient des publicités fournies par
  Google AdMob ; Jonin et Kage n'en voient pas.
- Google et ses partenaires peuvent collecter l'identifiant publicitaire,
  l'adresse IP (localisation approximative), les interactions avec les annonces
  et des données de diagnostic.
- Dans l'EEE, au Royaume-Uni et en Suisse, un consentement est demandé ; il se
  modifie à tout moment dans Profil → Choix publicitaires.
- On peut réinitialiser ou supprimer son identifiant publicitaire dans les
  réglages Android.
- Lien : <https://policies.google.com/technologies/partner-sites>
- La phrase « Nous ne vendons jamais vos données » et la section « Partage des
  données » doivent mentionner ce partage avec Google et ses partenaires
  publicitaires.
