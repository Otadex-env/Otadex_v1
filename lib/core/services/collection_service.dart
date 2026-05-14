import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CollectionService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference get _userDoc => _db.collection('users').doc(_uid);

  Future<List<String>> getCollection() async {
    if (_uid == null) return [];
    try {
      final doc = await _userDoc.get();
      final data = doc.data() as Map<String, dynamic>?;
      return List<String>.from(data?['collection'] ?? []);
    } catch (e) {
      return [];
    }
  }

  Stream<List<String>> collectionStream() {
    if (_uid == null) return Stream.value([]);
    return _userDoc.snapshots().map((doc) {
      final data = doc.data() as Map<String, dynamic>?;
      return List<String>.from(data?['collection'] ?? []);
    });
  }

  Future<void> addToCollection(
    String characterId, {
    required bool isGenin,
    required int currentCount,
  }) async {
    if (_uid == null) throw 'Non connecté';
    if (isGenin && currentCount >= 10) throw 'LIMIT_REACHED';
    await _userDoc.update({
      'collection': FieldValue.arrayUnion([characterId]),
    });
  }

  Future<void> removeFromCollection(String characterId) async {
    if (_uid == null) return;
    await _userDoc.update({
      'collection': FieldValue.arrayRemove([characterId]),
    });
  }

  Future<bool> isCollected(String characterId) async {
    final collection = await getCollection();
    return collection.contains(characterId);
  }
}
