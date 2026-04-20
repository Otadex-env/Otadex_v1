import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';

class PlanSection extends StatelessWidget {
  final String billingCycle;
  final ValueChanged<String> onBillingChanged;

  const PlanSection({
    super.key,
    required this.billingCycle,
    required this.onBillingChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Changer de plan',
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _BillingToggle(cycle: billingCycle, onChanged: onBillingChanged),
          const SizedBox(height: 16),
          _PlanCard(
            name: 'Genin',
            tag: 'GRATUIT',
            tagColor: theme.textSecondary,
            price: '0 FCFA',
            priceColor: theme.textPrimary,
            features: const [
              (true, 'Fiches & navigation'),
              (true, 'Likes & commentaires'),
              (false, 'Publicités affichées'),
              (false, 'IA désactivée'),
            ],
            buttonLabel: 'Rétrograder',
            buttonEnabled: false,
            borderColor: theme.borderSubtle,
            isCta: false,
          ),
          const SizedBox(height: 12),
          const _PlanCard(
            name: 'Jonin',
            tag: 'PLAN ACTUEL ✓',
            tagColor: AppColors.rankJonin,
            price: '2 000 FCFA/mois',
            priceColor: AppColors.rankJonin,
            features: [
              (true, 'Collection illimitée'),
              (true, 'Sans publicités'),
              (true, 'IA chatbot + quiz'),
              (true, 'Badge Jonin 🦊'),
            ],
            buttonLabel: 'Plan actuel',
            buttonEnabled: false,
            borderColor: AppColors.rankJonin,
            isCta: false,
          ),
          const SizedBox(height: 12),
          const _PlanCard(
            name: '⭐ Kage Pass',
            tag: null,
            tagColor: AppColors.rankJonin,
            price: '5 000 FCFA/mois',
            priceColor: AppColors.rankJonin,
            features: [
              (true, 'Tout Jonin inclus'),
              (true, 'Génération images IA ⭐'),
              (true, 'Sans watermark'),
              (true, 'Thèmes exclusifs 👑'),
            ],
            buttonLabel: 'Passer Kage 👑',
            buttonEnabled: true,
            borderColor: AppColors.rankJonin,
            isCta: true,
          ),
        ],
      ),
    );
  }
}

class _BillingToggle extends StatelessWidget {
  final String cycle;
  final ValueChanged<String> onChanged;

  const _BillingToggle({required this.cycle, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleOption(
            label: 'Mensuel',
            value: 'mensuel',
            current: cycle,
            badge: null,
            onTap: onChanged,
          ),
          _ToggleOption(
            label: 'Annuel',
            value: 'annuel',
            current: cycle,
            badge: '-10%',
            onTap: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final String value;
  final String current;
  final String? badge;
  final ValueChanged<String> onTap;

  const _ToggleOption({
    required this.label,
    required this.value,
    required this.current,
    required this.badge,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final active = current == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? AppColors.backgroundDeep : theme.textSecondary,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.success,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final String? tag;
  final Color tagColor;
  final String price;
  final Color priceColor;
  final List<(bool, String)> features;
  final String buttonLabel;
  final bool buttonEnabled;
  final Color borderColor;
  final bool isCta;

  const _PlanCard({
    required this.name,
    required this.tag,
    required this.tagColor,
    required this.price,
    required this.priceColor,
    required this.features,
    required this.buttonLabel,
    required this.buttonEnabled,
    required this.borderColor,
    required this.isCta,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: GoogleFonts.rajdhani(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: theme.textPrimary,
                ),
              ),
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: tagColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag!,
                    style: GoogleFonts.rajdhani(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: tagColor,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: priceColor,
            ),
          ),
          const SizedBox(height: 10),
          ...features.map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Text(
                    f.$1 ? '✓' : '✗',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: f.$1 ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    f.$2,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: f.$1 ? theme.textPrimary : theme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: isCta
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.rankJonin,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      buttonLabel,
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  )
                : OutlinedButton(
                    onPressed: buttonEnabled ? () {} : null,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: buttonEnabled ? theme.borderDefault : theme.borderSubtle,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      buttonLabel,
                      style: GoogleFonts.rajdhani(
                        fontSize: 14,
                        fontWeight: buttonEnabled ? FontWeight.w700 : FontWeight.w500,
                        color: buttonEnabled ? theme.textPrimary : theme.textSecondary,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
