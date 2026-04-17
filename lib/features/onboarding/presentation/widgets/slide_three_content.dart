import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/otadex_button.dart';

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

    return Stack(
      children: [
        // ── Hero zone: image + aura (fixed at top, above content) ──────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: totalHeroH,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Aura: glow blob + expanding pulse rings
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

              // Floating image (no frame, transparent bg)
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
                    'assets/images/onboarding/onboarding_2_1.png',
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

        // ── Scrollable content (sits behind hero, padding pushes it below) ──
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
                'Quel fan es-tu ?',
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
                'Choisis ta voie, grimpe les rangs',
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 400.ms, delay: 280.ms),
              const SizedBox(height: AppSpacing.xl),
              const _RankCard(
                rank: 'GENIN',
                color: AppColors.rankGenin,
                bgColor: AppColors.rankGeninBg,
                icon: Icons.flash_on_outlined,
                priceLabel: 'GRATUIT',
                isPriceBadge: true,
                badgeIsGreen: true,
                description: 'Accès gratuit · Découverte',
                delay: 380,
              ),
              const SizedBox(height: AppSpacing.md),
              const _RankCard(
                rank: 'JONIN',
                color: AppColors.rankJonin,
                bgColor: AppColors.rankJoninBg,
                icon: Icons.auto_awesome_outlined,
                priceLabel: '2 000 FCFA/mois',
                isPriceBadge: false,
                description: 'Sans pub · Collections avancées',
                delay: 500,
              ),
              const SizedBox(height: AppSpacing.md),
              const _RankCard(
                rank: 'KAGE',
                color: AppColors.rankKage,
                bgColor: AppColors.rankKageBg,
                icon: Icons.workspace_premium_outlined,
                priceLabel: '5 000 FCFA/mois',
                isPriceBadge: false,
                premiumBadge: true,
                description: 'Accès IA · Exclusif · Statut ultime',
                delay: 620,
              ),
              const SizedBox(height: AppSpacing.xl),
              OtadexButton(
                label: "Commencer l'aventure →",
                onPressed: widget.onFinish,
              ).animate().fadeIn(duration: 500.ms, delay: 750.ms).slideY(
                    begin: 0.12,
                    end: 0,
                    duration: 500.ms,
                    delay: 750.ms,
                  ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Tu pourras changer de rang plus tard',
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

// ── Tag badge ─────────────────────────────────────────────────────────────────

// ignore: unused_element
class _TagBadge extends StatelessWidget {
  const _TagBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.40),
          width: 1.0,
        ),
      ),
      child: Text(
        '✦  CHOISISSEZ VOTRE VOIE  ✦',
        style: GoogleFonts.rajdhani(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
          letterSpacing: 2.2,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 250.ms)
        .slideY(begin: -0.3, end: 0, duration: 500.ms, delay: 250.ms);
  }
}

// ── Aura painter: soft glow + 3 staggered expanding pulse rings ──────────────

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

// ── Rank card ─────────────────────────────────────────────────────────────────

class _RankCard extends StatelessWidget {
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

  const _RankCard({
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
                _PillBadge(
                  label: priceLabel,
                  color: badgeIsGreen ? AppColors.success : AppColors.accent,
                )
              else
                Text(
                  priceLabel,
                  style: GoogleFonts.rajdhani(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                  textAlign: TextAlign.end,
                ),
              if (premiumBadge) ...[
                const SizedBox(height: 4),
                const _PillBadge(
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

// ── Pill badge ────────────────────────────────────────────────────────────────

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PillBadge({required this.label, required this.color});

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
