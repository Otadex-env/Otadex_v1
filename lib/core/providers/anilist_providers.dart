import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../models/anime_entry.dart';
import '../models/featured_slide.dart';
import '../theme/app_colors.dart';
import '../services/anilist_service.dart';
import '../services/collection_service.dart';
import '../services/firestore_character_service.dart';
import '../services/storage_service.dart';
import 'otadex_providers.dart';

// ── Firestore character service singleton ────────────────────────────────────
final firestoreCharacterServiceProvider = Provider<FirestoreCharacterService>(
  (_) => FirestoreCharacterService(),
);

// ── JJK characters from Firestore ────────────────────────────────────────────
final jjkCharactersProvider = FutureProvider<List<Character>>((ref) {
  return ref
      .watch(firestoreCharacterServiceProvider)
      .getCharactersByAnime('jujutsu-kaisen');
});

// ── CLK characters from Firestore ────────────────────────────────────────────
final clkCharactersProvider = FutureProvider<List<Character>>((ref) {
  return ref
      .watch(firestoreCharacterServiceProvider)
      .getCharactersByAnime('Classroom-of-the-elite');
});

// ── At characters from Firestore ────────────────────────────────────────────
final atCharactersProvider = FutureProvider<List<Character>>((ref) {
  return ref
      .watch(firestoreCharacterServiceProvider)
      .getCharactersByAnime('Attack-on-Titan');
});

// ── Quiz Firestore pour un personnage ────────────────────────────────────────
final firestoreQuizProvider =
    FutureProvider.autoDispose.family<List<QuizQuestion>, String>((ref, id) {
  return ref.watch(firestoreCharacterServiceProvider).getQuizForCharacter(id);
});

// ── AniList service singleton ────────────────────────────────────────────────
final anilistServiceProvider =
    Provider<AniListService>((_) => AniListService());

// ── Trending characters (live AniList — fallback carousel héro) ─────────────
final anilistTrendingCharactersProvider =
    FutureProvider.autoDispose<List<Character>>((ref) {
  return ref.watch(anilistServiceProvider).getTrendingCharacters(perPage: 20);
});

// ── Trending animes (live AniList) ───────────────────────────────────────────
final trendingAnimesProvider =
    FutureProvider.autoDispose<List<AnimeEntry>>((ref) {
  return ref.watch(anilistServiceProvider).getTrendingAnimes(perPage: 5);
});

// ── Hero carousel slides depuis Firestore (allAnimesProvider) ────────────────
final featuredSlidesProvider =
    FutureProvider.autoDispose<List<FeaturedSlide>>((ref) async {
  final animes = await ref.watch(allAnimesProvider.future);
  if (animes.isEmpty) return _kFallbackSlides;
  final featured = animes.where((a) => a.isFeatured).take(5).toList();
  if (featured.isEmpty) return _kFallbackSlides;
  return featured.map((a) {
    final subtitle = [
      if (a.year > 0) '${a.year}',
      if (a.studio.isNotEmpty) a.studio,
    ].join(' · ');
    return FeaturedSlide(
      id: a.id,
      title: a.name,
      subtitle: subtitle.isNotEmpty ? subtitle : a.category,
      tag: 'VEDETTE',
      primaryColor: a.cardColor,
      secondaryColor: a.accentColor,
      category: a.category,
    );
  }).toList();
});

// ── Real-time search ─────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((_) => '');

final searchCharactersProvider = FutureProvider.autoDispose
    .family<List<Character>, String>((ref, query) async {
  if (query.trim().length < 2) return [];
  final firestoreService = ref.watch(firestoreCharacterServiceProvider);
  return firestoreService.searchCharacters(query);
});

final searchAnimesProvider = FutureProvider.autoDispose
    .family<List<AnimeEntry>, String>((ref, query) async {
  if (query.trim().length < 2) return [];
  final firestoreService = ref.watch(firestoreCharacterServiceProvider);
  return firestoreService.searchAnimes(query);
});

final sameAnimeCharactersProvider = FutureProvider.autoDispose
    .family<List<Character>, Map<String, String>>((ref, params) async {
  final animeId = params['animeId'] ?? '';
  final excludeId = params['excludeId'] ?? '';
  if (animeId.isEmpty) return [];
  final firestoreService = ref.watch(firestoreCharacterServiceProvider);
  final firestoreChars = await firestoreService.getSameAnimeCharacters(
    animeId: animeId,
    excludeCharacterId: excludeId,
    limit: 5,
  );
  if (firestoreChars.isNotEmpty) return firestoreChars;
  return [];
});

// ── Character detail : Firestore en priorité pour tout ID, fallback mock ─────
final characterDetailProvider =
    FutureProvider.autoDispose.family<Character?, String>((ref, id) async {
  final fsChar =
      await ref.watch(firestoreCharacterServiceProvider).getCharacterById(id);
  if (fsChar != null) return fsChar;
  final service = await ref.read(otadexServiceProvider.future);
  return service.characterById(id);
});

// ── Firebase Storage ─────────────────────────────────────────────────────────
final storageServiceProvider = Provider<StorageService>(
  (ref) => StorageService(),
);

// ── Collection Firestore ──────────────────────────────────────────────────────
final collectionServiceProvider = Provider<CollectionService>(
  (ref) => CollectionService(),
);

final collectionStreamProvider = StreamProvider<List<String>>((ref) {
  final service = ref.watch(collectionServiceProvider);
  return service.collectionStream();
});

final isCollectedProvider = Provider.family<bool, String>((ref, charId) {
  final collection = ref.watch(collectionStreamProvider);
  return collection.maybeWhen(
    data: (list) => list.contains(charId),
    orElse: () => false,
  );
});

final characterImagesProvider = FutureProvider.autoDispose
    .family<List<String>, Map<String, String>>((ref, params) async {
  final service = ref.watch(storageServiceProvider);
  return service.getCharacterImages(
    anime: params['anime']!,
    character: params['character']!,
  );
});

// ── Fallback slides when AniList is unreachable ──────────────────────────────
const _kFallbackSlides = [
  FeaturedSlide(
    id: 'f-anilist-1',
    title: 'Jujutsu Kaisen',
    subtitle: 'Tendance — Saison 2',
    tag: 'TENDANCE',
    primaryColor: AppColors.backgroundCard,
    secondaryColor: AppColors.rankKage,
    category: 'Shōnen',
  ),
  FeaturedSlide(
    id: 'f-anilist-2',
    title: 'Solo Leveling',
    subtitle: 'Saison 2 — Arise from the Shadow',
    tag: 'NOUVEAU',
    primaryColor: AppColors.backgroundDeep,
    secondaryColor: AppColors.rankJonin,
    category: 'Manhwa',
  ),
];
