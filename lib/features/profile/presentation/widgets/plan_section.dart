import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/subscription/rank_providers.dart';
import '../../../../core/theme/otadex_theme.dart';
import '../../../../core/theme/rank_theme.dart';
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
    final rank = ref.watch(effectiveRankProvider);
    final brightness = Theme.of(context).brightness;
    final geninColor =
        RankTheme.planColorOf(UserRank.genin, brightness: brightness);
    final joninColor =
        RankTheme.planColorOf(UserRank.jonin, brightness: brightness);
    final kageColor =
        RankTheme.planColorOf(UserRank.kage, brightness: brightness);
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
          // Genin
          PlanCard(
            name: 'Genin',
            tag: rank == UserRank.genin ? s.currentPlanTag : null,
            tagColor: geninColor,
            price: PlanPrices.free,
            priceColor: theme.textPrimary,
            features: [
              (true, s.sheetsNavigation),
              (true, s.likesComments),
              (false, s.adsShown),
              (false, s.aiDisabled),
            ],
            buttonLabel: s.planActualButton,
            buttonEnabled: false,
            borderColor: geninColor.withValues(alpha: 0.4),
            isCta: false,
          ),
          const SizedBox(height: 12),
          // Jonin
          PlanCard(
            name: 'Jonin',
            tag: rank == UserRank.jonin ? s.currentPlanTag : null,
            tagColor: joninColor,
            price: PlanPrices.jonin(annual: isAnnual),
            priceColor: joninColor,
            features: [
              (true, s.unlimitedCollection),
              (true, s.noAds),
              (true, s.aiChatbot),
              (true, s.joninBadge),
            ],
            buttonLabel: rank == UserRank.jonin
                ? s.planActualButton
                : s.upgradeToJoninButton,
            buttonEnabled: rank != UserRank.jonin,
            borderColor: joninColor,
            isCta: false,
            // CTA d'achat masqué hors Play Billing ; le badge "PLAN ACTUEL"
            // reste affiché pour le plan courant, sinon un bouton désactivé
            // "Bientôt disponible" (aucune zone tapable inerte).
            hideButton: !kEnablePaidPlans && rank != UserRank.jonin,
            unavailableLabel: s.comingSoon,
            onUpgrade: kEnablePaidPlans
                ? () => showSubscriptionModal(context, SubscriptionPlan.jonin)
                : null,
          ),
          const SizedBox(height: 12),
          // Kage
          PlanCard(
            name: '⭐ Kage Pass',
            tag: rank == UserRank.kage ? s.currentPlanTag : null,
            tagColor: kageColor,
            price: PlanPrices.kage(annual: isAnnual),
            priceColor: kageColor,
            features: [
              (true, s.joninIncluded),
              (true, s.aiImageGen),
              (true, s.noWatermark),
              (true, s.exclusiveThemes),
            ],
            buttonLabel: rank == UserRank.kage
                ? s.planActualButton
                : s.upgradeToKageButton,
            buttonEnabled: rank != UserRank.kage,
            borderColor: kageColor,
            isCta: true,
            hideButton: !kEnablePaidPlans && rank != UserRank.kage,
            unavailableLabel: s.comingSoon,
            onUpgrade: kEnablePaidPlans
                ? () => showSubscriptionModal(context, SubscriptionPlan.kage)
                : null,
          ),
        ],
      ),
    );
  }
}
