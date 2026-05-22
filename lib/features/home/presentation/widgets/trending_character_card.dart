import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/models/character.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/otadex_theme.dart';
import '../../../../../core/widgets/otadex_image.dart';

class TrendingCharacterCard extends StatefulWidget {
  final Character character;
  final int index;
  final VoidCallback? onTap;

  const TrendingCharacterCard({
    super.key,
    required this.character,
    required this.index,
    this.onTap,
  });

  @override
  State<TrendingCharacterCard> createState() => _TrendingCharacterCardState();
}

class _TrendingCharacterCardState extends State<TrendingCharacterCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) => setState(() => _scale = 0.94);
  void _onTapUp(TapUpDetails _) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  String _formatLikes(int likes) {
    if (likes >= 1000000) return '${(likes / 1000000).toStringAsFixed(1)}M';
    if (likes >= 1000) return '${(likes / 1000).toStringAsFixed(1)}k';
    return likes.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final character = widget.character;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: Container(
          width: 130,
          margin: EdgeInsets.only(
            left: widget.index == 0 ? 16 : 8,
            right: 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: theme.hasGlowEffect
                ? [
                    BoxShadow(
                      color: theme.accentGlow,
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Full-bleed image or fallback gradient
                if (character.images.isNotEmpty || (character.imagePath?.isNotEmpty == true))
                  OtadexImage(
                    imagePath: character.images.isNotEmpty
                        ? character.images.first
                        : character.imagePath!,
                    fit: BoxFit.cover,
                  )
                else
                  _buildFallbackBg(character),

                // Cinema-style scrim
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.4, 1.0],
                      colors: [
                        AppColors.cardShadowLight,
                        Colors.transparent,
                        AppColors.cardShadowBottom,
                      ],
                    ),
                  ),
                ),

                // Rank index indicator — top left
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '#${widget.index + 1}',
                        style: GoogleFonts.rajdhani(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                // Info panel — bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          character.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rajdhani(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          character.animeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.starYellow,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              character.rating.toStringAsFixed(1),
                              style: GoogleFonts.nunitoSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.starYellow,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.heartPink,
                              size: 10,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _formatLikes(character.likes),
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Shimmer (Kage only)
                if (theme.hasShimmerEffect)
                  Positioned.fill(
                    child: Shimmer.fromColors(
                      baseColor: Colors.transparent,
                      highlightColor: theme.accentShimmer,
                      period: const Duration(milliseconds: 2500),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withValues(alpha: 0.04),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackBg(Character character) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            character.cardColor,
            character.accentColor.withValues(alpha: 0.3),
          ],
        ),
      ),
    );
  }
}
