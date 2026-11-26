import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/theme/otadex_theme.dart';

class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

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
          s.termsOfService,
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
        _heading(theme, '1. Acceptation des conditions'),
        _body(theme,
            'En créant un compte ou en utilisant l\'application OTADEX, vous acceptez les présentes Conditions d\'utilisation dans leur intégralité. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser l\'application.'),
        _heading(theme, '2. Description du service'),
        _body(theme,
            'OTADEX est une encyclopédie interactive et gamifiée dédiée à l\'univers de l\'animation japonaise, coréenne et mondiale. Le service permet de :\n\n• Explorer des fiches de personnages, d\'animés, de créateurs et d\'univers narratifs\n• Construire et gérer une collection personnelle de personnages\n• Progresser à travers un système de rangs (Genin, Jonin, Kage) et de points\n• Interagir avec une communauté de fans via commentaires et classements'),
        _heading(theme, '3. Inscription et compte'),
        _body(theme,
            '• Vous devez avoir au moins 13 ans pour vous inscrire sur OTADEX.\n• Vous êtes seul responsable de la confidentialité de vos identifiants de connexion.\n• Votre pseudo doit comporter au moins 3 caractères et ne pas contenir de contenu offensant ou trompeur.\n• TilStack se réserve le droit de suspendre ou supprimer tout compte enfreignant les présentes conditions.'),
        _heading(theme, '4. Système de rangs et abonnements'),
        _body(theme,
            'OTADEX propose trois niveaux d\'accès :\n\n• Genin (Gratuit) : accès aux fonctionnalités de base, publicités affichées\n• Jonin (Premium) : accès sans publicités, collection illimitée, IA chatbot et quiz\n• Kage (Premium+) : toutes les fonctionnalités Jonin + génération d\'images IA, téléchargement sans filigrane, thèmes exclusifs\n\nLes abonnements Jonin et Kage sont facturés mensuellement ou annuellement. Ils sont résiliables à tout moment depuis les paramètres de l\'application. Aucun remboursement n\'est accordé pour la période d\'abonnement en cours.'),
        _heading(theme, '5. Propriété intellectuelle'),
        _body(theme,
            'Les personnages, animés, studios, créateurs et univers référencés dans OTADEX appartiennent à leurs auteurs et détenteurs de droits respectifs. OTADEX est un service encyclopédique à vocation informative et communautaire, sans affiliation avec les ayants droit. L\'interface, le design et les fonctionnalités propres à OTADEX sont la propriété exclusive de TilStack.'),
        _heading(theme, '6. Conduite et contenu interdit'),
        _body(theme,
            'Il est strictement interdit de :\n\n• Publier du contenu offensant, haineux, discriminatoire, pornographique ou illégal\n• Utiliser des bots, scripts ou automatisations pour accéder au service\n• Tenter de contourner les mécanismes de sécurité ou de monétisation de l\'application\n• Usurper l\'identité d\'un autre utilisateur ou de TilStack\n• Vendre, louer ou transférer son compte à un tiers\n• Collecter des données d\'autres utilisateurs sans leur consentement'),
        _heading(theme, '7. Limitation de responsabilité'),
        _body(theme,
            'OTADEX est fourni « en l\'état » et « selon disponibilité ». TilStack ne garantit pas l\'exactitude absolue de toutes les informations encyclopédiques ni la disponibilité continue du service. TilStack ne peut être tenu responsable des interruptions de service, des pertes de données, des dommages indirects ou des préjudices liés à l\'utilisation ou à l\'impossibilité d\'utiliser l\'application.'),
        _heading(theme, '8. Droit applicable'),
        _body(theme,
            'Les présentes conditions sont régies par les lois en vigueur dans le pays de résidence de l\'exploitant. Tout litige non résolu à l\'amiable sera soumis aux juridictions compétentes.'),
        _heading(theme, '9. Modifications'),
        _body(theme,
            'TilStack se réserve le droit de modifier ces conditions à tout moment. Les modifications entrent en vigueur dès leur publication dans l\'application. La poursuite de l\'utilisation du service après notification vaut acceptation des nouvelles conditions.'),
        _heading(theme, '10. Contact'),
        _body(theme, 'TilStack · contact@tilstack.me'),
        const SizedBox(height: 20),
      ];

  List<Widget> _enContent(dynamic theme) => [
        _label(theme, 'Last updated: April 2026'),
        _heading(theme, '1. Acceptance of terms'),
        _body(theme,
            'By creating an account or using the OTADEX application, you accept these Terms of Service in full. If you do not accept these terms, please do not use the application.'),
        _heading(theme, '2. Service description'),
        _body(theme,
            'OTADEX is an interactive, gamified encyclopedia dedicated to Japanese, Korean and world animation. The service lets you:\n\n• Browse character, anime, creator and narrative universe profiles\n• Build and manage a personal character collection\n• Progress through a rank system (Genin, Jonin, Kage) with points\n• Interact with a fan community via comments and leaderboards'),
        _heading(theme, '3. Registration and account'),
        _body(theme,
            '• You must be at least 13 years old to register on OTADEX.\n• You are solely responsible for the security of your login credentials.\n• Your username must be at least 3 characters long and must not contain offensive or misleading content.\n• TilStack reserves the right to suspend or delete any account that violates these terms.'),
        _heading(theme, '4. Rank system and subscriptions'),
        _body(theme,
            'OTADEX offers three access tiers:\n\n• Genin (Free): basic features, ads displayed\n• Jonin (Premium): ad-free, unlimited collection, AI chatbot and quiz\n• Kage (Premium+): all Jonin features + AI image generation, watermark-free downloads, exclusive themes\n\nJonin and Kage subscriptions are billed monthly or annually and can be cancelled at any time from the app settings. No refunds are issued for the current billing period.'),
        _heading(theme, '5. Intellectual property'),
        _body(theme,
            'Characters, animes, studios, creators and universes referenced in OTADEX belong to their respective authors and rights holders. OTADEX is an encyclopaedic service for informational and community purposes, with no affiliation with rights holders. The OTADEX interface, design and proprietary features are the exclusive property of TilStack.'),
        _heading(theme, '6. Prohibited conduct and content'),
        _body(theme,
            'It is strictly forbidden to:\n\n• Post offensive, hateful, discriminatory, pornographic or illegal content\n• Use bots, scripts or automation to access the service\n• Attempt to circumvent the application\'s security or monetisation mechanisms\n• Impersonate another user or TilStack\n• Sell, rent or transfer your account to a third party\n• Collect other users\' data without their consent'),
        _heading(theme, '7. Limitation of liability'),
        _body(theme,
            'OTADEX is provided "as is" and "as available". TilStack does not guarantee the absolute accuracy of all encyclopaedic content or the continuous availability of the service. TilStack shall not be liable for service interruptions, data loss, indirect damages or harm related to the use or inability to use the application.'),
        _heading(theme, '8. Governing law'),
        _body(theme,
            'These terms are governed by the laws in force in the operator\'s country of residence. Any dispute not resolved amicably shall be submitted to the competent courts.'),
        _heading(theme, '9. Changes'),
        _body(theme,
            'TilStack reserves the right to modify these terms at any time. Changes take effect upon publication in the application. Continued use of the service after notification constitutes acceptance of the updated terms.'),
        _heading(theme, '10. Contact'),
        _body(theme, 'TilStack · contact@tilstack.me'),
        const SizedBox(height: 20),
      ];
}
