import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

class SlideOneContent extends StatefulWidget {
  const SlideOneContent({super.key});

  @override
  State<SlideOneContent> createState() => _SlideOneContentState();
}

class _SlideOneContentState extends State<SlideOneContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ── Illustration flottante ──
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: child,
          ),
          child: SizedBox(
            height: size.height * 0.38,
            child: Image.asset(
              'assets/images/onboarding/onboarding_1.png',
              fit: BoxFit.contain,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 700.ms, delay: 200.ms)
            .scale(
              begin: const Offset(0.88, 0.88),
              end: const Offset(1.0, 1.0),
              duration: 700.ms,
              delay: 200.ms,
              curve: Curves.easeOutCubic,
            ),

        const SizedBox(height: AppSpacing.xl),

        // ── Zone texte ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            children: [
              // Pill badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.10),
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusFull),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.35),
                  ),
                ),
                child: Text(
                  '✦  ENCYCLOPÉDIE OTAKU  ✦',
                  style: GoogleFonts.rajdhani(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                    letterSpacing: 1.8,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 400.ms),

              const SizedBox(height: AppSpacing.md),

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
                      text: 'L\'univers ',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    TextSpan(
                      text: 'Animé',
                      style: TextStyle(color: AppColors.accent),
                    ),
                    TextSpan(
                      text: '\ndans ta poche',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 500.ms)
                  .slideY(begin: 0.15, end: 0, duration: 500.ms, delay: 500.ms),

              const SizedBox(height: AppSpacing.md),

              // Sous-titre
              Text(
                'Personnages · Séries · Univers\nTout ce que tu aimes, en un seul endroit.',
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.55,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 500.ms, delay: 650.ms),
            ],
          ),
        ),
      ],
    );
  }
}
