import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../core/theme/otadex_theme.dart';

/// Adresse du formulaire Brevo. Vide : la newsletter n'apparaît nulle part.
final newsletterFormUrlProvider =
    Provider<String>((ref) => kNewsletterFormUrl);

/// Ouverture d'un lien dans le navigateur (remplaçable dans les tests).
final newsletterLinkOpenerProvider = Provider<Future<void> Function(String)>(
    (ref) => UrlLauncherService.openUrl);

/// Affiche l'invitation à un utilisateur connecté, une seule fois par appareil.
///
/// Elle est marquée « vue » dès l'affichage : refus, retour arrière ou
/// fermeture de l'app ne la font pas réapparaître.
Future<void> maybeShowNewsletterInvite(
  BuildContext context,
  WidgetRef ref,
) async {
  if (ref.read(newsletterFormUrlProvider).isEmpty) return;
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(AppConstants.keyNewsletterInviteSeen) ?? false) return;
  // Pas par-dessus un autre écran : on réessaiera à la prochaine ouverture.
  if (!context.mounted || !(ModalRoute.of(context)?.isCurrent ?? true)) return;
  await prefs.setBool(AppConstants.keyNewsletterInviteSeen, true);
  if (!context.mounted) return;
  await showNewsletterDialog(context);
}

/// Fenêtre d'invitation, aussi ouverte depuis Profil > Newsletter.
///
/// L'inscription se fait entièrement sur le formulaire Brevo : l'app n'y
/// transmet aucune donnée, pas même l'adresse e-mail du compte.
Future<void> showNewsletterDialog(BuildContext context) => showDialog<void>(
      context: context,
      builder: (_) => const _NewsletterDialog(),
    );

class _NewsletterDialog extends ConsumerWidget {
  const _NewsletterDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    final open = ref.watch(newsletterLinkOpenerProvider);
    final url = ref.watch(newsletterFormUrlProvider);

    return AlertDialog(
      scrollable: true,
      backgroundColor: theme.backgroundCard,
      title: Text(
        s.newsletterTitle,
        style: GoogleFonts.rajdhani(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: theme.textPrimary,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.newsletterMessage,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              height: 1.5,
              color: theme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => open(UrlLauncherService.privacyPolicyUrl),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              foregroundColor: theme.accentColor,
            ),
            child: Text(
              s.privacyPolicy,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(foregroundColor: theme.textSecondary),
          child: Text(s.newsletterDecline),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            open(url);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.accentColor,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          child: Text(s.newsletterSubscribe),
        ),
      ],
    );
  }
}
