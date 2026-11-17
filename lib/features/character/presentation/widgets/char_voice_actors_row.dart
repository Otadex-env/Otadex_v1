import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/otadex_image.dart';

/// Un doubleur à afficher (source : données Otadex ou AniList).
class VoiceActorItem {
  final String name;
  final String language;
  final String imageUrl;

  /// Identifiant AniList : s'il est renseigné, un tap ouvre sa page.
  final String? id;

  const VoiceActorItem({
    required this.name,
    required this.language,
    required this.imageUrl,
    this.id,
  });
}

/// Doubleurs en rangée d'avatars ronds à faire défiler (au lieu d'une liste
/// de lignes de texte).
class CharVoiceActorsRow extends StatelessWidget {
  final List<VoiceActorItem> actors;
  final Color accent;
  final void Function(VoiceActorItem actor)? onTap;

  const CharVoiceActorsRow({
    super.key,
    required this.actors,
    required this.accent,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 142,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: actors.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) {
          final a = actors[i];
          return GestureDetector(
            onTap: onTap == null || a.id == null ? null : () => onTap!(a),
            child: SizedBox(
              width: 88,
              child: Column(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [accent, accent.withValues(alpha: 0.25)],
                      ),
                    ),
                    child: ClipOval(
                      child: a.imageUrl.isNotEmpty
                          ? OtadexImage(
                              imagePath: a.imageUrl,
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            )
                          : Container(
                              color: AppColors.backgroundCard,
                              child: Center(
                                child: Text(
                                  a.name.isNotEmpty
                                      ? a.name[0].toUpperCase()
                                      : '?',
                                  style: GoogleFonts.rajdhani(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    a.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.15,
                    ),
                  ),
                  if (a.language.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        a.language,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: accent,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
