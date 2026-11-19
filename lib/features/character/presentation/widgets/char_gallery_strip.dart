import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/character.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/otadex_image.dart';
import 'char_section_header.dart';

/// Aperçu de la galerie dans l'onglet Infos : bande d'images à faire défiler,
/// pour que la fiche montre le personnage avant de le décrire.
/// Masquée s'il y a moins de 2 images (la photo principale suffit alors).
class CharGalleryStrip extends StatelessWidget {
  final Character character;
  final List<String> images;

  /// Nombre maximum de vignettes ; « Tout voir » ouvre la galerie complète.
  static const _maxThumbs = 8;

  const CharGalleryStrip({
    super.key,
    required this.character,
    required this.images,
  });

  void _open(BuildContext context, int index) => context.push(
        '/gallery/${character.id}',
        extra: {'images': images, 'initialIndex': index},
      );

  @override
  Widget build(BuildContext context) {
    if (images.length < 2) return const SizedBox.shrink();
    final shown = images.take(_maxThumbs).toList();

    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CharSectionHeader(
              icon: Icons.photo_library_rounded,
              title: 'Galerie',
              accent: character.accentColor,
              count: images.length,
              trailing: GestureDetector(
                onTap: () => _open(context, 0),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    'Tout voir →',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: shown.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => _open(context, i),
                child: AspectRatio(
                  aspectRatio: 0.75,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: OtadexImage(imagePath: shown[i], fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
