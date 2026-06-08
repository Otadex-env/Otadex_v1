import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/character.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';
import '../../../../core/widgets/otadex_image.dart';

class CharDetailGalerieTab extends StatelessWidget {
  final Character character;
  final List<String> images;
  final String rank;

  const CharDetailGalerieTab({
    super.key,
    required this.character,
    required this.images,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final isTablet = MediaQuery.sizeOf(context).width >= 600;
    final isGenin = rank == 'genin';
    final crossAxis = isTablet ? 4 : 3;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GALERIE — ${images.length} PHOTOS',
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: theme.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
          if (isGenin) ...[
            const SizedBox(height: 6),
            Text(
              'Images avec filigrane OTADEX · Kage Pass pour télécharger sans',
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 0.9,
            ),
            itemCount: images.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => context.push(
                '/gallery/${character.id}',
                extra: {'images': images, 'initialIndex': i},
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: OtadexImage(imagePath: images[i], fit: BoxFit.cover),
              ),
            ),
          ),
          if (isGenin) ...[
            const SizedBox(height: 16),
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Publicité · Passe Jonin pour supprimer',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
