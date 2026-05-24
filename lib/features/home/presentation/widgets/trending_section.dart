import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/l10n/app_strings.dart';
import '../../../../../core/providers/otadex_providers.dart';
import '../../../../../core/widgets/skeleton_loader.dart';
import 'section_header.dart';
import 'trending_character_card.dart';

class TrendingSection extends ConsumerWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendingAsync = ref.watch(trendingCharactersProvider);
    final trendingTitle = AppStrings.of(context).trendingNow;

    return trendingAsync.when(
      data: (characters) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: trendingTitle,
            actionLabel: 'Voir tout',
            onAction: () => context.push('/characters', extra: {
              'title': trendingTitle,
              'characters': characters,
            }),
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
      ),
      loading: () => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          SkeletonRow(height: 180, cardWidth: 120, count: 4),
        ],
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
