import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class OtadexImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const OtadexImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  bool get _isAsset =>
      imagePath.startsWith('assets/');

  bool get _isNetwork =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) return _placeholder();

    if (_isAsset) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => _placeholder(),
        ),
      );
    }

    if (_isNetwork) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: Uri.encodeFull(imagePath),
          width: width,
          height: height,
          fit: fit,
          placeholder: (_, __) => _shimmer(),
          errorWidget: (_, __, ___) => _placeholder(),
        ),
      );
    }

    return _placeholder();
  }

  Widget _shimmer() => Shimmer.fromColors(
        baseColor: AppColors.backgroundCard,
        highlightColor: AppColors.backgroundElevated,
        child: Container(
          width: width,
          height: height,
          color: AppColors.backgroundCard,
        ),
      );

  Widget _placeholder() => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.backgroundElevated,
      borderRadius: borderRadius,
    ),
    child: Icon(
      Icons.person_rounded,
      color: AppColors.textSecondary.withValues(alpha: 0.4),
      size: 40,
    ),
  );
}
