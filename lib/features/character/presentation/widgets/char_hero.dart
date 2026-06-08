import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/character.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/otadex_image.dart';
import 'char_circle_button.dart';
import 'char_pill.dart';

class CharDetailHero extends StatefulWidget {
  final Character character;
  final bool isLiked;
  final List<String> images;
  final String formattedLikes;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onToggleLike;

  const CharDetailHero({
    super.key,
    required this.character,
    required this.isLiked,
    required this.images,
    required this.formattedLikes,
    required this.onBack,
    required this.onShare,
    required this.onToggleLike,
  });

  @override
  State<CharDetailHero> createState() => _CharDetailHeroState();
}

class _CharDetailHeroState extends State<CharDetailHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  Character get c => widget.character;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scale = Tween<double>(begin: 1.10, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic),
    );
    _fade = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  int get _collectionCount => (c.likes * 0.20).round();

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final heroH = (mq.size.height * 0.50).clamp(320.0, 520.0);

    return SizedBox(
      height: heroH,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient de fond propre au personnage
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(c.cardColor, Colors.black, 0.4) ?? c.cardColor,
                  Color.lerp(c.cardColor, c.accentColor, 0.5) ??
                      c.accentColor.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          // Halo radial
          Positioned(
            left: 0,
            right: 0,
            top: heroH * 0.1,
            child: Center(
              child: Container(
                width: heroH * 0.65,
                height: heroH * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      c.accentColor.withValues(alpha: 0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Image animée
          Positioned(
            left: 0,
            right: 0,
            top: mq.padding.top + 48,
            bottom: 90,
            child: _buildAnimatedImage(),
          ),
          // Fondu bas
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: heroH * 0.52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundDeep.withValues(alpha: 0.75),
                      AppColors.backgroundDeep,
                    ],
                    stops: const [0.0, 0.58, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  CharCircleButton(
                    onTap: widget.onBack,
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const Spacer(),
                  CharCircleButton(
                    onTap: widget.onShare,
                    child: const Icon(Icons.ios_share_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
          // Bloc identité bas
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  children: [
                    CharPill(
                      c.tier.name.toUpperCase(),
                      bg: c.accentColor.withValues(alpha: 0.22),
                      border: Border.all(color: c.accentColor),
                      color: Colors.white,
                    ),
                    CharPill(
                      c.category.toUpperCase(),
                      bg: Colors.white.withValues(alpha: 0.10),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35)),
                      color: Colors.white70,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  c.name.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    fontSize: _nameSize(mq),
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.8,
                    height: 1,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 12)
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  c.animeName,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 13, color: Colors.white60),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _actionChip(
                      icon: widget.isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      label: widget.formattedLikes,
                      isActive: widget.isLiked,
                      activeColor: AppColors.error,
                      onTap: widget.onToggleLike,
                    ),
                    const SizedBox(width: 8),
                    _actionChip(
                      icon: Icons.star_rounded,
                      label: c.rating.toStringAsFixed(1),
                    ),
                    const Spacer(),
                    Text(
                      '🎴 $_collectionCount collections',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 11, color: Colors.white54),
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

  Widget _buildAnimatedImage() {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => FadeTransition(
        opacity: _fade,
        child: Transform.scale(
          scale: _scale.value,
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      ),
      child: widget.images.isNotEmpty
          ? OtadexImage(
              imagePath: widget.images.first,
              fit: BoxFit.contain,
            )
          : _buildSilhouette(),
    );
  }

  Widget _buildSilhouette() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25), width: 2),
            ),
            child: Center(
              child: Text(
                c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                style: GoogleFonts.rajdhani(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    bool isActive = false,
    Color activeColor = Colors.white,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.20)
              : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isActive
                ? activeColor.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: isActive ? activeColor : Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _nameSize(MediaQueryData mq) {
    if (mq.size.width >= 600) return 38;
    if (mq.size.width >= 400) return 30;
    return 26;
  }
}
