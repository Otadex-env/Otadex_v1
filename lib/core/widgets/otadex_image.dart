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

  bool get _isNetwork =>
      imagePath.startsWith('http://') || imagePath.startsWith('https://');

  @override
  Widget build(BuildContext context) {
    Widget image;

    if (_isNetwork) {
      image = CachedNetworkImage(
        imageUrl: imagePath,
        httpHeaders: const {'User-Agent': 'OTADEX/1.0'},
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => _shimmer(),
        errorWidget: (_, __, ___) => _errorWidget(),
      );
    } else {
      image = Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) => _errorWidget(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
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

  Widget _errorWidget() => Container(
        width: width,
        height: height,
        color: AppColors.backgroundElevated,
        child: const Icon(
          Icons.broken_image_rounded,
          color: AppColors.textDisabled,
          size: 32,
        ),
      );
}
