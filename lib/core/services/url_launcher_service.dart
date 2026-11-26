import 'package:url_launcher/url_launcher.dart';

abstract final class UrlLauncherService {
  static const String _terms = 'https://otadex.tilstack.me/terms.html';
  static const String privacyPolicyUrl = 'https://otadex.tilstack.me/privacy-policy.html';
  static const String _accountDeletion = 'https://otadex.tilstack.me/account-deletion.html';

  static Future<void> openTerms() => _launch(_terms);
  static Future<void> openPrivacyPolicy() => _launch(privacyPolicyUrl);
  static Future<void> openAccountDeletion() => _launch(_accountDeletion);
  static Future<void> openUrl(String url) => _launch(url);

  static Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
