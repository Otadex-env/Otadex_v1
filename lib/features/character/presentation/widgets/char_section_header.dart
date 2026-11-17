import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// En-tête commun des sections d'une fiche personnage : pastille d'icône à la
/// couleur du personnage + titre (+ compteur et action optionnels).
///
/// Remplace les titres à emoji, pour une fiche cohérente d'une section à l'autre.
class CharSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color accent;
  final int? count;

  /// Action à droite (ex. « Tout voir »), à sa largeur naturelle.
  final Widget? trailing;

  const CharSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.accent,
    this.count,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Groupe « pastille + titre + compteur » : il prend toute la place
        // libre, le titre est tronqué (…) avant de pousser l'action dehors.
        Expanded(
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 17, color: accent),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (count != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          trailing!,
        ],
      ],
    );
  }
}
