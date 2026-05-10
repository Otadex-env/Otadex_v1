import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

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
    } on FirebaseAuthException catch (e) {
      throw _mapError(e.code);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
    await prefs.remove(AppConstants.keyUserRank);
  }

  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
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

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Cet email est déjà utilisé.';
      case 'invalid-email':
        return 'Email invalide.';
      case 'weak-password':
        return 'Mot de passe trop faible (8 car. min).';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email ou mot de passe incorrect.';
      case 'too-many-requests':
        return 'Trop de tentatives. Réessaie plus tard.';
      default:
        return 'Une erreur est survenue. Réessaie.';
    }
  }
}
