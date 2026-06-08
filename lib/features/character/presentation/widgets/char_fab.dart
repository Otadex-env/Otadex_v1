import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/character.dart';
import '../../../../core/providers/anilist_providers.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/currency_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/rank_theme.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/auth_gate_modal.dart';

class CharDetailFab extends ConsumerWidget {
  final Character character;
  final RankTheme theme;
  final String rank;

  const CharDetailFab({
    super.key,
    required this.character,
    required this.theme,
    required this.rank,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollected = ref.watch(isCollectedProvider(character.id));
    final collectionAsync = ref.watch(collectionStreamProvider);

    return Positioned(
      right: 20,
      bottom: 24,
      child: GestureDetector(
        onTap: () {
          if (!ref.read(isLoggedInProvider)) {
            showAuthGateModal(context);
            return;
          }
          _handleCollectTap(context, ref, isCollected, collectionAsync);
        },
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

  Future<void> _handleCollectTap(
    BuildContext context,
    WidgetRef ref,
    bool isCollected,
    AsyncValue<List<String>> collectionAsync,
  ) async {
    final service = ref.read(collectionServiceProvider);

    if (isCollected) {
      await service.removeFromCollection(character.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Retiré de ta collection')),
        );
      }
      return;
    }

    final currentCount = collectionAsync.valueOrNull?.length ?? 0;
    final isGenin = rank == 'genin';

    try {
      await service.addToCollection(
        character.id,
        isGenin: isGenin,
        currentCount: currentCount,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${character.name} ajouté à ta collection !'),
            backgroundColor: AppColors.statGreen,
          ),
        );
      }
    } catch (e) {
      if (e == 'LIMIT_REACHED' && context.mounted) {
        _showLimitModal(context, ref);
      }
    }
  }

  void _showLimitModal(BuildContext context, WidgetRef ref) {
    final currency = ref.read(currencyProvider);
    final joninMonthly = PlanPrices.jonin(false, currency);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎴', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Collection complète !',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu as atteint la limite de 10 personnages.\nPasse Jonin pour une collection illimitée.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/subscription');
                },
                child: Text(
                  'Devenir Jonin — $joninMonthly',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Pas maintenant',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
