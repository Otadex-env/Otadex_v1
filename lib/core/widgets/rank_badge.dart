import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/user_rank.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class RankBadge extends StatelessWidget {
  final UserRank rank;
  final bool showLabel;

  const RankBadge({super.key, required this.rank, this.showLabel = true});

  Color get _color {
    switch (rank) {
      case UserRank.genin:
        return AppColors.rankGenin;
      case UserRank.jonin:
        return AppColors.rankJonin;
      case UserRank.kage:
        return AppColors.rankKage;
    }
  }

  Color get _bgColor {
    switch (rank) {
      case UserRank.genin:
        return AppColors.rankGeninBg;
      case UserRank.jonin:
        return AppColors.rankJoninBg;
      case UserRank.kage:
        return AppColors.rankKageBg;
    }
  }

  IconData get _icon {
    switch (rank) {
      case UserRank.genin:
        return Icons.navigation;
      case UserRank.jonin:
        return Icons.star_outline;
      case UserRank.kage:
        return Icons.workspace_premium;
    }
  }

  String get _label {
    switch (rank) {
      case UserRank.genin:
        return 'Genin';
      case UserRank.jonin:
        return 'Jonin';
      case UserRank.kage:
        return 'Kage';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: _color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: rank == UserRank.genin ? 0.785 : 0,
            child: Icon(_icon, color: _color, size: 14),
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              _label,
              style: GoogleFonts.rajdhani(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
