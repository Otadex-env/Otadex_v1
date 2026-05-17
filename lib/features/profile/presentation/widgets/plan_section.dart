import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/providers/currency_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/subscription_modal.dart';
import 'billing_toggle.dart';
import 'plan_card.dart';

class PlanSection extends ConsumerWidget {
  final String billingCycle;
  final ValueChanged<String> onBillingChanged;

  const PlanSection({
    super.key,
    required this.billingCycle,
    required this.onBillingChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    final isAnnual = billingCycle == 'annuel';
    final currency = ref.watch(currencyProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s.changePlan,
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          BillingToggle(cycle: billingCycle, onChanged: onBillingChanged),
          const SizedBox(height: 16),
          // Genin — current plan
          PlanCard(
            name: 'Genin',
            tag: s.currentPlanTag,
            tagColor: AppColors.success,
            price: PlanPrices.free(currency),
            priceColor: theme.textPrimary,
            features: [
              (true, s.sheetsNavigation),
              (true, s.likesComments),
              (false, s.adsShown),
              (false, s.aiDisabled),
            ],
            buttonLabel: s.planActualButton,
            buttonEnabled: false,
            borderColor: AppColors.success.withValues(alpha: 0.4),
            isCta: false,
          ),
          const SizedBox(height: 12),
          // Jonin — upgrade
          PlanCard(
            name: 'Jonin',
            tag: null,
            tagColor: AppColors.rankJonin,
            price: PlanPrices.jonin(isAnnual, currency),
            priceColor: AppColors.rankJonin,
            features: [
              (true, s.unlimitedCollection),
              (true, s.noAds),
              (true, s.aiChatbot),
              (true, s.joninBadge),
            ],
            buttonLabel: s.upgradeToJoninButton,
            buttonEnabled: true,
            borderColor: AppColors.rankJonin,
            isCta: false,
            onUpgrade: () =>
                showSubscriptionModal(context, SubscriptionPlan.jonin),
          ),
          const SizedBox(height: 12),
          // Kage — top tier CTA
          PlanCard(
            name: '⭐ Kage Pass',
            tag: null,
            tagColor: AppColors.rankJonin,
            price: PlanPrices.kage(isAnnual, currency),
            priceColor: AppColors.rankJonin,
            features: [
              (true, s.joninIncluded),
              (true, s.aiImageGen),
              (true, s.noWatermark),
              (true, s.exclusiveThemes),
            ],
            buttonLabel: s.upgradeToKageButton,
            buttonEnabled: true,
            borderColor: AppColors.rankJonin,
            isCta: true,
            onUpgrade: () =>
                showSubscriptionModal(context, SubscriptionPlan.kage),
          ),
        ],
      ),
    );
  }
}
