import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

// ── Shimmer box générique ──────────────────────────────────────────────────────
Widget shimmerBox({
  double width = double.infinity,
  double height = 180,
  double radius = 12,
}) {
  return Shimmer.fromColors(
    baseColor: AppColors.backgroundCard,
    highlightColor: AppColors.borderSubtle,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}

// ── Shimmer grille 3×2 (HomeScreen, CharacterListScreen) ──────────────────────
class SkeletonGrid extends StatelessWidget {
  final int columns;
  final int rows;
  final double cardHeight;

  const SkeletonGrid({
    super.key,
    this.columns = 3,
    this.rows = 2,
    this.cardHeight = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.72,
        ),
        itemCount: columns * rows,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.backgroundCard,
          highlightColor: AppColors.borderSubtle,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shimmer rangée horizontale (TrendingSection) ───────────────────────────────
class SkeletonRow extends StatelessWidget {
  final double height;
  final double cardWidth;
  final int count;

  const SkeletonRow({
    super.key,
    this.height = 180,
    this.cardWidth = 120,
    this.count = 5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16, right: 16),
        itemCount: count,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: AppColors.backgroundCard,
          highlightColor: AppColors.borderSubtle,
          child: Container(
            width: cardWidth,
            decoration: BoxDecoration(
              color: AppColors.backgroundCard,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shimmer bannière héro (HeroFeaturedSlider) ─────────────────────────────────
class SkeletonBanner extends StatelessWidget {
  final double height;

  const SkeletonBanner({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: shimmerBox(height: height, radius: 18),
    );
  }
}

// ── Shimmer plein écran (chargement d'un écran entier) ─────────────────────────
class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          shimmerBox(height: 220, radius: 18),
          const SizedBox(height: 20),
          shimmerBox(height: 20, width: 180, radius: 6),
          const SizedBox(height: 12),
          shimmerBox(height: 14, radius: 6),
          const SizedBox(height: 8),
          shimmerBox(height: 14, radius: 6),
          const SizedBox(height: 8),
          shimmerBox(height: 14, width: 240, radius: 6),
          const SizedBox(height: 24),
          shimmerBox(height: 20, width: 140, radius: 6),
          const SizedBox(height: 12),
          shimmerBox(height: 80, radius: 12),
        ],
      ),
    );
  }
}

// ── Shimmer section liste (collection, plans…) ────────────────────────────────
class SkeletonList extends StatelessWidget {
  final int count;

  const SkeletonList({super.key, this.count = 4});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: shimmerBox(height: 72, radius: 12),
        ),
      ),
    );
  }
}
