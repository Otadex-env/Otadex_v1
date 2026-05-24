import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/models/featured_slide.dart';
import '../../../../../core/providers/anilist_providers.dart';
import '../../../../../core/theme/otadex_theme.dart';
import '../../../../../core/widgets/skeleton_loader.dart';

class HeroFeaturedSlider extends ConsumerStatefulWidget {
  const HeroFeaturedSlider({super.key});

  @override
  ConsumerState<HeroFeaturedSlider> createState() =>
      _HeroFeaturedSliderState();
}

class _HeroFeaturedSliderState extends ConsumerState<HeroFeaturedSlider> {
  late final PageController _pageCtrl;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
  }

  void _startAutoScroll(int count) {
    _timer?.cancel();
    if (count <= 1) return;
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % count;
      _pageCtrl.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final slidesAsync = ref.watch(featuredSlidesProvider);

    return slidesAsync.when(
      data: (slides) {
        if (slides.isEmpty) return const SizedBox.shrink();
        _startAutoScroll(slides.length);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: SizedBox(
            height: 200,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageCtrl,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => _SlideCard(slide: slides[i]),
                ),
                Positioned(
                  right: 12,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(slides.length, (i) {
                        final isActive = i == _currentPage;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 3),
                          width: 4,
                          height: isActive ? 20 : 6,
                          decoration: BoxDecoration(
                            color: isActive
                                ? theme.accentColor
                                : theme.textSecondary.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SkeletonBanner(height: 200),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _SlideCard extends StatelessWidget {
  final FeaturedSlide slide;

  const _SlideCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            slide.primaryColor,
            slide.secondaryColor.withValues(alpha: 0.6),
          ],
        ),
        boxShadow: theme.hasGlowEffect
            ? [
                BoxShadow(
                  color: slide.secondaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: slide.secondaryColor.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: slide.secondaryColor.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tag badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: slide.secondaryColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: slide.secondaryColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Text(
                    slide.tag,
                    style: GoogleFonts.rajdhani(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: slide.secondaryColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                // Title + subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      slide.title,
                      style: GoogleFonts.rajdhani(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      slide.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.7),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          slide.category,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            color: slide.secondaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: slide.secondaryColor,
                          size: 14,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
