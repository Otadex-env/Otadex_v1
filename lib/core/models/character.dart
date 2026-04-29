import 'package:flutter/material.dart';

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
    );
  }

  String get tierLabel => switch (tier) {
        CharacterTier.ss => 'SS',
        CharacterTier.s => 'S',
        CharacterTier.a => 'A',
        CharacterTier.b => 'B',
      };

  Color get tierColor => switch (tier) {
        CharacterTier.ss => const Color(0xFFFF6500),
        CharacterTier.s => const Color(0xFF9B59B6),
        CharacterTier.a => const Color(0xFF7EABC9),
        CharacterTier.b => const Color(0xFF22C55E),
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
