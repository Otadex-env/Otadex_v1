import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/character.dart';
import '../models/anime_entry.dart';
import '../models/creator_entry.dart';
import '../models/featured_slide.dart';

class OtadexDataService {
  OtadexDataService._({
    required this.characters,
    required this.animes,
    required this.creators,
  });

  final List<Character> characters;
  final List<AnimeEntry> animes;
  final List<CreatorEntry> creators;

  // ── Singleton cache ──────────────────────────────────────────────────────
  static OtadexDataService? _instance;

  static Future<OtadexDataService> load() async {
    if (_instance != null) return _instance!;
    final raw = await rootBundle.loadString('assets/data/otadex_data.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;

    _instance = OtadexDataService._(
      characters: (data['characters'] as List<dynamic>)
          .map((e) => Character.fromJson(e as Map<String, dynamic>))
          .toList(),
      animes: (data['animes'] as List<dynamic>)
          .map((e) => AnimeEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      creators: (data['creators'] as List<dynamic>)
          .map((e) => CreatorEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    return _instance!;
  }

  // ── Character filters ────────────────────────────────────────────────────
  List<Character> get trending =>
      characters.where((c) => c.isTrending).toList();

  List<Character> get newCharacters =>
      characters.where((c) => c.isNew).toList();

  List<Character> get recommended =>
      characters.where((c) => c.isRecommended).toList();

  List<Character> get featured =>
      characters.where((c) => c.isFeatured).toList();

  List<Character> newByCategory(String? category) {
    final filtered = characters.where((c) => c.isNew);
    if (category == null || category == 'Tous') return filtered.toList();
    return filtered.where((c) => c.category == category).toList();
  }

  List<Character> recommendedForInterests(List<String> interests) {
    if (interests.isEmpty) return recommended;
    final filtered = characters
        .where((c) => c.isRecommended && interests.contains(c.category))
        .toList();
    return filtered.isEmpty ? recommended : filtered;
  }

  // ── FeaturedSlides generated from featured animes ────────────────────────
  List<FeaturedSlide> get featuredSlides {
    final featuredAnimes = animes.where((a) => a.isFeatured).take(4).toList();
    if (featuredAnimes.isEmpty) return _fallbackSlides;

    return featuredAnimes.map((anime) {
      final char = characters.firstWhere(
        (c) => c.animeName == anime.name && c.isFeatured,
        orElse: () => characters.firstWhere(
          (c) => c.animeName == anime.name,
          orElse: () => characters.first,
        ),
      );
      final tag = char.isTrending
          ? 'TENDANCE'
          : char.isNew
              ? 'NOUVEAU'
              : 'VEDETTE';
      return FeaturedSlide(
        id: anime.id,
        title: anime.name,
        subtitle: anime.airedSeason != null
            ? '${anime.airedSeason} · ${anime.studio}'
            : anime.studio,
        tag: tag,
        primaryColor: anime.cardColor,
        secondaryColor: anime.accentColor,
        category: anime.category,
      );
    }).toList();
  }

  // ── Search helpers ────────────────────────────────────────────────────────
  List<Character> searchCharacters(String query) {
    final q = query.toLowerCase();
    return characters
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            c.animeName.toLowerCase().contains(q) ||
            c.aliases.any((a) => a.toLowerCase().contains(q)))
        .toList();
  }

  List<AnimeEntry> searchAnimes(String query) {
    final q = query.toLowerCase();
    return animes
        .where((a) =>
            a.name.toLowerCase().contains(q) ||
            a.originalTitle.toLowerCase().contains(q) ||
            a.studio.toLowerCase().contains(q))
        .toList();
  }

  List<CreatorEntry> searchCreators(String query) {
    final q = query.toLowerCase();
    return creators
        .where((c) =>
            c.name.toLowerCase().contains(q) ||
            (c.realName?.toLowerCase().contains(q) ?? false) ||
            c.works.any((w) => w.toLowerCase().contains(q)))
        .toList();
  }

  // ── Lookups ────────────────────────────────────────────────────────────────
  Character? characterById(String id) {
    try {
      return characters.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  AnimeEntry? animeById(String id) {
    try {
      return animes.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  CreatorEntry? creatorById(String id) {
    try {
      return creators.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Fallback slides if JSON has no featured animes ────────────────────────
  static final List<FeaturedSlide> _fallbackSlides = [
    const FeaturedSlide(
      id: 'f1',
      title: 'Solo Leveling',
      subtitle: 'Saison 2 — Arise from the Shadow',
      tag: 'NOUVEAU',
      primaryColor: Color(0xFF1A0D2E),
      secondaryColor: Color(0xFF9B59B6),
      category: 'Manhwa',
    ),
    const FeaturedSlide(
      id: 'f2',
      title: 'Demon Slayer',
      subtitle: 'Arc Infinity Castle — Épisodes exclusifs',
      tag: 'TENDANCE',
      primaryColor: Color(0xFF1A0A0A),
      secondaryColor: Color(0xFFE53935),
      category: 'Shōnen',
    ),
  ];
}
