import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Barre de progression : démarre à t=2000ms, dure 1500ms
  late final AnimationController _progressController;
  late final Animation<double> _progressAnimation;

  // Pulsation logo : commence à t=1200ms
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // Visibilité badges rang : apparaissent à t=1800ms
  bool _showRankBadges = false;

  // Shimmer tagline : une seule passe (géré par flutter_animate via delay)
  bool _showShimmer = true;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Séquence temporelle
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _pulseController.repeat(reverse: true);
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      // Le shimmer sur la tagline est déclenché via flutter_animate delay=1400ms
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        setState(() => _showShimmer = false);
      });
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _showRankBadges = true);
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      _progressController.forward();
    });

    Future.delayed(const Duration(milliseconds: 3500), _redirect);
  }

  Future<void> _redirect() async {
    if (!mounted) return;
    final route = await getInitialRoute();
    if (!mounted) return;
    context.go(route);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Stack(
        children: [
          // ── Layer 0 : splash_illustration.png en fond (FadeIn 0→0.3) ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash/splash_illustration.png',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.30),
            ).animate().fadeIn(duration: 1000.ms),
          ),

          // ── Layer 1 : Dégradé radial orange ──
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.55,
                  colors: [Color(0x18FF6500), Colors.transparent],
                ),
              ),
            ),
          ),

          // ── Layer 2 : Particules montantes ──
          ..._buildParticles(),

          // ── Layer 3 : Contenu central ──
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo avec pulsation + glow orange
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x50FF6500),
                          blurRadius: 50,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/logo/otadex_logo.png',
                      width: 220,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideY(
                      begin: 0.15,
                      end: 0,
                      duration: 800.ms,
                      delay: 300.ms,
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: AppSpacing.lg),

                // Tagline avec shimmer (une seule passe à t≈1400ms)
                _buildTagline(),
              ],
            ),
          ),

          // ── Layer 4 : Mini-badges rang en bas ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 64,
            child: AnimatedOpacity(
              opacity: _showRankBadges ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: _buildRankTeaserRow(),
            ).animate(
              delay: 1800.ms,
            ).slideY(begin: 0.15, end: 0, duration: 300.ms),
          ),

          // ── Layer 5 : Barre de progression gradient en bas ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildGradientProgressBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildTagline() {
    final taglineText = Text(
      AppConstants.appTagline,
      style: AppTypography.captionStyle().copyWith(
        fontSize: 13,
        letterSpacing: 1.2,
      ),
      textAlign: TextAlign.center,
    );

    return (_showShimmer
            ? Shimmer.fromColors(
                baseColor: AppColors.textSecondary,
                highlightColor: AppColors.textPrimary,
                period: const Duration(milliseconds: 800),
                child: taglineText,
              )
            : taglineText)
        .animate(delay: 900.ms)
        .fadeIn(duration: 400.ms);
  }

  Widget _buildRankTeaserRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RankTeaser(label: 'GENIN', color: AppColors.rankGenin),
        const _Dot(),
        _RankTeaser(label: 'JONIN', color: AppColors.rankJonin),
        const _Dot(),
        _RankTeaser(label: 'KAGE', color: AppColors.rankKage),
      ],
    );
  }

  Widget _buildGradientProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, _) {
        return SizedBox(
          height: 3,
          child: Stack(
            children: [
              // Fond sombre
              Container(color: Colors.transparent),
              // Barre de progression avec gradient orange
              FractionallySizedBox(
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.accent,
                        AppColors.accentBright,
                        AppColors.accent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildParticles() {
    final rng = Random(42);
    return List.generate(10, (i) {
      final x = rng.nextDouble();
      final size = 2.0 + rng.nextDouble() * 2;
      final duration = 3500 + rng.nextInt(2500);
      final delay = rng.nextInt(2000);

      return Positioned(
        left: MediaQuery.of(context).size.width * x,
        bottom: 40 + rng.nextDouble() * 220,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.40),
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .fadeIn(duration: 400.ms, delay: delay.ms)
            .moveY(
              begin: 0,
              end: -(100 + rng.nextDouble() * 80),
              duration: duration.ms,
              curve: Curves.easeOut,
            )
            .fadeOut(duration: 900.ms, delay: (duration - 900).ms),
      );
    });
  }
}

// ── Widgets privés ─────────────────────────────────────────────────────────

class _RankTeaser extends StatelessWidget {
  final String label;
  final Color color;

  const _RankTeaser({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: color.withValues(alpha: 0.6), width: 1),
        borderRadius: BorderRadius.circular(20),
        color: color.withValues(alpha: 0.08),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Rajdhani',
          fontWeight: FontWeight.w700,
          fontSize: 11,
          color: color,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '·',
        style: TextStyle(color: AppColors.textDisabled, fontSize: 12),
      ),
    );
  }
}
