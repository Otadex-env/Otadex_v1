import 'package:flutter/material.dart';

class AnimeEntry {
  final String id;
  final String name;
  final String originalTitle;
  final String category;
  final List<String> genres;
  final int year;
  final int seasons;
  final int episodes;
  final String status;
  final String studio;
  final String? creatorId;
  final double rating;
  final String synopsis;
  final Color cardColor;
  final Color accentColor;
  final bool isFeatured;
  final List<String> tags;
  final String? airedSeason;

  const AnimeEntry({
    required this.id,
    required this.name,
    required this.originalTitle,
    required this.category,
    required this.genres,
    required this.year,
    required this.seasons,
    required this.episodes,
    required this.status,
    required this.studio,
    this.creatorId,
    required this.rating,
    required this.synopsis,
    required this.cardColor,
    required this.accentColor,
    this.isFeatured = false,
    this.tags = const [],
    this.airedSeason,
  });

  factory AnimeEntry.fromJson(Map<String, dynamic> json) {
    return AnimeEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      originalTitle: json['originalTitle'] as String? ?? '',
      category: json['category'] as String,
      genres: (json['genres'] as List<dynamic>?)?.cast<String>() ?? const [],
      year: (json['year'] as num?)?.toInt() ?? 0,
      seasons: (json['seasons'] as num?)?.toInt() ?? 1,
      episodes: (json['episodes'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      studio: json['studio'] as String? ?? '',
      creatorId: json['creator_id'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      synopsis: json['synopsis'] as String? ?? '',
      cardColor: _hexToColor(json['cardColor'] as String? ?? '#0A1020'),
      accentColor: _hexToColor(json['accentColor'] as String? ?? '#6A1B9A'),
      isFeatured: json['isFeatured'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? const [],
      airedSeason: json['airedSeason'] as String?,
    );
  }

  static Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
