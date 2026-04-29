import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/data/mock_data.dart';
import '../../../../../core/models/character.dart';
import '../../../../../core/providers/recommendation_provider.dart';
import 'character_grid_card.dart';
import 'section_header.dart';

class CharacterGridSection extends ConsumerWidget {
  final int selectedCategoryIndex;

  const CharacterGridSection({super.key, required this.selectedCategoryIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = selectedCategoryIndex == 0
        ? null
        : MockData.categories[selectedCategoryIndex];

    final newChars = MockData.newCharacters(category: selectedCategory);
    final recommendedAsync = ref.watch(recommendedCharactersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '✨ Nouveautés', actionLabel: 'Voir tout'),
        _buildGrid(newChars, startOffset: 0),
        const SectionHeader(title: '⭐ Recommandés pour toi', actionLabel: 'Voir tout'),
        recommendedAsync.when(
          data: (chars) => _buildGrid(chars, startOffset: newChars.length),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          ),
          error: (_, __) =>
              _buildGrid(MockData.recommended(), startOffset: newChars.length),
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
            style: TextStyle(color: Color(0xFFA0A0C0), fontSize: 14),
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
