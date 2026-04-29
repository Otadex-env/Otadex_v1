import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/character.dart';

/// Displays a character image asset when available, falling back to a
/// gradient avatar showing the character's initials when the asset is
/// missing or fails to load.
///
/// Image convention: assets/images/characters/{character.id}/{character.id}_01.jpg
/// Register each new character directory in pubspec.yaml under flutter > assets.
class CharacterAvatar extends StatelessWidget {
  final Character character;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const CharacterAvatar({
    super.key,
    required this.character,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = _buildImage();
    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }
    return image;
  }

  Widget _buildImage() {
    final path = character.imagePath;
    if (path == null) return _placeholder();

    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            character.cardColor,
            character.accentColor.withValues(alpha: 0.6),
          ],
        ),
      ),
      child: Center(
        child: Text(
          character.initials,
          style: GoogleFonts.rajdhani(
            fontSize: (height ?? 48) * 0.38,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
