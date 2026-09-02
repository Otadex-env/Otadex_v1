import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/otadex_button.dart';
import 'onboarding_rank_card.dart';

class SlideThreeContent extends StatefulWidget {
  final VoidCallback? onFinish;
  const SlideThreeContent({super.key, this.onFinish});

  @override
  State<SlideThreeContent> createState() => _SlideThreeContentState();
}

class _SlideThreeContentState extends State<SlideThreeContent>
    with TickerProviderStateMixin {
  late final AnimationController _floatCtrl;
  late final AnimationController _auraCtrl;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
    )..repeat();
    _auraCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..repeat();
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _auraCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final topPad = mq.padding.top;
    final screenH = mq.size.height;
    final imgZoneH = (screenH * 0.44).clamp(200.0, 330.0);
    final totalHeroH = imgZoneH + topPad;
    final s = AppStrings.of(context);

    return Stack(
      children: [
        // ── Hero zone: image + aura ──────────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: totalHeroH,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: Listenable.merge([_floatCtrl, _auraCtrl]),
                builder: (_, __) => SizedBox.expand(
                  child: CustomPaint(
                    painter: _AuraPainter(
                      glowAlpha: 0.18 +
                          math.sin(_floatCtrl.value * 2 * math.pi).abs() *
                              0.14,
                      ringProgress: _auraCtrl.value,
                      relativeCenter: 0.60,
                    ),
                  ),
                ),
              ),

              // Floating image
              Padding(
                padding: EdgeInsets.only(top: topPad + 4),
                child: AnimatedBuilder(
                  animation: _floatCtrl,
                  builder: (_, child) {
                    final dy =
                        math.sin(_floatCtrl.value * 2 * math.pi) * 10.0;
                    return Transform.translate(
                      offset: Offset(0, dy),
                      child: child,
                    );
                  },
                  child: Image.asset(
                    AppAssets.onboarding2Alt,
                    width: 260,
                    height: 260,
                    fit: BoxFit.contain,
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.78, 0.78),
                      end: const Offset(1.0, 1.0),
                      duration: 700.ms,
                      curve: Curves.easeOutBack,
                      delay: 80.ms,
                    )
                    .fade(duration: 500.ms, delay: 80.ms),
              ),

              // Bottom fade into content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 88,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundDeep.withValues(alpha: 0),
                        AppColors.backgroundDeep,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Scrollable content ───────────────────────────────────────────────
        SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.lg,
            totalHeroH - 14,
            AppSpacing.lg,
            AppSpacing.xxl + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                s.slide3Title,
                style: GoogleFonts.rajdhani(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 500.ms, delay: 150.ms).slideY(
                    begin: 0.15,
                    end: 0,
                    duration: 500.ms,
                    delay: 150.ms,
                  ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                s.slide3Subtitle,
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms, delay: 280.ms),
              const SizedBox(height: AppSpacing.xl),
              OnboardingRankCard(
                rank: 'GENIN',
                color: AppColors.rankGenin,
                bgColor: AppColors.rankGeninBg,
                icon: Icons.flash_on_outlined,
                priceLabel: s.rankGeninFreeLabel,
                isPriceBadge: true,
                badgeIsGreen: true,
                description: s.rankGeninDesc,
                delay: 380,
              ),
              const SizedBox(height: AppSpacing.md),
              OnboardingRankCard(
                rank: 'JONIN',
                color: AppColors.rankJonin,
                bgColor: AppColors.rankJoninBg,
                icon: Icons.auto_awesome_outlined,
                priceLabel: PlanPrices.jonin(),
                isPriceBadge: false,
                description: s.rankJoninDesc,
                delay: 500,
              ),
              const SizedBox(height: AppSpacing.md),
              OnboardingRankCard(
                rank: 'KAGE',
                color: AppColors.rankKage,
                bgColor: AppColors.rankKageBg,
                icon: Icons.workspace_premium_outlined,
                priceLabel: PlanPrices.kage(),
                isPriceBadge: false,
                premiumBadge: true,
                description: s.rankKageDesc,
                delay: 620,
              ),
              const SizedBox(height: AppSpacing.xl),
              OtadexButton(
                label: s.startAdventureButton,
                onPressed: widget.onFinish,
              ).animate().fadeIn(duration: 500.ms, delay: 750.ms).slideY(
                    begin: 0.12,
                    end: 0,
                    duration: 500.ms,
                    delay: 750.ms,
                  ),
              const SizedBox(height: AppSpacing.md),
              Text(
                s.canChangeRankLater,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  color: AppColors.textDisabled,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms, delay: 870.ms),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Aura painter ──────────────────────────────────────────────────────────────

class _AuraPainter extends CustomPainter {
  final double glowAlpha;
  final double ringProgress;
  final double relativeCenter;

  const _AuraPainter({
    required this.glowAlpha,
    required this.ringProgress,
    required this.relativeCenter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * relativeCenter);

    // Soft radial glow
    canvas.drawCircle(
      center,
      200,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.accent.withValues(alpha: glowAlpha),
            AppColors.primary.withValues(alpha: glowAlpha * 0.45),
            Colors.transparent,
          ],
          stops: const [0.0, 0.40, 1.0],
        ).createShader(Rect.fromCircle(center: center, radius: 200)),
    );

    // 3 expanding pulse rings staggered at 1/3 intervals
    final ringPaint = Paint()..style = PaintingStyle.stroke;
    for (int i = 0; i < 3; i++) {
      final t = (ringProgress + i / 3.0) % 1.0;
      final radius = 70.0 + t * 120.0;
      final alpha = (1.0 - t) * 0.28;
      ringPaint
        ..strokeWidth = (1.0 - t) * 1.8
        ..color = AppColors.accent.withValues(alpha: alpha);
      canvas.drawCircle(center, radius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(_AuraPainter old) =>
      old.glowAlpha != glowAlpha || old.ringProgress != ringProgress;
}
