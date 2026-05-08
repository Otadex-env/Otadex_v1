import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../models/anime_entry.dart';
import '../models/featured_slide.dart';
import '../theme/app_colors.dart';
import '../services/anilist_service.dart';
import 'otadex_providers.dart';

// ── AniList service singleton ────────────────────────────────────────────────
final anilistServiceProvider = Provider<AniListService>((_) => AniListService());

// ── Trending characters (live AniList) ───────────────────────────────────────
final trendingCharactersProvider =
    FutureProvider.autoDispose<List<Character>>((ref) {
  return ref.watch(anilistServiceProvider).getTrendingCharacters(perPage: 20);
});

// ── Trending animes (live AniList) ───────────────────────────────────────────
final trendingAnimesProvider =
    FutureProvider.autoDispose<List<AnimeEntry>>((ref) {
  return ref.watch(anilistServiceProvider).getTrendingAnimes(perPage: 5);
});

// ── Hero carousel slides from live AniList animes ────────────────────────────
final featuredSlidesProvider =
    FutureProvider.autoDispose<List<FeaturedSlide>>((ref) async {
  final animes = await ref.watch(trendingAnimesProvider.future);
  if (animes.isEmpty) return _kFallbackSlides;
  return animes
      .map((a) => FeaturedSlide(
            id: a.id,
            title: a.name,
            subtitle: a.studio.isNotEmpty
                ? '${a.year > 0 ? a.year : "Tendance"} · ${a.studio}'
                : (a.year > 0 ? '${a.year}' : 'Tendance'),
            tag: 'TENDANCE',
            primaryColor: a.cardColor,
            secondaryColor: a.accentColor,
            category: a.category,
          ))
      .toList();
});

// ── Real-time search ─────────────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((_) => '');

final searchResultsProvider =
    FutureProvider.autoDispose.family<List<Character>, String>((ref, query) {
  if (query.length < 2) return Future.value([]);
  return ref.watch(anilistServiceProvider).searchCharacters(query, perPage: 20);
});

// ── Character detail (handles both local mock IDs and anilist-* IDs) ─────────
final characterDetailProvider =
    FutureProvider.autoDispose.family<Character?, String>((ref, id) async {
  if (!id.startsWith('anilist-')) {
    final service = await ref.read(otadexServiceProvider.future);
    return service.characterById(id);
  }
  final anilistId = int.tryParse(id.replaceFirst('anilist-', ''));
  if (anilistId == null) return null;
  return ref.watch(anilistServiceProvider).getCharacterById(anilistId);
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
