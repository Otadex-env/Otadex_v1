import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/otadex_theme.dart';

class CharSectionHeader extends StatelessWidget {
  final String title;
  final String? action;

  const CharSectionHeader({super.key, required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.rajdhani(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          if (action != null)
            Text(
              action!,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: theme.accentColor,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
