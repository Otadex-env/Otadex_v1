import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import 'widgets/slide_one_content.dart';
import 'widgets/slide_three_content.dart';
import 'widgets/slide_two_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  late final AnimationController _particleController;
  int _currentPage = 0;
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    _pageController.addListener(() {
      if (mounted) {
        setState(() => _pageOffset = _pageController.page ?? 0.0);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  void _skipToLast() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyHasSeenOnboarding, true);
    if (!mounted) return;
    context.go(AppRouter.login);
  }

  Widget _slideAt(int index) {
    switch (index) {
      case 0:
        return const SlideOneContent();
      case 1:
        return SlideTwoContent(onNext: _nextPage);
      case 2:
        return SlideThreeContent(onFinish: _finish);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Stack(
        children: [
          // ── Layer 0 : Fond particules animées ──
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) => CustomPaint(
                painter: _OnboardingParticlePainter(_particleController.value),
              ),
            ),
          ),

          // ── Layer 1 : PageView avec transition scale+opacity ──
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: 3,
            itemBuilder: (context, index) {
              final offset = (_pageOffset - index).clamp(-1.0, 1.0);
              final scale = 1.0 - (offset.abs() * 0.08);
              final opacity = (1.0 - offset.abs() * 0.5).clamp(0.0, 1.0);

              return Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: _slideAt(index),
                ),
              );
            },
          ),

          // ── Layer 2 : Bouton Skip ──
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: AnimatedOpacity(
                opacity: _currentPage < 2 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: IgnorePointer(
                  ignoring: _currentPage >= 2,
                  child: TextButton(
                    onPressed: _skipToLast,
                    child: Text(
                      'Passer',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Layer 3 : Page indicator uniquement ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                child: Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.accent,
                      dotColor: AppColors.borderDefault,
                      expansionFactor: 2.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Particle Background Painter ───────────────────────────────────────────────

class _OnboardingParticle {
  final double x;
  final double speed;
  final double size;
  final double phase;

  const _OnboardingParticle({
    required this.x,
    required this.speed,
    required this.size,
    required this.phase,
  });
}

class _OnboardingParticlePainter extends CustomPainter {
  final double progress;

  static final List<_OnboardingParticle> _particles = _build();

  static List<_OnboardingParticle> _build() {
    final rng = Random(77);
    return List.generate(
      12,
      (i) => _OnboardingParticle(
        x: rng.nextDouble(),
        speed: 0.15 + rng.nextDouble() * 0.35,
        size: 1.5 + rng.nextDouble() * 2.0,
        phase: rng.nextDouble(),
      ),
    );
  }

  const _OnboardingParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in _particles) {
      final dy = (p.phase + progress * p.speed) % 1.0;
      final alpha = dy < 0.12
          ? dy / 0.12
          : dy > 0.88
              ? (1.0 - dy) / 0.12
              : 1.0;
      paint.color = AppColors.accent.withValues(alpha: alpha * 0.28);
      canvas.drawCircle(
        Offset(size.width * p.x, size.height * (1.0 - dy)),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_OnboardingParticlePainter old) =>
      old.progress != progress;
}
