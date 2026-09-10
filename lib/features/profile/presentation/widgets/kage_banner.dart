import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/subscription/rank_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';

class KageBanner extends ConsumerWidget {
  final VoidCallback onDismiss;

  const KageBanner({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Bandeau promotionnel d'achat : masqué hors parcours de paiement
    // (kEnablePaidPlans). L'activation par clé a ses propres points d'entrée.
    if (!kEnablePaidPlans) return const SizedBox.shrink();
    // Rien à proposer à un Kage : on masque le bandeau.
    if (ref.watch(effectiveRankProvider) == UserRank.kage) {
      return const SizedBox.shrink();
    }

    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.rankJoninBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.rankJonin.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Text('⭐', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              s.kageBannerText,
              style:
                  GoogleFonts.nunitoSans(fontSize: 12, color: theme.textPrimary),
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/subscription'),
            child: Text(
              s.seeOffer,
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.rankJonin,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onDismiss,
            child:
                Icon(Icons.close_rounded, color: theme.textSecondary, size: 16),
          ),
        ],
      ),
    );
  }
}
