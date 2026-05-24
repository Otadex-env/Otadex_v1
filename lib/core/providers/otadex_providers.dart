import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../models/character.dart';
import '../models/anime_entry.dart';
import '../models/creator_entry.dart';
import '../services/firestore_character_service.dart';
import '../services/otadex_data_service.dart';

// ── Root data service (fallback JSON) ──────────────────────────────────────
final otadexServiceProvider = FutureProvider<OtadexDataService>((ref) {
  return OtadexDataService.load();
});

// ── Firestore service ───────────────────────────────────────────────────────
final _firestoreServiceProvider = Provider<FirestoreCharacterService>(
  (_) => FirestoreCharacterService(),
);

// ── PRIORITÉ 1 : Firestore — PRIORITÉ 2 : JSON mock ────────────────────────
final allCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final firestoreChars = await ref
      .watch(_firestoreServiceProvider)
      .getAllCharacters(limit: 200);

  if (firestoreChars.isNotEmpty) return firestoreChars;

  debugPrint('⚠️ Firestore vide — vérifier import_jjk.js');
  final jsonService = await ref.read(otadexServiceProvider.future);
  return jsonService.characters;
});

// ── Trending : personnages Firestore les plus populaires ───────────────────
final trendingCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final all = await ref.watch(allCharactersProvider.future);
  if (all.isEmpty) return [];
  final trending = all.where((c) => c.isTrending).toList();
  if (trending.isNotEmpty) return trending.take(20).toList();
  final sorted = [...all]..sort((a, b) => b.likes.compareTo(a.likes));
  return sorted.take(20).toList();
});

// ── Nouveaux / récents ──────────────────────────────────────────────────────
final newCharactersProvider =
    FutureProvider.family<List<Character>, String?>((ref, category) async {
  final all = await ref.watch(allCharactersProvider.future);
  var newChars = all.where((c) => c.isNew || c.isTrending).toList()
    ..sort((a, b) => b.likes.compareTo(a.likes));
  if (category == null || category == 'Tous') return newChars;
  return newChars.where((c) => c.category == category).toList();
});

// ── Recommandés ─────────────────────────────────────────────────────────────
final recommendedCharactersProvider =
    FutureProvider<List<Character>>((ref) async {
  final all = await ref.watch(allCharactersProvider.future);
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(AppConstants.keyUserInterests);
  final recommended = all.where((c) => c.isRecommended).toList()
    ..sort((a, b) => b.likes.compareTo(a.likes));
  if (raw == null || raw.isEmpty) return recommended;
  final interests = List<String>.from(jsonDecode(raw) as List);
  if (interests.isEmpty) return recommended;
  final filtered = recommended.where((c) => interests.contains(c.category)).toList();
  return filtered.isEmpty ? recommended : filtered;
});

// ── Animes ──────────────────────────────────────────────────────────────────
final allAnimesProvider = FutureProvider<List<AnimeEntry>>((ref) async {
  final firestoreAnimes =
      await ref.watch(_firestoreServiceProvider).getAllAnimes();
  if (firestoreAnimes.isNotEmpty) return firestoreAnimes;
  final jsonService = await ref.read(otadexServiceProvider.future);
  return jsonService.animes;
});

// ── Creators ────────────────────────────────────────────────────────────────
final allCreatorsProvider = FutureProvider<List<CreatorEntry>>((ref) async {
  final firestoreCreators =
      await ref.watch(_firestoreServiceProvider).getAllCreators();
  if (firestoreCreators.isNotEmpty) return firestoreCreators;
  final jsonService = await ref.read(otadexServiceProvider.future);
  return jsonService.creators;
});

// ── Catégories dynamiques dérivées des genres Firestore ─────────────────────
final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final animes = await ref.watch(allAnimesProvider.future);
  final seen = <String>{};
  final result = <String>['Tous'];
  const prioritized = ['Shōnen', 'Seinen', 'Isekai', 'Shōjo', 'Manhwa', 'Mecha'];
  for (final priority in prioritized) {
    if (animes.any((a) => a.genres.contains(priority)) && seen.add(priority)) {
      result.add(priority);
    }
  }
  for (final a in animes) {
    for (final g in a.genres) {
      if (seen.add(g)) result.add(g);
    }
  }
  return result.length > 1 ? result : ['Tous', ...prioritized];
});

