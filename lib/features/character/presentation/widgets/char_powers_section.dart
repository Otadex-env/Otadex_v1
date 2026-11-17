import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

/// Section « Pouvoirs & Capacités » d'une fiche personnage.
///
/// - le 1er pouvoir est mis en avant en grande carte « Signature » ;
/// - les autres sont en grille de 2 colonnes, avec une icône chacun ;
/// - au-delà de [_collapsedCount] pouvoirs, le reste est replié (« Voir tout ») ;
/// - la couleur d'accent est celle du personnage, comme le reste de la fiche.
class CharPowersSection extends StatefulWidget {
  final List<String> powers;
  final Color accent;

  const CharPowersSection({
    super.key,
    required this.powers,
    required this.accent,
  });

  @override
  State<CharPowersSection> createState() => _CharPowersSectionState();
}

class _CharPowersSectionState extends State<CharPowersSection> {
  /// Nombre de pouvoirs « secondaires » visibles avant « Voir tout ».
  static const _collapsedCount = 5;

  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final powers = widget.powers;
    if (powers.isEmpty) return const SizedBox.shrink();

    final signature = powers.first;
    final others = powers.skip(1).toList();
    final visible =
        _expanded ? others : others.take(_collapsedCount).toList();
    final hiddenCount = others.length - visible.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(count: powers.length, accent: widget.accent),
          const SizedBox(height: 12),
          _SignatureCard(name: signature, accent: widget.accent)
              .animate()
              .fadeIn(duration: 350.ms)
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
          if (visible.isNotEmpty) const SizedBox(height: 10),
          _PowerGrid(powers: visible, accent: widget.accent),
          if (hiddenCount > 0 || _expanded && others.length > _collapsedCount)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () => setState(() => _expanded = !_expanded),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    _expanded ? 'Réduire ↑' : 'Voir tout ($hiddenCount de plus) ↓',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accent,
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

class _Header extends StatelessWidget {
  final int count;
  final Color accent;
  const _Header({required this.count, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Pouvoirs & Capacités',
          style: GoogleFonts.nunitoSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
    );
  }
}

/// Grande carte du pouvoir principal.
class _SignatureCard extends StatelessWidget {
  final String name;
  final Color accent;
  const _SignatureCard({required this.name, required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.38),
            accent.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: 0.18),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: accent.withValues(alpha: 0.28),
            ),
            child: Icon(_iconFor(name, 0), color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIGNATURE',
                  style: GoogleFonts.rajdhani(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Longueur au-delà de laquelle un pouvoir est traité comme une description.
const _longPowerLength = 28;

/// Grille de 2 colonnes faite de lignes (pas de GridView : hauteur libre,
/// donc robuste aux grandes polices système).
class _PowerGrid extends StatelessWidget {
  final List<String> powers;
  final Color accent;
  const _PowerGrid({required this.powers, required this.accent});

  @override
  Widget build(BuildContext context) {
    // Noms courts (« Crevasse ») : 2 colonnes. Descriptions longues : une
    // colonne, sinon le texte est tronqué dans des cartes trop étroites.
    if (powers.any((p) => p.length > _longPowerLength)) {
      return Column(
        children: [
          for (var i = 0; i < powers.length; i++)
            Padding(
              padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
              child: _PowerTile(
                  name: powers[i], index: i + 1, accent: accent),
            ),
        ],
      );
    }
    final rows = <Widget>[];
    for (var i = 0; i < powers.length; i += 2) {
      final left = powers[i];
      final right = i + 1 < powers.length ? powers[i + 1] : null;
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _PowerTile(name: left, index: i + 1, accent: accent)),
              const SizedBox(width: 8),
              Expanded(
                child: right == null
                    ? const SizedBox.shrink()
                    : _PowerTile(name: right, index: i + 2, accent: accent),
              ),
            ],
          ),
        ),
      );
      if (i + 2 < powers.length) rows.add(const SizedBox(height: 8));
    }
    return Column(children: rows);
  }
}

class _PowerTile extends StatelessWidget {
  final String name;
  final int index;
  final Color accent;
  const _PowerTile({
    required this.name,
    required this.index,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(_iconFor(name, index), color: accent, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (80 * index).ms, duration: 300.ms)
        .slideY(
          begin: 0.2,
          end: 0,
          delay: (80 * index).ms,
          curve: Curves.easeOutCubic,
        );
  }
}

/// Icône d'un pouvoir : d'après un mot-clé du nom, sinon une icône de la
/// série [_fallbackIcons] choisie selon la position (stable d'un affichage à
/// l'autre).
IconData _iconFor(String name, int index) {
  final n = name.toLowerCase();
  for (final (keywords, icon) in _keywordIcons) {
    if (keywords.any(n.contains)) return icon;
  }
  return _fallbackIcons[index % _fallbackIcons.length];
}

const _keywordIcons = <(List<String>, IconData)>[
  (['domain', 'barrier', 'shield', 'défense', 'defense', 'bouclier'],
      Icons.shield_rounded),
  (['fire', 'flame', 'feu', 'flamme', 'burn'], Icons.local_fire_department_rounded),
  (['ice', 'frost', 'glace', 'froid'], Icons.ac_unit_rounded),
  (['lightning', 'thunder', 'foudre', 'électri', 'electri'], Icons.bolt_rounded),
  (['heal', 'regen', 'soin', 'guéri'], Icons.healing_rounded),
  (['sword', 'blade', 'slash', 'cut', 'cleave', 'épée', 'lame', 'katana'],
      Icons.content_cut_rounded),
  (['speed', 'vitesse', 'flash', 'rapid'], Icons.speed_rounded),
  (['mind', 'telepath', 'esprit', 'illusion', 'genjutsu'], Icons.psychology_rounded),
  (['strength', 'force', 'punch', 'poing'], Icons.fitness_center_rounded),
  (['shadow', 'ombre', 'dark', 'ténèbres'], Icons.nights_stay_rounded),
];

const _fallbackIcons = <IconData>[
  Icons.auto_awesome_rounded,
  Icons.flash_on_rounded,
  Icons.star_rounded,
  Icons.whatshot_rounded,
  Icons.diamond_rounded,
  Icons.explore_rounded,
];
