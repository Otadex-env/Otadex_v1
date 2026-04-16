import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

enum SelectedRank { genin, jonin, kage }

class RankSelector extends StatefulWidget {
  final SelectedRank initialRank;
  final ValueChanged<SelectedRank> onRankChanged;

  const RankSelector({
    super.key,
    this.initialRank = SelectedRank.genin,
    required this.onRankChanged,
  });

  @override
  State<RankSelector> createState() => _RankSelectorState();
}

class _RankSelectorState extends State<RankSelector> {
  late SelectedRank _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialRank;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RankCard(
          rank: SelectedRank.genin,
          selected: _selected == SelectedRank.genin,
          onTap: () {
            setState(() => _selected = SelectedRank.genin);
            widget.onRankChanged(SelectedRank.genin);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _RankCard(
          rank: SelectedRank.jonin,
          selected: _selected == SelectedRank.jonin,
          onTap: () {
            setState(() => _selected = SelectedRank.jonin);
            widget.onRankChanged(SelectedRank.jonin);
          },
        ),
        const SizedBox(height: AppSpacing.sm),
        _RankCard(
          rank: SelectedRank.kage,
          selected: _selected == SelectedRank.kage,
          onTap: () {
            setState(() => _selected = SelectedRank.kage);
            widget.onRankChanged(SelectedRank.kage);
          },
        ),
      ],
    );
  }
}

class _RankCard extends StatelessWidget {
  final SelectedRank rank;
  final bool selected;
  final VoidCallback onTap;

  const _RankCard({
    required this.rank,
    required this.selected,
    required this.onTap,
  });

  Color get _color {
    switch (rank) {
      case SelectedRank.genin:
        return AppColors.rankGenin;
      case SelectedRank.jonin:
        return AppColors.rankJonin;
      case SelectedRank.kage:
        return AppColors.rankKage;
    }
  }

  Color get _bgColor {
    switch (rank) {
      case SelectedRank.genin:
        return AppColors.rankGeninBg;
      case SelectedRank.jonin:
        return AppColors.rankJoninBg;
      case SelectedRank.kage:
        return AppColors.rankKageBg;
    }
  }

  IconData get _icon {
    switch (rank) {
      case SelectedRank.genin:
        return Icons.navigation;
      case SelectedRank.jonin:
        return Icons.star_outline;
      case SelectedRank.kage:
        return Icons.workspace_premium;
    }
  }

  String get _name {
    switch (rank) {
      case SelectedRank.genin:
        return 'Genin';
      case SelectedRank.jonin:
        return 'Jonin';
      case SelectedRank.kage:
        return 'Kage';
    }
  }

  String get _description {
    switch (rank) {
      case SelectedRank.genin:
        return 'Accès de base · Découverte';
      case SelectedRank.jonin:
        return 'Sans pub · Collections avancées';
      case SelectedRank.kage:
        return 'IA · Exclusivité · Statut ultime';
    }
  }

  Widget _buildPriceTag() {
    switch (rank) {
      case SelectedRank.genin:
        return _PriceTag(
          label: 'GRATUIT',
          color: AppColors.success,
          bg: AppColors.success.withValues(alpha: 0.15),
        );
      case SelectedRank.jonin:
        return _PriceTag(
          label: '2 000 FCFA/mois',
          color: AppColors.rankJonin,
          bg: AppColors.rankJonin.withValues(alpha: 0.15),
        );
      case SelectedRank.kage:
        return _PriceTag(
          label: '5 000 FCFA/mois',
          color: AppColors.rankKage,
          bg: AppColors.rankKage.withValues(alpha: 0.15),
        );
    }
  }

  Widget _buildCardContent() {
    return AnimatedScale(
      scale: selected ? 1.02 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: selected ? _color : AppColors.borderSubtle,
            width: selected ? 1.5 : 1.0,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: _color.withValues(alpha: 0.25),
                    blurRadius: 12,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Icône rang
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
                border: Border.all(color: _color.withValues(alpha: 0.4)),
              ),
              child: Center(
                child: Transform.rotate(
                  angle: rank == SelectedRank.genin ? 0.785 : 0,
                  child: Icon(_icon, color: _color, size: 20),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Texte
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _name,
                        style: GoogleFonts.rajdhani(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _color,
                        ),
                      ),
                      const Spacer(),
                      _buildPriceTag(),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _description,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? _color : Colors.transparent,
                border: Border.all(
                  color: selected ? _color : AppColors.borderDefault,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final card = GestureDetector(
      onTap: onTap,
      child: _buildCardContent(),
    );

    // KAGE : bordure dégradée orange → accentBright → orange (pas de shimmer qui masque le contenu)
    if (rank == SelectedRank.kage) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg + 2),
          gradient: LinearGradient(
            colors: [
              AppColors.rankKage,
              AppColors.accentBright,
              AppColors.rankKage.withValues(alpha: 0.55),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(1.5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          child: card,
        ),
      );
    }

    return card;
  }
}

class _PriceTag extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _PriceTag({
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        label,
        style: GoogleFonts.rajdhani(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
