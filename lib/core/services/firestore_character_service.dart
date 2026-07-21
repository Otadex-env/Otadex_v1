import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/character.dart';
import '../models/anime_entry.dart';
import '../models/creator_entry.dart';
import '../theme/app_colors.dart';
import '../constants/app_assets.dart';

class FirestoreCharacterService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Characters ───────────────────────────────────────────────────────────────
  Future<List<Character>> getCharactersByAnime(String animeId) async {
    try {
      final snap = await _db
          .collection('characters')
          .where('animeId', isEqualTo: animeId)
          .orderBy('popularityRank')
          .get();
      return snap.docs.map((d) => _characterFromFirestore(d.id, d.data())).toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Character>> getAllCharacters({int limit = 100}) async {
    try {
      final snap = await _db
          .collection('characters')
          .orderBy('popularityRank')
          .limit(limit)
          .get();
      return snap.docs.map((d) => _characterFromFirestore(d.id, d.data())).toList();
    } catch (e) {
      debugPrint('⚠️ Firestore getAllCharacters error: $e');
      return [];
    }
  }

  Future<(List<Character>, DocumentSnapshot?)> getCharactersPaginated({
    int limit = 20,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _db
          .collection('characters')
          .orderBy('popularityRank')
          .limit(limit + 1);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final snap = await query.get();
      final hasMore = snap.docs.length > limit;
      final docs = hasMore ? snap.docs.sublist(0, limit) : snap.docs;
      final characters =
          docs.map((d) => _characterFromFirestore(d.id, d.data())).toList();

      return (characters, hasMore && docs.isNotEmpty ? docs.last : null);
    } catch (e) {
      debugPrint('⚠️ Firestore getCharactersPaginated error: $e');
      return (<Character>[], null);
    }
  }

  Future<List<Character>> searchCharacters(String query) async {
    if (query.trim().length < 2) return [];
    final q = query.toLowerCase().trim();
    try {
      final snap = await _db.collection('characters').limit(20).get();
      return snap.docs
          .map((d) => _characterFromFirestore(d.id, d.data()))
          .where((c) =>
              c.name.toLowerCase().contains(q) ||
              c.animeName.toLowerCase().contains(q) ||
              (c.role?.toLowerCase().contains(q) ?? false) ||
              c.powers.any((p) => p.toLowerCase().contains(q)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<AnimeEntry>> searchAnimes(String query) async {
    if (query.trim().length < 2) return [];
    final q = query.toLowerCase().trim();
    try {
      final snap = await _db.collection('animes').get();
      return snap.docs
          .map((d) => _animeFromFirestore(d.id, d.data()))
          .where((a) =>
              a.name.toLowerCase().contains(q) ||
              a.genres.any((g) => g.toLowerCase().contains(q)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Character>> getSameAnimeCharacters({
    required String animeId,
    required String excludeCharacterId,
    int limit = 5,
  }) async {
    try {
      final snap = await _db
          .collection('characters')
          .where('animeId', isEqualTo: animeId)
          .orderBy('popularityRank')
          .limit(limit + 1)
          .get();
      return snap.docs
          .map((d) => _characterFromFirestore(d.id, d.data()))
          .where((c) => c.id != excludeCharacterId)
          .take(limit)
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<AnimeEntry>> getAllAnimesWithCharacterCount() =>
      getAllAnimes();

  Future<Character?> getCharacterById(String id) async {
    try {
      final doc = await _db.collection('characters').doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return _characterFromFirestore(doc.id, doc.data()!);
    } catch (_) {
      return null;
    }
  }

  // ── Quizzes ──────────────────────────────────────────────────────────────────
  Future<List<QuizQuestion>> getQuizForCharacter(String characterId) async {
    try {
      final doc = await _db.collection('quizzes').doc(characterId).get();
      if (!doc.exists || doc.data() == null) return [];
      final questions = doc.data()!['questions'] as List<dynamic>? ?? [];
      return questions.map((q) {
        final m = q as Map<String, dynamic>;
        return QuizQuestion(
          question: m['question'] as String? ?? '',
          options: (m['options'] as List<dynamic>).cast<String>(),
          correctIndex: (m['correctIndex'] as num).toInt(),
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // ── Animes ───────────────────────────────────────────────────────────────────
  Future<List<AnimeEntry>> getAllAnimes() async {
    try {
      final snap = await _db.collection('animes').get();
      return snap.docs
          .map((d) => _animeFromFirestore(d.id, d.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<AnimeEntry?> getAnimeById(String id) async {
    try {
      final doc = await _db.collection('animes').doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return _animeFromFirestore(doc.id, doc.data()!);
    } catch (_) {
      return null;
    }
  }

  // ── Creators ─────────────────────────────────────────────────────────────────
  Future<List<CreatorEntry>> getAllCreators() async {
    try {
      final snap = await _db.collection('creators').get();
      return snap.docs
          .map((d) => _creatorFromFirestore(d.id, d.data()))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<CreatorEntry?> getCreatorById(String id) async {
    try {
      final doc = await _db.collection('creators').doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return _creatorFromFirestore(doc.id, doc.data()!);
    } catch (_) {
      return null;
    }
  }

  // ── Mapping Firestore → Character ────────────────────────────────────────────
  Character _characterFromFirestore(String id, Map<String, dynamic> d) {
    final rang = d['rang'] as String? ?? '';
    final animeId = d['animeId'] as String? ?? '';
    final pouvoirs = (d['pouvoirs'] as List<dynamic>?)?.cast<String>() ?? [];
    final citations = (d['citations'] as List<dynamic>?)?.cast<String>() ?? [];
    final trivia = (d['trivia'] as List<dynamic>?)?.cast<String>() ?? [];
    final popularityRank = (d['popularityRank'] as num?)?.toInt() ?? 99;

    final animePrefix = _assetPrefixForAnime(animeId);
    final relations = (d['relations'] as List<dynamic>? ?? []).map((r) {
      final rm = r as Map<String, dynamic>;
      final type = rm['type'] as String? ?? '';
      final nom = rm['nomPersonnage'] as String? ?? '';
      final derivedId = animePrefix.isNotEmpty && nom.isNotEmpty
          ? '$animePrefix-${nom.toLowerCase().replaceAll(' ', '-')}'
          : '';
      return CharacterRelation(
        id: rm['characterId'] as String? ?? derivedId,
        nom: nom,
        imageUrl: _safeImageUrl(rm['imageUrl'] as String? ?? ''),
        relationType: type,
        relationColor: _relationColor(type),
      );
    }).toList();

    final voixJP = d['voixJaponaise'] as String?;
    final voixEN = d['voixAnglaise'] as String?;
    final voiceActors = <VoiceActorMock>[
      if (voixJP != null && voixJP.isNotEmpty)
        VoiceActorMock(nom: voixJP, langue: 'Japonais', imageUrl: ''),
      if (voixEN != null && voixEN.isNotEmpty)
        VoiceActorMock(nom: voixEN, langue: 'Anglais', imageUrl: ''),
    ];

    return Character(
      id: id,
      name: d['nom'] as String? ?? '',
      animeName: d['animeName'] as String? ?? '',
      cardColor: _cardColorForAnime(animeId),
      accentColor: _accentColorForAnime(animeId),
      tier: _rankToTier(rang),
      rating: 9.0,
      likes: (d['likesCount'] as num?)?.toInt() ?? 0,
      imagePath: (d['imagePath'] as String?)?.isNotEmpty == true
          ? d['imagePath'] as String
          : null,
      images: () {
        final fsImages = (d['images'] as List<dynamic>?)?.cast<String>() ?? [];
        if (fsImages.isNotEmpty) return fsImages;
        return AppAssets.getByCharacterId(id);
      }(),
      category: _categoryForAnime(animeId),
      popularityRank: popularityRank,
      isTrending: popularityRank <= 3,
      isNew: false,
      isRecommended: popularityRank <= 10,
      isFeatured: popularityRank == 1,
      bio: d['description'] as String?,
      quote: citations.isNotEmpty ? citations.first : null,
      powers: pouvoirs,
      stats: const {},
      aliases: [],
      gender: d['sexe'] as String?,
      nationality: d['nationalite'] as String?,
      age: d['age'] as String?,
      birthday: d['dateNaissance'] as String?,
      status: d['statut'] as String?,
      role: rang,
      creatorId: d['auteurId'] as String?,
      animeId: animeId.isNotEmpty ? animeId : null,
      dateOfBirth: d['dateNaissance'] as String?,
      quotes: citations,
      trivia: trivia,
      aiPersonality: null,
      voiceActorIds: [],
      createdAt: (d['created_at'] as Timestamp?)?.toDate(),
      relations: relations,
      voiceActors: voiceActors,
      mediaAppearances: [],
      quizQuestions: [],
    );
  }

  // ── Mapping Firestore → AnimeEntry ───────────────────────────────────────────
  AnimeEntry _animeFromFirestore(String id, Map<String, dynamic> d) {
    final episodes = d['episodes'];
    int totalEpisodes = 0;
    if (episodes is Map) {
      totalEpisodes = (episodes.values
          .whereType<num>()
          .fold<num>(0, (a, b) => a + b))
          .toInt();
    } else if (episodes is num) {
      totalEpisodes = episodes.toInt();
    }

    final genres = (d['genres'] as List<dynamic>?)?.cast<String>() ?? [];

    return AnimeEntry(
      id: id,
      name: d['titre'] as String? ?? '',
      originalTitle: d['titreJaponais'] as String? ?? '',
      category: genres.isNotEmpty ? genres.first : 'Shōnen',
      genres: genres,
      year: (d['annee'] as num?)?.toInt() ?? 0,
      seasons: 1,
      episodes: totalEpisodes,
      status: d['statut'] as String? ?? '',
      studio: d['studio'] as String? ?? '',
      creatorId: d['auteurId'] as String?,
      rating: 9.0,
      synopsis: d['synopsis'] as String? ?? '',
      cardColor: _cardColorForAnime(id),
      accentColor: _accentColorForAnime(id),
      isFeatured: true,
      tags: genres,
    );
  }

  // ── Mapping Firestore → CreatorEntry ─────────────────────────────────────────
  CreatorEntry _creatorFromFirestore(String id, Map<String, dynamic> d) {
    final oeuvres = (d['oeuvres'] as List<dynamic>? ?? []).map((o) {
      final om = o as Map<String, dynamic>;
      return om['titre'] as String? ?? '';
    }).where((t) => t.isNotEmpty).toList();

    final nom = d['nom'] as String? ?? '';
    final initials = nom.trim().split(' ').where((p) => p.isNotEmpty).take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return CreatorEntry(
      id: id,
      name: nom,
      role: d['occupation'] as String? ?? 'Mangaka',
      nationality: d['nationalite'] as String?,
      works: oeuvres,
      initials: initials,
      bio: d['bio'] as String?,
      tags: (d['influences'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  // ── Score fan ────────────────────────────────────────────────────────────────
  Future<void> toggleLike(String charId, {required bool isNowLiked}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    try {
      if (isNowLiked) {
        await _db.collection('users').doc(uid).update({
          'score_fan': FieldValue.increment(1),
        });
      }
    } catch (_) {}
  }

  Future<void> submitComment(String charId, String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || text.trim().isEmpty) return;
    try {
      final pseudo = user.displayName ?? 'Fan OTADEX';
      final batch = _db.batch();
      final commentRef = _db.collection('comments').doc();
      batch.set(commentRef, {
        'user_id': user.uid,
        'pseudo': pseudo,
        'character_id': charId,
        'texte': text.trim(),
        'likes': 0,
        'created_at': FieldValue.serverTimestamp(),
      });
      batch.update(_db.collection('users').doc(user.uid), {
        'score_fan': FieldValue.increment(3),
      });
      await batch.commit();
    } catch (_) {}
  }

  Stream<List<Map<String, dynamic>>> streamComments(String charId) {
    return _db
        .collection('comments')
        .where('character_id', isEqualTo: charId)
        .orderBy('created_at', descending: true)
        .limit(10)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  Future<bool> voteForCharacter(String charId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;
    final mois = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
    final voteId = '${uid}_${charId}_$mois';
    try {
      final existing = await _db.collection('votes').doc(voteId).get();
      if (existing.exists) return false;
      final batch = _db.batch();
      batch.set(_db.collection('votes').doc(voteId), {
        'user_id': uid,
        'character_id': charId,
        'mois': mois,
        'created_at': FieldValue.serverTimestamp(),
      });
      batch.update(_db.collection('users').doc(uid), {
        'score_fan': FieldValue.increment(10),
      });
      await batch.commit();
      return true;
    } catch (_) {
      return false;
    }
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────
  CharacterTier _rankToTier(String rang) {
    final r = rang.toLowerCase();
    if (r.contains('spécial')) return CharacterTier.ss;
    if (r.contains('grade 1') || r.contains('grade1')) return CharacterTier.s;
    if (r.contains('grade 2') || r.contains('grade 3') ||
        r.contains('grade2') || r.contains('grade3')) {
      return CharacterTier.a;
    }
    return CharacterTier.b;
  }

  String _relationColor(String type) {
    final t = type.toLowerCase();
    if (t.contains('élève') || t.contains('ami') || t.contains('allié')) return 'green';
    if (t.contains('rival') || t.contains('mentor')) return 'blue';
    if (t.contains('ennemi') || t.contains('antagoniste')) return 'red';
    if (t.contains('famille') || t.contains('frère') || t.contains('père')) return 'amber';
    return 'blue';
  }

  String _safeImageUrl(String url) =>
      url.startsWith('https://') ? url : '';

  // ── Config par anime (ajouter un 9e anime = 1 seul endroit à éditer) ─────────
  ({String prefix, Color cardColor, Color accentColor, String category})
      _configForAnime(String animeId) => switch (animeId) {
            'jujutsu-kaisen' => (
                prefix: 'jjk',
                cardColor: AppColors.animeJjkCard,
                accentColor: AppColors.animeJjkAccent,
                category: 'Shōnen'
              ),
            'naruto-shippuden' => (
                prefix: 'ns',
                cardColor: AppColors.animeNsCard,
                accentColor: AppColors.animeNsAccent,
                category: 'Shōnen'
              ),
            'attack-on-titan' => (
                prefix: 'aot',
                cardColor: AppColors.animeAotCard,
                accentColor: AppColors.animeAotAccent,
                category: 'Seinen'
              ),
            'one-piece' => (
                prefix: 'op',
                cardColor: AppColors.animeOpCard,
                accentColor: AppColors.animeOpAccent,
                category: 'Shōnen'
              ),
            'classroom-of-elite' => (
                prefix: 'clk',
                cardColor: AppColors.animeClkCard,
                accentColor: AppColors.animeClkAccent,
                category: 'Seinen'
              ),
            'fullmetal-alchemist' => (
                prefix: 'fma',
                cardColor: AppColors.animeFmaCard,
                accentColor: AppColors.animeFmaAccent,
                category: 'Shōnen'
              ),
            'hunter-x-hunter' => (
                prefix: 'hxh',
                cardColor: AppColors.animeHxhCard,
                accentColor: AppColors.animeHxhAccent,
                category: 'Shōnen'
              ),
            'mushoku-tensei' => (
                prefix: 'mt',
                cardColor: AppColors.animeMtCard,
                accentColor: AppColors.animeMtAccent,
                category: 'Isekai'
              ),
            _ => (
                prefix: '',
                cardColor: AppColors.animeDefaultCard,
                accentColor: AppColors.animeDefaultAccent,
                category: 'Shōnen'
              ),
          };

  String _assetPrefixForAnime(String animeId) =>
      _configForAnime(animeId).prefix;
  Color _cardColorForAnime(String animeId) =>
      _configForAnime(animeId).cardColor;
  Color _accentColorForAnime(String animeId) =>
      _configForAnime(animeId).accentColor;
  String _categoryForAnime(String animeId) =>
      _configForAnime(animeId).category;
}
