import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otadex/core/constants/app_constants.dart';
import 'package:otadex/core/l10n/app_locale.dart';
import 'package:otadex/core/l10n/app_strings.dart';
import 'package:otadex/core/services/url_launcher_service.dart';
import 'package:otadex/core/theme/otadex_theme_wrapper.dart';
import 'package:otadex/features/newsletter/presentation/newsletter_invite.dart';
import 'package:otadex/features/profile/presentation/widgets/settings_section.dart';

const _formUrl = 'https://example.com/formulaire';

void main() {
  late List<String> opened;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    opened = [];
  });

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    String formUrl = _formUrl,
    String locale = 'fr',
  }) =>
      tester.pumpWidget(
        ProviderScope(
          overrides: [
            newsletterFormUrlProvider.overrideWithValue(formUrl),
            newsletterLinkOpenerProvider
                .overrideWithValue((url) async => opened.add(url)),
          ],
          child: AppLocale(
            strings: AppStrings.forLocale(locale),
            child: OtadexThemeWrapper(
              isDark: true,
              child: MaterialApp(home: Scaffold(body: child)),
            ),
          ),
        ),
      );

  /// Bouton qui rejoue ce que fait l'accueil à l'arrivée d'un connecté.
  final trigger = Consumer(
    builder: (context, ref, _) => TextButton(
      onPressed: () => maybeShowNewsletterInvite(context, ref),
      child: const Text('accueil'),
    ),
  );

  Future<void> arrive(WidgetTester tester) async {
    await tester.tap(find.text('accueil'));
    await tester.pumpAndSettle();
  }

  testWidgets('refus : rien ne s\'ouvre et l\'invitation ne revient pas',
      (tester) async {
    await pump(tester, trigger);
    await arrive(tester);
    expect(find.text('Newsletter OTADEX'), findsOneWidget);
    expect(find.byType(Checkbox), findsNothing);

    await tester.tap(find.text('Non merci'));
    await tester.pumpAndSettle();
    await arrive(tester);

    expect(find.byType(AlertDialog), findsNothing);
    expect(opened, isEmpty);
  });

  testWidgets('fermer sans répondre compte aussi comme vue', (tester) async {
    await pump(tester, trigger);
    await arrive(tester);
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();
    await arrive(tester);

    expect(find.byType(AlertDialog), findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(AppConstants.keyNewsletterInviteSeen), isTrue);
  });

  testWidgets('S\'inscrire ouvre le formulaire, sans aucun paramètre ajouté',
      (tester) async {
    await pump(tester, trigger);
    await arrive(tester);
    await tester.tap(find.text('S’inscrire'));
    await tester.pumpAndSettle();

    expect(opened, [_formUrl]);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('textes anglais et lien vers la politique de confidentialité',
      (tester) async {
    await pump(tester, trigger, locale: 'en');
    await arrive(tester);
    expect(find.text('OTADEX newsletter'), findsOneWidget);
    expect(find.text('Subscribe'), findsOneWidget);

    await tester.tap(find.text('Privacy policy'));
    await tester.pumpAndSettle();

    expect(opened, [UrlLauncherService.privacyPolicyUrl]);
    expect(opened.single,
        'https://otadex.tilstack.me/privacy-policy.html');
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  test('adresse livrée : la page web de la newsletter', () {
    expect(kNewsletterFormUrl, 'https://otadexcat.tilstack.me/newsletter');
  });

  testWidgets('sans URL de formulaire, aucune invitation', (tester) async {
    await pump(tester, trigger, formUrl: '');
    await arrive(tester);

    expect(find.byType(AlertDialog), findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(AppConstants.keyNewsletterInviteSeen), isNull);
  });

  Widget settings() => SingleChildScrollView(
        child: SettingsSection(
          notificationsEnabled: false,
          onNotificationsChanged: (_) {},
          currentLanguage: 'fr',
          onLanguageSelect: (_) {},
          isDarkMode: true,
          onThemeToggle: () {},
          onEditProfile: () {},
          onChangePassword: () {},
          email: 'fan@example.com',
        ),
      );

  testWidgets('entrée Profil : rouvre la fenêtre même après un refus',
      (tester) async {
    SharedPreferences.setMockInitialValues(
        {AppConstants.keyNewsletterInviteSeen: true});
    await pump(tester, settings());
    await tester.ensureVisible(find.text('Newsletter'));
    await tester.tap(find.text('Newsletter'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('entrée Profil masquée sans URL de formulaire', (tester) async {
    await pump(tester, settings(), formUrl: '');

    expect(find.text('Newsletter'), findsNothing);
  });
}
