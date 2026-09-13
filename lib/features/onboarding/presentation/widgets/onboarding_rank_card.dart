import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingRankCard extends StatelessWidget {
  final String rank;
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String priceLabel;
  final bool isPriceBadge;
  final bool badgeIsGreen;
  final bool premiumBadge;
  final String description;
  final int delay;
  final Color? priceColor;

  const OnboardingRankCard({
    super.key,
    required this.rank,
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.priceLabel,
    required this.description,
    required this.delay,
    this.isPriceBadge = false,
    this.badgeIsGreen = false,
    this.premiumBadge = false,
    this.priceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
              border: Border.all(
                color: color.withValues(alpha: 0.30),
                width: 1.0,
              ),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rank,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: color,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isPriceBadge)
                OnboardingPillBadge(
                  label: priceLabel,
                  color: badgeIsGreen ? AppColors.success : AppColors.accent,
                )
              else
                Text(
                  priceLabel,
                  style: GoogleFonts.rajdhani(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: priceColor ?? AppColors.accent,
                  ),
                  textAlign: TextAlign.end,
                ),
              if (premiumBadge) ...[
                const SizedBox(height: 4),
                const OnboardingPillBadge(
                  label: 'PREMIUM',
                  color: AppColors.accent,
                ),
              ],
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: Duration(milliseconds: delay),
        )
        .slideX(
          begin: 0.06,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: delay),
        );
  }
}

class OnboardingPillBadge extends StatelessWidget {
  final String label;
  final Color color;

  const OnboardingPillBadge({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Rajdhani',
          fontWeight: FontWeight.w700,
          fontSize: 10,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
