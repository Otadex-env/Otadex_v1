import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/otadex_theme.dart';

class ProfileStatRow extends StatelessWidget {
  final int collectCount;
  final int fanScore;
  final int rankCount;

  const ProfileStatRow({
    super.key,
    required this.collectCount,
    required this.fanScore,
    required this.rankCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Row(
        children: [
          _StatCell(value: '$collectCount', label: 'Collectés', highlight: false),
          _Divider(),
          _StatCell(value: '$fanScore', label: 'Fan Score', highlight: true),
          _Divider(),
          _StatCell(value: '$rankCount', label: 'Classements', highlight: false),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  final bool highlight;

  const _StatCell({
    required this.value,
    required this.label,
    required this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: highlight ? theme.accentColor : theme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunitoSans(fontSize: 11, color: theme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(width: 1, height: 32, color: theme.borderSubtle);
  }
}
