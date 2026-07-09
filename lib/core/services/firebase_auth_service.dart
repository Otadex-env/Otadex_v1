import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import 'notification_service.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _google;

  FirebaseAuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? google,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _google = google ?? GoogleSignIn();

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String pseudo,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(pseudo);
      await _createUserDocument(
        uid: cred.user!.uid,
        pseudo: pseudo,
        email: email,
      );
      await _persistUserSession(
        uid: cred.user!.uid,
        pseudo: pseudo,
        email: email,
        rank: AppConstants.rankGenin,
      );
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) return;
      final profile = await _getUserProfile(user.uid);
      final pseudo = profile?['pseudo'] as String? ??
          user.displayName ??
          email.split('@').first;
      final rank = profile?['abonnement'] as String? ?? AppConstants.rankGenin;
      await _persistUserSession(
        uid: user.uid,
        pseudo: pseudo,
        email: user.email ?? email,
        rank: rank,
      );
      NotificationService.saveCurrentSubscriptionId();
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final user = await _google.signIn();
      if (user == null) throw 'Connexion Google annulée.';
      final googleAuth = await user.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) return;

      await _createUserDocument(
        uid: firebaseUser.uid,
        pseudo: firebaseUser.displayName ?? user.displayName ?? 'Otaku',
        email: firebaseUser.email ?? user.email,
        merge: true,
      );
      final profile = await _getUserProfile(firebaseUser.uid);
      await _persistUserSession(
        uid: firebaseUser.uid,
        pseudo: (profile?['pseudo'] as String?) ??
            firebaseUser.displayName ??
            user.displayName ??
            'Otaku',
        email: firebaseUser.email ?? user.email,
        rank: (profile?['abonnement'] as String?) ?? AppConstants.rankGenin,
      );
      NotificationService.saveCurrentSubscriptionId();
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    } catch (e) {
      if (e is String) rethrow;
      throw 'Connexion Google échouée. Réessaie.';
    }
  }

  Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, false);
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove(AppConstants.keyUserId);
    await prefs.remove(AppConstants.keyUserEmail);
    await prefs.remove(AppConstants.keyUserPseudo);
    await prefs.remove(AppConstants.keyUserDisplayName);
    await prefs.remove(AppConstants.keyUserRank);
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _auth.confirmPasswordReset(code: code, newPassword: newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> reauthenticateAndUpdatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw 'Utilisateur non connecté.';
    }
    final email = user.email;
    if (email == null || email.isEmpty) {
      throw 'Impossible de récupérer ton email pour cette action.';
    }
    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> updateUserProfile({
    String? pseudo,
    String? bio,
    String? avatarUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw 'Utilisateur non connecté.';
    }

    final updates = <String, Object?>{};
    if (pseudo != null && pseudo.isNotEmpty) {
      updates['pseudo'] = pseudo;
      updates['display_name'] = pseudo;
      await user.updateDisplayName(pseudo);
    }
    if (bio != null) {
      updates['bio'] = bio;
    }
    if (avatarUrl != null) {
      updates['avatar_url'] = avatarUrl;
    }
    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).set(
            updates,
            SetOptions(merge: true),
          );
    }
  }

  Future<void> _createUserDocument({
    required String uid,
    required String pseudo,
    required String email,
    bool merge = false,
  }) async {
    await _firestore.collection('users').doc(uid).set(
      {
        'uid': uid,
        'pseudo': pseudo,
        'email': email,
        'abonnement': AppConstants.rankGenin,
        'score_fan': 0,
        'badges': [],
        'created_at': FieldValue.serverTimestamp(),
      },
      merge ? SetOptions(merge: true) : null,
    );
  }

  Future<Map<String, dynamic>?> _getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> _persistUserSession({
    required String uid,
    required String pseudo,
    required String email,
    required String rank,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, true);
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString(AppConstants.keyUserId, uid);
    await prefs.setString(AppConstants.keyUserEmail, email);
    await prefs.setString(AppConstants.keyUserPseudo, pseudo);
    await prefs.setString(AppConstants.keyUserDisplayName, pseudo);
    await prefs.setString(AppConstants.keyUserRank, rank);
  }

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'weak-password':
        return 'Mot de passe trop faible (8 car. min).';
      case 'user-not-found':
        return 'Aucun compte trouvé pour cet email.';
      case 'wrong-password':
        return 'Mot de passe actuel incorrect.';
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      case 'invalid-action-code':
      case 'expired-action-code':
        return 'Code de réinitialisation invalide ou expiré.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessaie plus tard.';
      case 'requires-recent-login':
        return 'Reconnecte-toi puis réessaie cette action.';
      case 'user-disabled':
        return 'Ce compte a été désactivé.';
      default:
        return 'Une erreur est survenue. Réessaie.';
    }
  }
}
