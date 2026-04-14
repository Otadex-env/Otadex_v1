import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _progressAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_progressController);
    _progressController.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(AppConstants.splashDuration);
    if (!mounted) return;
    final route = await getInitialRoute();
    if (!mounted) return;
    context.go(route);
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Stack(
        children: [
          // Dégradé radial orange derrière le logo
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.55,
                  colors: [Color(0x20FF6500), Colors.transparent],
                ),
              ),
            ),
          ),

          // Particules flottantes (étincelles)
          ..._buildParticles(),

          // Contenu principal centré
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo avec ombre orange
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40FF6500),
                        blurRadius: 40,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/logo/otadex_logo.png',
                    width: 220,
                    fit: BoxFit.contain,
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(
                      begin: 0.15,
                      end: 0,
                      duration: 800.ms,
                      curve: Curves.easeOutCubic,
                    ),

                const SizedBox(height: 20),

                // Tagline
                Text(
                  AppConstants.appTagline,
                  style: AppTypography.captionStyle().copyWith(
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                )
                    .animate(delay: 500.ms)
                    .fadeIn(duration: 600.ms),
              ],
            ),
          ),

          // Barre de progression en bas
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, _) {
                return LinearProgressIndicator(
                  value: _progressAnimation.value,
                  minHeight: 3,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.accent,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildParticles() {
    final random = Random(42);
    return List.generate(8, (i) {
      final x = random.nextDouble();
      final size = 2.0 + random.nextDouble();
      final duration = 4000 + random.nextInt(2000);
      final delay = random.nextInt(3000);

      return Positioned(
        left: MediaQuery.of(context).size.width * x,
        bottom: 50 + random.nextDouble() * 200,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.35),
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (c) => c.repeat())
            .fadeIn(duration: 300.ms, delay: delay.ms)
            .moveY(
              begin: 0,
              end: -80,
              duration: duration.ms,
              curve: Curves.easeOut,
            )
            .fadeOut(duration: 800.ms, delay: (duration - 800).ms),
      );
    });
  }
}
