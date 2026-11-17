import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/character.dart';
import '../../../../core/theme/app_colors.dart';

/// « Fiche rapide » du personnage : tuiles à icône (3 par ligne) au lieu de
/// cases de texte. Les informations absentes ne sont pas affichées (plus de
/// cases « — » vides).
class CharIdentityGrid extends StatelessWidget {
  final Character character;
  const CharIdentityGrid({super.key, required this.character});

  static const _perRow = 3;

  /// « 17 ans (1re année) → … » devient « 17 ans » : la fiche rapide montre
  /// l'essentiel, le détail reste dans la biographie.
  static String _short(String v) =>
      v.split(RegExp(r'[(→]')).first.trim().isEmpty
          ? v.trim()
          : v.split(RegExp(r'[(→]')).first.trim();

  @override
  Widget build(BuildContext context) {
    final c = character;
    final cells = <(IconData, String, String?)>[
      (Icons.timelapse_rounded, 'Âge', c.age),
      (Icons.wc_rounded, 'Genre', c.gender),
      (Icons.military_tech_rounded, 'Statut', c.status ?? c.role),
      (Icons.public_rounded, 'Nationalité', c.nationality),
      (Icons.water_drop_rounded, 'Groupe sanguin', c.bloodType),
      (Icons.cake_rounded, 'Naissance', c.birthday ?? c.dateOfBirth),
      (Icons.height_rounded, 'Taille', c.height),
    ].where((e) {
      final v = e.$3?.trim();
      return v != null && v.isNotEmpty && v != '—' && v != '-';
    }).toList();

    if (cells.isEmpty) return const SizedBox.shrink();

    final rows = <Widget>[];
    for (var i = 0; i < cells.length; i += _perRow) {
      final slice = cells.skip(i).take(_perRow).toList();
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var j = 0; j < _perRow; j++) ...[
                if (j > 0) const SizedBox(width: 8),
                Expanded(
                  child: j < slice.length
                      ? _IdentityTile(
                          icon: slice[j].$1,
                          label: slice[j].$2,
                          value: _short(slice[j].$3!),
                          accent: c.accentColor,
                          index: i + j,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ),
      );
      if (i + _perRow < cells.length) rows.add(const SizedBox(height: 8));
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(children: rows),
    );
  }
}

class _IdentityTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final int index;

  const _IdentityTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.32),
                  accent.withValues(alpha: 0.10),
                ],
              ),
            ),
            child: Icon(icon, size: 19, color: accent),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
              fontSize: 10,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (60 * index).ms, duration: 300.ms)
        .scaleXY(
          begin: 0.92,
          end: 1,
          delay: (60 * index).ms,
          curve: Curves.easeOutBack,
        );
  }
}
