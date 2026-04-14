import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final Widget title;
  final String subtitle;
  final Widget? bottomWidget;

  const OnboardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image / placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            child: Image.asset(
              imagePath,
              width: size.width * 0.8,
              height: size.height * 0.35,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                width: size.width * 0.8,
                height: size.height * 0.35,
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Center(
                  child: Text(
                    imagePath.split('/').last,
                    style: GoogleFonts.nunitoSans(
                      color: AppColors.textDisabled,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xl),

          // Titre
          DefaultTextStyle(
            style: GoogleFonts.rajdhani(
              fontSize: 36,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            child: title,
          ),

          const SizedBox(height: AppSpacing.md),

          // Sous-titre
          Text(
            subtitle,
            style: GoogleFonts.nunitoSans(
              fontSize: 15,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          if (bottomWidget != null) ...[
            const SizedBox(height: AppSpacing.xl),
            bottomWidget!,
          ],
        ],
      ),
    );
  }
}
