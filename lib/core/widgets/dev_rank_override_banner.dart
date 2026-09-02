import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../subscription/rank_providers.dart';
import '../theme/app_colors.dart';

/// Bandeau ambre affiché quand le rang effectif provient de l'override du menu
/// développeur et non de la base (`isRankOverriddenProvider` == true).
///
/// Hors override : `SizedBox.shrink()`. Rend explicite l'écart entre le rang
/// forcé (affiché partout dans l'UI) et le rang réel persisté en base.
class DevRankOverrideBanner extends ConsumerWidget {
  const DevRankOverrideBanner({super.key, this.margin});

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(isRankOverriddenProvider)) return const SizedBox.shrink();

    final forced = ref.watch(effectiveRankProvider).label;
    final real = ref.watch(storedRankProvider).label;

    return Container(
      margin: margin ?? const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.construction_rounded,
              size: 18, color: AppColors.warning),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'MODE DÉVELOPPEUR — rang forcé sur $forced. '
              'Rang réel en base : $real.',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                height: 1.4,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
