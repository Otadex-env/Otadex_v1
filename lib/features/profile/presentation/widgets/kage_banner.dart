import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';

class KageBanner extends StatelessWidget {
  final VoidCallback onDismiss;

  const KageBanner({super.key, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
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
            onTap: () {},
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
