import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _authUidProvider = StreamProvider.autoDispose<String?>(
  (_) => FirebaseAuth.instance.authStateChanges().map((u) => u?.uid),
);

/// Score fan réel de l'utilisateur connecté (`users/{uid}.score_fan`), en
/// direct : commentaires, votes, likes et quiz l'incrémentent dans Firestore.
final fanScoreProvider = StreamProvider.autoDispose<int>((ref) {
  final uid = ref.watch(_authUidProvider).valueOrNull;
  if (uid == null) return Stream.value(0);
  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((d) => (d.data()?['score_fan'] as num?)?.toInt() ?? 0);
});
