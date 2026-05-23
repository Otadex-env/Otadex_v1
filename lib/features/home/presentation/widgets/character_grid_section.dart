import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/models/character.dart';
import '../../../../../core/providers/otadex_providers.dart';
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
            'title': '✨ Nouveautés',
            'characters': newAsync.valueOrNull ?? [],
          }),
        ),
        newAsync.when(
          data: (chars) => _buildGrid(chars, startOffset: 0),
          loading: () => const _GridLoader(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        // ── Recommandés ─────────────────────────────────────────────────────
        SectionHeader(
          title: '⭐ Recommandés pour toi',
          actionLabel: 'Voir tout',
          onAction: () => context.push('/characters', extra: {
            'title': '⭐ Recommandés pour toi',
            'characters': recommendedAsync.valueOrNull ?? [],
          }),
        ),
        recommendedAsync.when(
          data: (chars) => _buildGrid(
            chars,
            startOffset: newAsync.valueOrNull?.length ?? 0,
          ),
          loading: () => const _GridLoader(),
          error: (_, __) => const SizedBox.shrink(),
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildGrid(List<Character> chars, {required int startOffset}) {
    if (chars.isEmpty) {
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
      itemCount: chars.length,
      itemBuilder: (context, i) => CharacterGridCard(
        character: chars[i],
        onTap: () => context.push(
          '/character/${chars[i].id}',
          extra: chars[i],
        ),
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
      padding: EdgeInsets.symmetric(vertical: 32),
      child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }
}
