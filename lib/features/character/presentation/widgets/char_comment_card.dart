import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/otadex_theme.dart';
import 'char_pill.dart';

class CharCommentCard extends StatelessWidget {
  final String initials;
  final String name;
  final String tier;
  final Color tierColor;
  final String time;
  final String body;
  final String likes;

  const CharCommentCard({
    super.key,
    required this.initials,
    required this.name,
    required this.tier,
    required this.tierColor,
    required this.time,
    required this.body,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.backgroundElevated),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6D1B), Color(0xFF8B5CF6)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                ),
                CharPill(tier, bg: tierColor, fontSize: 9),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    color: theme.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: theme.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '❤️ $likes',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: theme.textSecondary,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'Répondre',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: theme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '⋮',
                  style: TextStyle(fontSize: 18, color: theme.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
