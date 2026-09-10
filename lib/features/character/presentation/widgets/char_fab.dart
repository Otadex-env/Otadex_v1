import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/models/character.dart';
import '../../../../core/providers/anilist_providers.dart';
import '../../../../core/theme/rank_theme.dart';
import '../../../../core/widgets/collection_toggle.dart';

class CharDetailFab extends ConsumerWidget {
  final Character character;
  final RankTheme theme;

  const CharDetailFab({
    super.key,
    required this.character,
    required this.theme,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollected = ref.watch(isCollectedProvider(character.id));

    return Positioned(
      right: 20,
      bottom: 24,
      child: GestureDetector(
        onTap: () => toggleCollection(context, ref, character),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCollected ? theme.accentColor : theme.backgroundElevated,
            border: Border.all(
              color: theme.accentColor
                  .withValues(alpha: isCollected ? 0.0 : 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.accentColor
                    .withValues(alpha: isCollected ? 0.35 : 0.12),
                blurRadius: 14,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            isCollected
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: isCollected ? Colors.white : theme.accentColor,
            size: 22,
          ),
        ),
      ),
    );
  }
}
