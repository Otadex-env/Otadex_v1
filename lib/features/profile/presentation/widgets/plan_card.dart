import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';

class PlanCard extends StatelessWidget {
  final String name;
  final String? tag;
  final Color tagColor;
  final String price;
  final Color priceColor;
  final List<(bool, String)> features;
  final String buttonLabel;
  final bool buttonEnabled;
  final Color borderColor;
  final bool isCta;
  final VoidCallback? onUpgrade;

  /// Masque entièrement le bouton d'action (CTA d'achat désactivé par
  /// `kEnablePaidPlans`). La carte reste informative : features + prix.
  final bool hideButton;

  const PlanCard({
    super.key,
    required this.name,
    required this.tag,
    required this.tagColor,
    required this.price,
    required this.priceColor,
    required this.features,
    required this.buttonLabel,
    required this.buttonEnabled,
    required this.borderColor,
    required this.isCta,
    this.onUpgrade,
    this.hideButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.rajdhani(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: theme.textPrimary,
                ),
              ),
              if (tag != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tagColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag!,
                    style: GoogleFonts.rajdhani(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: tagColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: priceColor,
            ),
          ),
          const SizedBox(height: 10),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(
                    f.$1 ? '✓' : '✗',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: f.$1 ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    f.$2,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: f.$1 ? theme.textPrimary : theme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!hideButton) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: isCta
                ? ElevatedButton(
                    onPressed: onUpgrade,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rankJonin,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      buttonLabel,
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: buttonEnabled ? onUpgrade : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: buttonEnabled
                            ? theme.borderDefault
                            : theme.borderSubtle,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      buttonLabel,
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: buttonEnabled
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: buttonEnabled
                            ? theme.textPrimary
                            : theme.textSecondary,
                      ),
                    ),
                  ),
          ),
          ],
        ],
      ),
    );
  }
}
