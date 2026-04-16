import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/otadex_button.dart';

class SlideThreeContent extends StatelessWidget {
  final VoidCallback? onFinish;

  const SlideThreeContent({super.key, this.onFinish});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl + AppSpacing.lg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.lg),

            // ── Titre ──
            Text(
              'Quel fan es-tu ?',
              style: GoogleFonts.rajdhani(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 150.ms)
                .slideY(begin: 0.15, end: 0, duration: 500.ms, delay: 150.ms),

            const SizedBox(height: AppSpacing.xs),

            // ── Sous-titre ──
            Text(
              'Choisis ta voie, grimpe les rangs',
              style: GoogleFonts.nunitoSans(
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms, delay: 280.ms),

            const SizedBox(height: AppSpacing.xl),

            // ── Cartes de rang ──
            const _RankCard(
              rank: 'GENIN',
              color: AppColors.rankGenin,
              bgColor: AppColors.rankGeninBg,
              icon: Icons.flash_on_outlined,
              priceLabel: 'GRATUIT',
              isPriceBadge: true,
              badgeIsGreen: true,
              description: 'Accès gratuit · Découverte',
              delay: 380,
            ),

            const SizedBox(height: AppSpacing.md),

            const _RankCard(
              rank: 'JONIN',
              color: AppColors.rankJonin,
              bgColor: AppColors.rankJoninBg,
              icon: Icons.auto_awesome_outlined,
              priceLabel: '2 000 FCFA/mois',
              isPriceBadge: false,
              description: 'Sans pub · Collections avancées',
              delay: 500,
            ),

            const SizedBox(height: AppSpacing.md),

            const _RankCard(
              rank: 'KAGE',
              color: AppColors.rankKage,
              bgColor: AppColors.rankKageBg,
              icon: Icons.workspace_premium_outlined,
              priceLabel: '5 000 FCFA/mois',
              isPriceBadge: false,
              premiumBadge: true,
              description: 'Accès IA · Exclusif · Statut ultime',
              delay: 620,
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Bouton CTA ──
            OtadexButton(
              label: 'Commencer l\'aventure →',
              onPressed: onFinish,
            )
                .animate()
                .fadeIn(duration: 500.ms, delay: 750.ms)
                .slideY(begin: 0.12, end: 0, duration: 500.ms, delay: 750.ms),

            const SizedBox(height: AppSpacing.md),

            // ── Footer ──
            Text(
              'Tu pourras changer de rang plus tard',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: AppColors.textDisabled,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(duration: 400.ms, delay: 870.ms),
          ],
        ),
      ),
    );
  }
}

// ── Carte de rang ─────────────────────────────────────────────────────────────

class _RankCard extends StatelessWidget {
  final String rank;
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String priceLabel;
  final bool isPriceBadge;
  final bool badgeIsGreen;
  final bool premiumBadge;
  final String description;
  final int delay;

  const _RankCard({
    required this.rank,
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.priceLabel,
    required this.description,
    required this.delay,
    this.isPriceBadge = false,
    this.badgeIsGreen = false,
    this.premiumBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(
          color: color.withValues(alpha: 0.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.10),
            blurRadius: 18,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icône dans un cercle
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
              border: Border.all(
                color: color.withValues(alpha: 0.30),
                width: 1.0,
              ),
            ),
            child: Icon(icon, color: color, size: 26),
          ),

          const SizedBox(width: AppSpacing.md),

          // Texte central
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rank,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                    color: color,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.sm),

          // Badge prix / GRATUIT / PREMIUM
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isPriceBadge)
                _PillBadge(
                  label: priceLabel,
                  color: badgeIsGreen ? AppColors.success : AppColors.accent,
                )
              else
                Text(
                  priceLabel,
                  style: GoogleFonts.rajdhani(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                  textAlign: TextAlign.end,
                ),
              if (premiumBadge) ...[
                const SizedBox(height: 4),
                const _PillBadge(
                  label: 'PREMIUM',
                  color: AppColors.accent,
                ),
              ],
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: delay))
        .slideX(
          begin: 0.06,
          end: 0,
          duration: 400.ms,
          delay: Duration(milliseconds: delay),
        );
  }
}

// ── Badge pill ────────────────────────────────────────────────────────────────

class _PillBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _PillBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.45), width: 1.0),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Rajdhani',
          fontWeight: FontWeight.w700,
          fontSize: 10,
          color: color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
