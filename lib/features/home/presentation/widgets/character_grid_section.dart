import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/character.dart';
import '../../../../../core/providers/otadex_providers.dart';
import '../../../../../core/widgets/skeleton_loader.dart';
import '../../../../../core/utils/image_prefetcher.dart';
import 'character_grid_card.dart';
import 'section_header.dart';

class CharacterGridSection extends ConsumerWidget {
  const CharacterGridSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Genre actif (null = Tous), filtré sur les genres[] de l'animé du personnage.
    final genre = ref.watch(activeGenreProvider);
    final index = ref.watch(genreIndexProvider).valueOrNull;

    final recentAsync = ref.watch(recentCharactersProvider(genre));
    final recommendedAsync = ref.watch(recommendedCharactersProvider);
    final trendingAsync = ref.watch(trendingCharactersProvider);

    // Recommandés / Tendances : filtrés par le même genre. Pas de repli
    // silencieux sur « tout » — une section vide sous un filtre est masquée.
    List<Character> byGenre(List<Character> chars) =>
        (genre == null || index == null) ? chars : index.filter(chars, genre);
    final filteredRecommended = recommendedAsync.whenData(byGenre);
    final filteredTrending = trendingAsync.whenData(byGenre);
    final hideEmpty = genre != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Récents ────────────────────────────────────────────────────────
        SectionHeader(
          title: '🕐 Récents',
          actionLabel: 'Voir tout',
          onAction: () => context.push('/characters', extra: {
            'title': 'Tous les personnages',
          }),
        ),
        recentAsync.when(
          data: (chars) => _buildGrid(chars, startOffset: 0, maxItems: 6),
          loading: () => const _GridLoader(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        // ── Recommandés pour toi ────────────────────────────────────────────
        if (!(hideEmpty &&
            (filteredRecommended.valueOrNull?.isEmpty ?? false))) ...[
          SectionHeader(
            title: '⭐ Recommandés pour toi',
            actionLabel: 'Voir tout',
            onAction: () => context.push('/characters', extra: {
              'title': 'Tous les personnages',
            }),
          ),
          filteredRecommended.when(
            data: (chars) => _buildGrid(
              chars,
              startOffset: recentAsync.valueOrNull?.length ?? 0,
              maxItems: 6,
            ),
            loading: () => const _GridLoader(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],

        // ── Tendances ───────────────────────────────────────────────────────
        if (!(hideEmpty &&
            (filteredTrending.valueOrNull?.isEmpty ?? false))) ...[
          SectionHeader(
            title: '🔥 Tendances',
            actionLabel: 'Voir tout',
            onAction: () => context.push('/characters', extra: {
              'title': 'Tous les personnages',
            }),
          ),
          filteredTrending.when(
            data: (chars) => _buildGrid(
              chars,
              startOffset: (recentAsync.valueOrNull?.length ?? 0) +
                  (filteredRecommended.valueOrNull?.length ?? 0),
              maxItems: 6,
            ),
            loading: () => const _GridLoader(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGrid(List<Character> chars,
      {required int startOffset, int? maxItems}) {
    final display = maxItems != null ? chars.take(maxItems).toList() : chars;
    if (display.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: Text(
            'Aucun personnage dans cette catégorie',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemCount: display.length,
      itemBuilder: (context, i) => CharacterGridCard(
        character: display[i],
        onTap: () {
          ImagePrefetcher.prefetchCharacterImages(context, display[i]);
          context.push('/character/${display[i].id}', extra: display[i]);
        },
      )
          .animate(delay: (60 * i).ms)
          .fadeIn(duration: 300.ms)
          .slideY(begin: 0.1, end: 0, duration: 300.ms, curve: Curves.easeOut),
    );
  }
}

class _GridLoader extends StatelessWidget {
  const _GridLoader();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 8, bottom: 16),
      child: SkeletonGrid(columns: 3, rows: 2),
    );
  }
}
