import 'package:google_sign_in/google_sign_in.dart';

/// Service d'authentification Google.
///
/// ⚠️  Pour que le sign-in fonctionne sur Android :
///   1. Crée un projet Firebase Console (ou Google Cloud)
///   2. Active Google Sign-In dans Authentication
///   3. Télécharge `google-services.json` → place dans `android/app/`
///   4. Ajoute le SHA-1 du debug keystore dans Firebase Console
///
/// En attendant la Task 02, toute erreur est capturée et renvoie `null`.
class GoogleSignInService {
  static final _client = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Lance le flux de connexion Google.
  /// Retourne le compte Google si l'utilisateur a accepté, sinon `null`.
  static Future<GoogleSignInAccount?> signIn() async {
    try {
      // Déconnecte d'abord pour forcer la sélection de compte
      await _client.signOut();
      return await _client.signIn();
    } catch (_) {
      return null;
    }
  }

  /// Déconnecte le compte Google actuel.
  static Future<void> signOut() async {
    try {
      await _client.signOut();
    } catch (_) {}
  }
}
