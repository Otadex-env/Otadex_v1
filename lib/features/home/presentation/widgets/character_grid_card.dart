import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/models/character.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/user_profile_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/otadex_theme.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/auth_gate_modal.dart';
import '../../../../../core/widgets/otadex_image.dart';
import '../../../../../core/widgets/subscription_modal.dart';

class CharacterGridCard extends ConsumerStatefulWidget {
  final Character character;
  final VoidCallback? onTap;

  const CharacterGridCard({super.key, required this.character, this.onTap});

  @override
  ConsumerState<CharacterGridCard> createState() => _CharacterGridCardState();
}

class _CharacterGridCardState extends ConsumerState<CharacterGridCard> {
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
      onTap: widget.onTap,
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
                Builder(builder: (_) {
                  final img = AppAssets.getByCharacterId(character.id).isNotEmpty
                      ? AppAssets.getByCharacterId(character.id).first
                      : character.images.isNotEmpty
                          ? character.images.first
                          : character.imagePath ?? '';
                  return img.isNotEmpty
                      ? OtadexImage(imagePath: img, fit: BoxFit.cover)
                      : _buildFallbackBg(character);
                }),

                // Cinema-style gradient scrim for readability
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.35, 1.0],
                      colors: [
                        AppColors.cardShadowMid,
                        Colors.transparent,
                        AppColors.cardShadowDeep,
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
                        color: AppColors.success.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        'NEW',
                        style: GoogleFonts.rajdhani(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
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
                              color: AppColors.starYellow,
                              size: 10,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              character.rating.toStringAsFixed(1),
                              style: GoogleFonts.nunitoSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.starYellow,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.heartPink,
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
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      final isLoggedIn = ref.read(isLoggedInProvider);
                      if (!isLoggedIn) {
                        showAuthGateModal(context);
                        return;
                      }
                      final notifier = ref.read(userProfileProvider.notifier);
                      final isCollected = ref
                          .read(userProfileProvider)
                          .collectedCharacterIds
                          .contains(character.id);
                      try {
                        if (isCollected) {
                          notifier.removeFromCollection(character.id);
                        } else {
                          notifier.addToCollection(character.id);
                        }
                      } catch (_) {
                        showSubscriptionModal(context, SubscriptionPlan.jonin);
                      }
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: theme.backgroundPrimary.withValues(alpha: 0.75),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          ref
                                  .watch(userProfileProvider)
                                  .collectedCharacterIds
                                  .contains(character.id)
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: ref
                                  .watch(userProfileProvider)
                                  .collectedCharacterIds
                                  .contains(character.id)
                              ? AppColors.rankJonin
                              : theme.textSecondary,
                          size: 18,
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
