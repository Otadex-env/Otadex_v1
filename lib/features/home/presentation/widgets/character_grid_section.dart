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

const _kDefaultCategories = [
  'Tous', 'Shōnen', 'Seinen', 'Isekai', 'Shōjo', 'Manhwa', 'Mecha',
];

class CharacterGridSection extends ConsumerWidget {
  final int selectedCategoryIndex;

  const CharacterGridSection({super.key, required this.selectedCategoryIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories =
        ref.watch(categoriesProvider).valueOrNull ?? _kDefaultCategories;
    final selectedCategory = selectedCategoryIndex == 0 ||
            selectedCategoryIndex >= categories.length
        ? null
        : categories[selectedCategoryIndex];

    final newAsync = ref.watch(newCharactersProvider(selectedCategory));
    final recommendedAsync = ref.watch(recommendedCharactersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Nouveautés ──────────────────────────────────────────────────────
        SectionHeader(
          title: '✨ Nouveautés',
          actionLabel: 'Voir tout',
          onAction: () => context.push('/characters', extra: {
            'title': 'Tous les personnages',
          }),
        ),
        newAsync.when(
          data: (chars) => _buildGrid(chars, startOffset: 0, maxItems: 6),
          loading: () => const _GridLoader(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        // ── Recommandés ─────────────────────────────────────────────────────
        SectionHeader(
          title: '⭐ Recommandés pour toi',
          actionLabel: 'Voir tout',
          onAction: () => context.push('/characters', extra: {
            'title': 'Tous les personnages',
          }),
        ),
        recommendedAsync.when(
          data: (chars) => _buildGrid(
            chars,
            startOffset: newAsync.valueOrNull?.length ?? 0,
            maxItems: 6,
          ),
          loading: () => const _GridLoader(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGrid(List<Character> chars, {required int startOffset, int? maxItems}) {
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
