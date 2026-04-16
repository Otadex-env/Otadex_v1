import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/otadex_button.dart';

class SlideTwoContent extends StatelessWidget {
  final VoidCallback? onNext;

  const SlideTwoContent({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Illustration : mockup téléphone ──
        SizedBox(
          height: size.height * 0.38,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Lueur violette derrière le mockup
              Container(
                width: size.width * 0.70,
                height: size.height * 0.30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.20),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Image mockup
              Image.asset(
                'assets/images/onboarding/onboarding_2.png',
                height: size.height * 0.38,
                fit: BoxFit.contain,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 700.ms, delay: 150.ms)
            .scale(
              begin: const Offset(0.88, 0.88),
              end: const Offset(1.0, 1.0),
              duration: 700.ms,
              delay: 150.ms,
              curve: Curves.easeOutCubic,
            ),

        const SizedBox(height: AppSpacing.xl),

        // ── Zone texte ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              // Titre
              Text.rich(
                TextSpan(
                  style: GoogleFonts.rajdhani(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Explore ',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    TextSpan(
                      text: '10 000+',
                      style: TextStyle(color: AppColors.accent),
                    ),
                    TextSpan(
                      text: '\npersonnages',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .slideY(begin: 0.15, end: 0, duration: 500.ms, delay: 400.ms),

              const SizedBox(height: AppSpacing.sm),

              // Sous-titre
              Text(
                'Fiches complètes · Galeries images\nCitations exclusives',
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 500.ms, delay: 550.ms),

              const SizedBox(height: AppSpacing.xl),

              // Bouton Découvrir
              OtadexButton(
                label: 'Découvrir →',
                onPressed: onNext,
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 680.ms)
                  .slideY(begin: 0.12, end: 0, duration: 400.ms, delay: 680.ms),
            ],
          ),
        ),
      ],
    );
  }
}
