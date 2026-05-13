import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/otadex_theme.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    final locale = ref.watch(localeProvider);
    final isFr = locale == 'fr';

    return Scaffold(
      backgroundColor: theme.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: theme.backgroundCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded,
              color: theme.textPrimary, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          s.privacyPolicy,
          style: GoogleFonts.rajdhani(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: theme.textPrimary,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: isFr ? _frContent(theme) : _enContent(theme),
        ),
      ),
    );
  }

  Widget _heading(dynamic theme, String text) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(
          text,
          style: GoogleFonts.rajdhani(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: theme.accentColor,
            letterSpacing: 0.3,
          ),
        ),
      );

  Widget _body(dynamic theme, String text) => Text(
        text,
        style: GoogleFonts.nunitoSans(
          fontSize: 14,
          color: theme.textPrimary,
          height: 1.6,
        ),
      );

  Widget _label(dynamic theme, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          text,
          style: GoogleFonts.nunitoSans(
            fontSize: 12,
            color: theme.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
      );


  List<Widget> _frContent(dynamic theme) => [
        _label(theme, 'Dernière mise à jour : Avril 2026'),
        _heading(theme, '1. Introduction'),
        _body(theme,
            'TilStack opère l\'application mobile OTADEX. La présente Politique de confidentialité décrit comment nous collectons, utilisons et protégeons vos données personnelles lors de l\'utilisation de l\'application.'),
        _heading(theme, '2. Données collectées'),
        _body(theme,
            'Lors de votre inscription et de l\'utilisation d\'OTADEX, nous collectons :\n\n• Données de compte : adresse e-mail, pseudo, mot de passe (chiffré)\n• Données de profil : nom affiché, biographie, photo de profil\n• Données de progression : rang (Genin/Jonin/Kage), fan score, collection, points, classements\n• Données de préférences : langue, thème, catégories favorites, historique de navigation\n• Données techniques : identifiant d\'appareil, type d\'OS, version de l\'application'),
        _heading(theme, '3. Utilisation des données'),
        _body(theme,
            'Vos données personnelles sont utilisées pour :\n\n• Créer et gérer votre compte utilisateur\n• Personnaliser votre expérience et vos recommandations\n• Gérer votre abonnement (Genin, Jonin, Kage)\n• Assurer le bon fonctionnement des fonctionnalités communautaires\n• Améliorer continuellement nos services\n• Vous envoyer des notifications relatives à votre compte (si activées)'),
        _heading(theme, '4. Partage des données'),
        _body(theme,
            'Nous ne vendons jamais vos données personnelles à des tiers. Elles peuvent être partagées uniquement avec :\n\n• Firebase (Google LLC) : pour l\'authentification et le stockage sécurisé, dans le cadre de leur propre politique de confidentialité\n• Prestataires techniques : soumis à des obligations contractuelles strictes de confidentialité'),
        _heading(theme, '5. Conservation des données'),
        _body(theme,
            'Vos données sont conservées tant que votre compte est actif. En cas de demande de suppression de compte, vos données personnelles sont effacées dans un délai maximum de 30 jours, à l\'exception des données requises par la loi.'),
        _heading(theme, '6. Vos droits'),
        _body(theme,
            'Conformément aux réglementations applicables, vous disposez des droits suivants :\n\n• Droit d\'accès à vos données personnelles\n• Droit de rectification des données inexactes\n• Droit à la suppression de votre compte et de vos données\n• Droit à la portabilité de vos données\n• Droit d\'opposition au traitement de vos données\n\nPour exercer ces droits, contactez-nous à contact@otadex.app.'),
        _heading(theme, '7. Sécurité'),
        _body(theme,
            'Nous mettons en œuvre des mesures de sécurité appropriées incluant le chiffrement des données en transit et au repos, la restriction des accès et des audits réguliers de nos systèmes.'),
        _heading(theme, '8. Mineurs'),
        _body(theme,
            'OTADEX est accessible à partir de 13 ans. Si vous avez moins de 18 ans, l\'accord parental est recommandé. Nous ne collectons pas sciemment de données de mineurs de moins de 13 ans.'),
        _heading(theme, '9. Modifications'),
        _body(theme,
            'Nous nous réservons le droit de modifier cette politique à tout moment. Toute modification significative vous sera notifiée via l\'application. La poursuite de l\'utilisation du service vaut acceptation des nouvelles conditions.'),
        _heading(theme, '10. Contact'),
        _body(theme, 'TilStack · contact@otadex.app'),
        const SizedBox(height: 20),
      ];

  List<Widget> _enContent(dynamic theme) => [
        _label(theme, 'Last updated: April 2026'),
        _heading(theme, '1. Introduction'),
        _body(theme,
            'TilStack operates the OTADEX mobile application. This Privacy Policy describes how we collect, use and protect your personal data when you use the application.'),
        _heading(theme, '2. Data collected'),
        _body(theme,
            'When you register and use OTADEX, we collect:\n\n• Account data: email address, username, password (encrypted)\n• Profile data: display name, bio, profile picture\n• Progression data: rank (Genin/Jonin/Kage), fan score, collection, points, leaderboard position\n• Preference data: language, theme, favourite categories, browsing history\n• Technical data: device identifier, OS type, app version'),
        _heading(theme, '3. Use of data'),
        _body(theme,
            'Your personal data is used to:\n\n• Create and manage your user account\n• Personalise your experience and recommendations\n• Manage your subscription (Genin, Jonin, Kage)\n• Enable community features\n• Continuously improve our services\n• Send you account-related notifications (if enabled)'),
        _heading(theme, '4. Data sharing'),
        _body(theme,
            'We never sell your personal data to third parties. Data may be shared only with:\n\n• Firebase (Google LLC): for authentication and secure storage, under their own privacy policy\n• Technical partners: bound by strict confidentiality obligations'),
        _heading(theme, '5. Data retention'),
        _body(theme,
            'Your data is retained while your account is active. Upon account deletion request, your personal data is erased within 30 days, except for data required by law.'),
        _heading(theme, '6. Your rights'),
        _body(theme,
            'Under applicable regulations, you have the following rights:\n\n• Right to access your personal data\n• Right to correct inaccurate data\n• Right to delete your account and data\n• Right to data portability\n• Right to object to data processing\n\nTo exercise these rights, contact us at contact@otadex.app.'),
        _heading(theme, '7. Security'),
        _body(theme,
            'We implement appropriate security measures including data encryption in transit and at rest, access restrictions and regular security audits.'),
        _heading(theme, '8. Minors'),
        _body(theme,
            'OTADEX is accessible from age 13. If you are under 18, parental consent is recommended. We do not knowingly collect data from children under 13.'),
        _heading(theme, '9. Changes'),
        _body(theme,
            'We reserve the right to modify this policy at any time. Any significant change will be notified via the application. Continued use of the service constitutes acceptance of the updated policy.'),
        _heading(theme, '10. Contact'),
        _body(theme, 'TilStack · contact@otadex.app'),
        const SizedBox(height: 20),
      ];
}
