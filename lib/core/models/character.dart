import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

// ── Relation mock ─────────────────────────────────────────────────────────────
class CharacterRelation {
  final String id;
  final String nom;
  final String imageUrl;
  final String relationType;
  final String relationColor; // 'green' | 'blue' | 'red' | 'amber'

  const CharacterRelation({
    required this.id,
    required this.nom,
    required this.imageUrl,
    required this.relationType,
    required this.relationColor,
  });
}

// ── Doubleur mock ─────────────────────────────────────────────────────────────
class VoiceActorMock {
  final String nom;
  final String langue;
  final String imageUrl;

  const VoiceActorMock({
    required this.nom,
    required this.langue,
    required this.imageUrl,
  });
}

// ── Apparition média mock ─────────────────────────────────────────────────────
class MediaAppearanceMock {
  final String animeId;
  final String titre;
  final String coverUrl;
  final String format;
  final int episodes;
  final int annee;
  final String role; // 'MAIN' | 'SUPPORTING'
  final String mangakaId;
  final String mangakaNom;
  final String studioId;
  final String studioNom;

  const MediaAppearanceMock({
    required this.animeId,
    required this.titre,
    required this.coverUrl,
    required this.format,
    required this.episodes,
    required this.annee,
    required this.role,
    required this.mangakaId,
    required this.mangakaNom,
    required this.studioId,
    required this.studioNom,
  });
}

// ── Question quiz ─────────────────────────────────────────────────────────────
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

// ─────────────────────────────────────────────────────────────────────────────

enum CharacterTier { ss, s, a, b }

class Character {
  final String id;
  final String name;
  final String animeName;
  final Color cardColor;
  final Color accentColor;
  final CharacterTier tier;
  final double rating;
  final int likes;
  final String? imagePath;
  final List<String> images;
  final String category;
  final bool isTrending;
  final bool isNew;
  final bool isRecommended;
  // Extended fields from JSON
  final bool isFeatured;
  final String? bio;
  final String? quote;
  final List<String> powers;
  final Map<String, int> stats;
  final List<String> aliases;
  final String? gender;
  final String? nationality;
  final String? age;
  final String? birthday;
  final String? height;
  final String? status;
  final String? role;
  final String? creatorId;
  final String? animeId;
  // ── Champs enrichis ──────────────────────────────────────────────────────────
  final String? bloodType;
  final String? dateOfBirth;
  final List<String> quotes;
  final List<String> trivia;
  final String? aiPersonality;
  final List<String> voiceActorIds;
  // ── Mock data Task 20 ────────────────────────────────────────────────────────
  final List<CharacterRelation> relations;
  final List<VoiceActorMock> voiceActors;
  final List<MediaAppearanceMock> mediaAppearances;
  final List<QuizQuestion> quizQuestions;

  const Character({
    required this.id,
    required this.name,
    required this.animeName,
    required this.cardColor,
    required this.accentColor,
    required this.tier,
    required this.rating,
    required this.likes,
    this.imagePath,
    this.images = const [],
    required this.category,
    this.isTrending = false,
    this.isNew = false,
    this.isRecommended = false,
    this.isFeatured = false,
    this.bio,
    this.quote,
    this.powers = const [],
    this.stats = const {},
    this.aliases = const [],
    this.gender,
    this.nationality,
    this.age,
    this.birthday,
    this.height,
    this.status,
    this.role,
    this.creatorId,
    this.animeId,
    this.bloodType,
    this.dateOfBirth,
    this.quotes = const [],
    this.trivia = const [],
    this.aiPersonality,
    this.voiceActorIds = const [],
    this.relations = const [],
    this.voiceActors = const [],
    this.mediaAppearances = const [],
    this.quizQuestions = const [],
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      animeName: json['animeName'] as String,
      cardColor: _hexToColor(json['cardColor'] as String),
      accentColor: _hexToColor(json['accentColor'] as String),
      tier: _parseTier(json['tier'] as String),
      rating: (json['rating'] as num).toDouble(),
      likes: (json['likes'] as num).toInt(),
      imagePath: json['imagePath'] as String?,
      images: (json['images'] as List<dynamic>?)?.cast<String>() ?? const [],
      category: json['category'] as String,
      isTrending: json['isTrending'] as bool? ?? false,
      isNew: json['isNew'] as bool? ?? false,
      isRecommended: json['isRecommended'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      bio: json['bio'] as String?,
      quote: json['quote'] as String?,
      powers: (json['powers'] as List<dynamic>?)?.cast<String>() ?? const [],
      stats: (json['stats'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          const {},
      aliases:
          (json['aliases'] as List<dynamic>?)?.cast<String>() ?? const [],
      gender: json['gender'] as String?,
      nationality: json['nationality'] as String?,
      age: json['age']?.toString(),
      birthday: json['birthday'] as String?,
      height: json['height'] as String?,
      status: json['status'] as String?,
      role: json['role'] as String?,
      creatorId: json['creator_id'] as String?,
      bloodType: json['bloodType'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      quotes: (json['quotes'] as List<dynamic>?)?.cast<String>() ?? const [],
      trivia: (json['trivia'] as List<dynamic>?)?.cast<String>() ?? const [],
      aiPersonality: json['aiPersonality'] as String?,
      voiceActorIds:
          (json['voiceActorIds'] as List<dynamic>?)?.cast<String>() ?? const [],
      relations: const [],
      voiceActors: const [],
      mediaAppearances: const [],
      quizQuestions: const [],
    );
  }

  String get tierLabel => switch (tier) {
        CharacterTier.ss => 'SS',
        CharacterTier.s => 'S',
        CharacterTier.a => 'A',
        CharacterTier.b => 'B',
      };

  Color get tierColor => switch (tier) {
        CharacterTier.ss => AppColors.accent,
        CharacterTier.s => AppColors.rankJonin,
        CharacterTier.a => AppColors.rankGenin,
        CharacterTier.b => AppColors.success,
      };

  // Initials for fallback avatar (e.g. "Gojo Satoru" → "GS")
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  static Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }

  static CharacterTier _parseTier(String tier) => switch (tier) {
        'SS' => CharacterTier.ss,
        'S' => CharacterTier.s,
        'A' => CharacterTier.a,
        _ => CharacterTier.b,
      };
}
