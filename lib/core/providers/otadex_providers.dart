import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/character.dart';
import '../models/anime_entry.dart';
import '../models/creator_entry.dart';
import '../models/featured_slide.dart';
import '../services/otadex_data_service.dart';

// ── Root data service ───────────────────────────────────────────────────────
final otadexServiceProvider = FutureProvider<OtadexDataService>((ref) {
  return OtadexDataService.load();
});

// ── Characters ──────────────────────────────────────────────────────────────
final allCharactersProvider = Provider<AsyncValue<List<Character>>>((ref) {
  return ref.watch(otadexServiceProvider).whenData((s) => s.characters);
});

final trendingCharactersProvider = Provider<AsyncValue<List<Character>>>((ref) {
  return ref.watch(otadexServiceProvider).whenData((s) => s.trending);
});

final newCharactersProvider =
    Provider.family<AsyncValue<List<Character>>, String?>((ref, category) {
  return ref
      .watch(otadexServiceProvider)
      .whenData((s) => s.newByCategory(category));
});

final recommendedCharactersProvider =
    FutureProvider<List<Character>>((ref) async {
  final service = await ref.watch(otadexServiceProvider.future);
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(AppConstants.keyUserInterests);
  if (raw == null || raw.isEmpty) return service.recommended;
  final interests = List<String>.from(jsonDecode(raw) as List);
  return service.recommendedForInterests(interests);
});

// ── Animes ──────────────────────────────────────────────────────────────────
final allAnimesProvider = Provider<AsyncValue<List<AnimeEntry>>>((ref) {
  return ref.watch(otadexServiceProvider).whenData((s) => s.animes);
});

// ── Creators ────────────────────────────────────────────────────────────────
final allCreatorsProvider = Provider<AsyncValue<List<CreatorEntry>>>((ref) {
  return ref.watch(otadexServiceProvider).whenData((s) => s.creators);
});

// ── Featured slides ──────────────────────────────────────────────────────────
final featuredSlidesProvider = Provider<AsyncValue<List<FeaturedSlide>>>((ref) {
  return ref.watch(otadexServiceProvider).whenData((s) => s.featuredSlides);
});
