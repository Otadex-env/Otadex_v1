import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/user_rank.dart';
import '../../../../core/theme/otadex_theme.dart';

class ProfileHero extends StatelessWidget {
  final String username;
  final String bio;

  static const _avatarGradient = [Color(0xFFD4621A), Color(0xFF5A1A00)];

  const ProfileHero({
    super.key,
    required this.username,
    required this.bio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final rank = OtadexTheme.rankOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.settings_rounded, color: theme.textSecondary, size: 22),
          ),
          const SizedBox(height: 12),
          Container(
            width: 80,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: _avatarGradient,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.accentGlow,
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: theme.rankBadgeBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: theme.rankBadgeColor.withValues(alpha: 0.5)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_rankEmoji(rank), style: const TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text(
                  theme.rankLabel.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: theme.rankBadgeColor,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            username,
            style: GoogleFonts.rajdhani(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            bio,
            style: GoogleFonts.nunitoSans(fontSize: 13, color: theme.textSecondary),
          ),
        ],
      ),
    );
  }

  String _rankEmoji(UserRank rank) => switch (rank) {
        UserRank.genin => '🎯',
        UserRank.jonin => '🦊',
        UserRank.kage => '👑',
      };
}
