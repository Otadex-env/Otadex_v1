import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/models/character.dart';
import '../../../../../core/theme/otadex_theme.dart';

class CharacterGridCard extends StatefulWidget {
  final Character character;

  const CharacterGridCard({super.key, required this.character});

  @override
  State<CharacterGridCard> createState() => _CharacterGridCardState();
}

class _CharacterGridCardState extends State<CharacterGridCard> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails _) => setState(() => _scale = 0.93);
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
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 130),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 130),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _scale < 1.0
                    ? Colors.transparent
                    : theme.hasGlowEffect
                        ? theme.accentGlow
                        : Colors.black.withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 0,
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
                if (character.imagePath != null)
                  Image.asset(
                    character.imagePath!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _buildFallbackBg(character),
                  )
                else
                  _buildFallbackBg(character),

                // Cinema-style gradient scrim for readability
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.35, 1.0],
                      colors: [
                        Color(0x28000000),
                        Color(0x00000000),
                        Color(0xD8000000),
                      ],
                    ),
                  ),
                ),

                // NEW badge — top left
                if (character.isNew)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        'NEW',
                        style: GoogleFonts.rajdhani(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF22C55E),
                          letterSpacing: 0.5,
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
                    padding: const EdgeInsets.fromLTRB(8, 0, 8, 9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          character.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rajdhani(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          character.animeName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 9,
                            color: Colors.white.withValues(alpha: 0.55),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFC107),
                              size: 10,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              character.rating.toStringAsFixed(1),
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFC107),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.favorite_rounded,
                              color: Color(0xFFFF4D6D),
                              size: 9,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              _formatLikes(character.likes),
                              style: GoogleFonts.nunitoSans(
                                fontSize: 9,
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
            character.accentColor.withValues(alpha: 0.25),
          ],
        ),
      ),
      child: Center(
        child: Icon(Icons.person, color: character.accentColor, size: 32),
      ),
    );
  }
}
