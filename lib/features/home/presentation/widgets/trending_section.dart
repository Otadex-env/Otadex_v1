import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/data/mock_data.dart';
import 'section_header.dart';
import 'trending_character_card.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final characters = MockData.trending();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: '🔥 Trending',
          actionLabel: 'Voir tout',
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: characters.length,
            padding: const EdgeInsets.only(right: 16),
            itemBuilder: (context, i) => TrendingCharacterCard(
              character: characters[i],
              index: i,
              onTap: () => context.push(
                '/character/${characters[i].id}',
                extra: characters[i],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
