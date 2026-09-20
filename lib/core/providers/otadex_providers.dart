import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../constants/genre_catalog.dart';
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
  ref.keepAlive();
  final firestoreChars =
      await ref.watch(_firestoreServiceProvider).getAllCharacters(limit: 20);

  if (firestoreChars.isNotEmpty) return firestoreChars;

  debugPrint('⚠️ Firestore vide — vérifier import_jjk.js');
  final jsonService = await ref.read(otadexServiceProvider.future);
  return jsonService.characters;
});

// ── Trending : top 5 par animé, interleaved pour diversité visuelle ────────
final trendingCharactersProvider = FutureProvider<List<Character>>((ref) async {
  final all = await ref.watch(allCharactersProvider.future);
  if (all.isEmpty) return [];

  // Group by anime, sort each group by popularityRank asc (1 = meilleur)
  final groups = <String, List<Character>>{};
  for (final c in all) {
    groups.putIfAbsent(c.animeName, () => []).add(c);
  }
  for (final g in groups.values) {
    g.sort((a, b) => a.popularityRank.compareTo(b.popularityRank));
  }

  // Top 5 par animé → interleaving round-robin
  final tops = groups.values.map((g) => g.take(5).toList()).toList();
  final result = <Character>[];
  final maxLen = tops.fold(0, (m, g) => g.length > m ? g.length : m);
  for (int i = 0; i < maxLen; i++) {
    for (final group in tops) {
      if (i < group.length) result.add(group[i]);
    }
  }
  return result;
});

// ── Récents : triés par created_at desc ─────────────────────────────────────
// `genre` : genre canonique (kDemographicGenres / kMainGenres) ou null = tous.
final recentCharactersProvider =
    FutureProvider.family<List<Character>, String?>((ref, genre) async {
  final all = await ref.watch(allCharactersProvider.future);
  final sorted = [...all]..sort((a, b) {
      final aTs = a.createdAt;
      final bTs = b.createdAt;
      if (aTs == null && bTs == null) return 0;
      if (aTs == null) return 1;
      if (bTs == null) return -1;
      return bTs.compareTo(aTs);
    });
  if (genre == null) return sorted;
  final index = await ref.watch(genreIndexProvider.future);
  return index.filter(sorted, genre);
});

// ── Nouveaux / récents (compat) ─────────────────────────────────────────────
final newCharactersProvider =
    FutureProvider.family<List<Character>, String?>((ref, category) async {
  return ref.watch(recentCharactersProvider(category).future);
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
  final filtered =
      recommended.where((c) => interests.contains(c.category)).toList();
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

// ── Filtre par genre (puces de l'Accueil) ───────────────────────────────────
// Les personnages n'ont PAS de champ genre : leurs genres sont ceux de leur
// animé (`animes/{id}.genres[]`, normalisés par scripts/normalize_genres.js).

/// Index animeId → genres, pour filtrer des personnages par genre.
class GenreIndex {
  final Map<String, Set<String>> _genresByAnime;
  const GenreIndex(this._genresByAnime);

  bool matches(Character c, String genre) =>
      _genresByAnime[c.animeId]?.contains(genre) ?? false;

  List<Character> filter(List<Character> chars, String genre) =>
      chars.where((c) => matches(c, genre)).toList();
}

final genreIndexProvider = FutureProvider<GenreIndex>((ref) async {
  final animes = await ref.watch(allAnimesProvider.future);
  return GenreIndex({for (final a in animes) a.id: a.genres.toSet()});
});

/// Puces à afficher : catalogue fixe, réduit aux genres qui ramènent au moins
/// un personnage — une puce ne doit jamais mener à un écran vide.
class GenreChips {
  final List<String> demographics;
  final List<String> genres;
  const GenreChips({required this.demographics, required this.genres});

  bool contains(String genre) =>
      demographics.contains(genre) || genres.contains(genre);
}

final genreChipsProvider = FutureProvider<GenreChips>((ref) async {
  final all = await ref.watch(allCharactersProvider.future);
  final index = await ref.watch(genreIndexProvider.future);
  bool hasResult(String g) => all.any((c) => index.matches(c, g));
  return GenreChips(
    demographics: kDemographicGenres.where(hasResult).toList(),
    genres: kMainGenres.where(hasResult).toList(),
  );
});

/// Genre sélectionné par l'utilisateur (`null` = « Tous »).
final selectedGenreProvider = StateProvider<String?>((ref) => null);

/// Genre réellement appliqué : la sélection n'est valable que si sa puce existe
/// encore (données rechargées) ; sinon retour à « Tous ».
final activeGenreProvider = Provider<String?>((ref) {
  final selected = ref.watch(selectedGenreProvider);
  if (selected == null) return null;
  final chips = ref.watch(genreChipsProvider).valueOrNull;
  if (chips == null) return selected; // chargement : on garde le choix
  return chips.contains(selected) ? selected : null;
});
