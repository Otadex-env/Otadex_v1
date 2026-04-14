import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/otadex_button.dart';
import 'widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _skipToLast() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyHasSeenOnboarding, true);
    if (!mounted) return;
    context.go(AppRouter.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          if (_currentPage < 2)
            TextButton(
              onPressed: _skipToLast,
              child: Text(
                'Passer',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                // Slide 1
                const OnboardingPage(
                  imagePath: 'assets/images/onboarding/onboarding_1.png',
                  title: Text('Explore 10 000+\npersonnages'),
                  subtitle:
                      'Fiches complètes · Galeries images\nCitations exclusives',
                ),

                // Slide 2
                const OnboardingPage(
                  imagePath: 'assets/images/onboarding/onboarding_2.png',
                  title: Text('Construis ta\ncollection de fans'),
                  subtitle:
                      'Sauvegarde tes personnages préférés\net suis ta progression',
                ),

                // Slide 3
                OnboardingPage(
                  imagePath: 'assets/images/onboarding/onboarding_3.png',
                  title: const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Genin',
                          style: TextStyle(color: AppColors.rankGenin),
                        ),
                        TextSpan(text: ' · '),
                        TextSpan(
                          text: 'Jonin',
                          style: TextStyle(color: AppColors.rankJonin),
                        ),
                        TextSpan(text: ' · '),
                        TextSpan(
                          text: 'Kage',
                          style: TextStyle(color: AppColors.rankKage),
                        ),
                      ],
                    ),
                  ),
                  subtitle:
                      'Ton rang définit ton niveau de fan.\nMonte en grade, accède à l\'exclusivité.',
                  bottomWidget: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md),
                    child: OtadexButton(
                      label: 'Commencer l\'aventure →',
                      onPressed: _finish,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dots indicator
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xl),
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
        ],
      ),
    );
  }
}
