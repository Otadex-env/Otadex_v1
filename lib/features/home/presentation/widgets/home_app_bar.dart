import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/l10n/app_strings.dart';
import '../../../../../core/models/user_rank.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/otadex_theme.dart';
import '../../../../../core/widgets/rank_badge.dart';

class HomeAppBar extends StatelessWidget {
  final UserRank rank;
  final bool isLoggedIn;
  final String? pseudo;
  final VoidCallback? onLoginTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final int unreadCount;

  const HomeAppBar({
    super.key,
    required this.rank,
    this.isLoggedIn = false,
    this.pseudo,
    this.onLoginTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    return SizedBox(
      height: 64,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Rank aura glow behind logo
          Positioned(
            top: -20,
            left: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.accentColor.withValues(
                      alpha: theme.hasGlowEffect ? 0.12 : 0.05,
                    ),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Logo
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: theme.accentColor.withValues(
                              alpha: theme.hasGlowEffect ? 0.30 : 0.10,
                            ),
                            blurRadius: 12,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        AppAssets.logoIconTransparent,
                        width: 36,
                        height: 36,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'OTA',
                            style: GoogleFonts.rajdhani(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: theme.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'DEX',
                            style: GoogleFonts.rajdhani(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: theme.accentColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isLoggedIn) ...[
                  const SizedBox(width: 8),
                  RankBadge(rank: rank.toOtadexRank),
                ],
                const Spacer(),
                if (isLoggedIn) ...[
                  // Notification button
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      InkWell(
                        onTap: onNotificationTap,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: theme.backgroundCard,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: theme.borderSubtle),
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: theme.textSecondary,
                            size: 20,
                          ),
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: -3,
                          top: -3,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            constraints: const BoxConstraints(
                                minWidth: 16, minHeight: 16),
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$unreadCount',
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  // Profile shortcut
                  InkWell(
                    onTap: onProfileTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 108),
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: theme.accentColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.accentColor.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.person_outline_rounded,
                            color: theme.accentColor,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              _shortPseudo(pseudo),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: theme.accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else
                  // Guest CTA
                  TextButton(
                    onPressed: onLoginTap,
                    style: TextButton.styleFrom(
                      backgroundColor: AppColors.accent.withValues(alpha: 0.12),
                      foregroundColor: AppColors.accent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: AppColors.accent.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                    child: Text(
                      s.login,
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _shortPseudo(String? value) {
    final clean = value?.trim();
    if (clean == null || clean.isEmpty) return 'Profil';
    return clean.length <= 9 ? clean : '${clean.substring(0, 9)}...';
  }
}
