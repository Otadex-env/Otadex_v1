import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Likes réels — un document par like, ID déterministe `{uid}_{characterId}`
/// (même principe que `votes`). `characters/{id}` est en écriture bloquée
/// côté règles : le compteur ne peut PAS vivre sur le document personnage,
/// il se déduit par agrégation sur cette collection.
class LikeService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference _likeDoc(String characterId) =>
      _db.collection('likes').doc('${_uid}_$characterId');

  Future<int> getLikeCount(String characterId) async {
    final agg = await _db
        .collection('likes')
        .where('character_id', isEqualTo: characterId)
        .count()
        .get();
    return agg.count ?? 0;
  }

  Future<bool> isLiked(String characterId) async {
    final uid = _uid;
    if (uid == null) return false;
    final doc = await _likeDoc(characterId).get();
    return doc.exists;
  }

  /// Idempotent : si le like existe déjà, ne réincrémente pas `score_fan`.
  Future<void> like(String characterId) async {
    final uid = _uid;
    if (uid == null) throw 'Non connecté';
    final ref = _likeDoc(characterId);
    final existing = await ref.get();
    if (existing.exists) return;
    final batch = _db.batch();
    batch.set(ref, {
      'user_id': uid,
      'character_id': characterId,
      'created_at': FieldValue.serverTimestamp(),
    });
    // score_fan +1 uniquement à la création du like — jamais au retrait,
    // sinon liker/déliker en boucle permettrait de farmer le score.
    batch.update(_db.collection('users').doc(uid), {
      'score_fan': FieldValue.increment(1),
    });
    await batch.commit();
  }

  Future<void> unlike(String characterId) async {
    final uid = _uid;
    if (uid == null) return;
    await _likeDoc(characterId).delete();
  }
}
