import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../l10n/app_strings.dart';
import '../services/url_launcher_service.dart';
import '../theme/app_colors.dart';
import '../theme/otadex_theme.dart';
import 'subscription_billing_card.dart';
import 'subscription_feature_item.dart';

enum SubscriptionPlan { jonin, kage }

void showSubscriptionModal(BuildContext context, SubscriptionPlan plan) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: false,
    builder: (_) => FractionallySizedBox(
      heightFactor: 0.93,
      child: _SubscriptionModal(plan: plan),
    ),
  );
}

// ── Internal data classes ─────────────────────────────────────────────────────

class _FeatureData {
  final String title;
  final String description;
  final IconData icon;

  const _FeatureData({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class _PlanData {
  final String emoji;
  final String name;
  final Color color;
  final String monthlyPrice;
  final String annualPrice;
  final List<_FeatureData> features;

  const _PlanData({
    required this.emoji,
    required this.name,
    required this.color,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.features,
  });
}

_PlanData _buildJoninPlan(AppStrings s) => _PlanData(
      emoji: '🦊',
      name: 'Jonin',
      color: AppColors.rankJonin,
      monthlyPrice: s.joninMonthlyPrice,
      annualPrice: s.joninAnnualPrice,
      features: [
        _FeatureData(
          title: s.joninFeature1Title,
          description: s.joninFeature1Desc,
          icon: Icons.collections_bookmark_rounded,
        ),
        _FeatureData(
          title: s.joninFeature2Title,
          description: s.joninFeature2Desc,
          icon: Icons.block_rounded,
        ),
        _FeatureData(
          title: s.joninFeature3Title,
          description: s.joninFeature3Desc,
          icon: Icons.smart_toy_outlined,
        ),
        _FeatureData(
          title: s.joninFeature4Title,
          description: s.joninFeature4Desc,
          icon: Icons.verified_outlined,
        ),
      ],
    );

_PlanData _buildKagePlan(AppStrings s) => _PlanData(
      emoji: '👑',
      name: 'Kage',
      color: AppColors.rankKage,
      monthlyPrice: s.kageMonthlyPrice,
      annualPrice: s.kageAnnualPrice,
      features: [
        _FeatureData(
          title: s.kageFeature1Title,
          description: s.kageFeature1Desc,
          icon: Icons.workspace_premium_rounded,
        ),
        _FeatureData(
          title: s.kageFeature2Title,
          description: s.kageFeature2Desc,
          icon: Icons.auto_awesome_outlined,
        ),
        _FeatureData(
          title: s.kageFeature3Title,
          description: s.kageFeature3Desc,
          icon: Icons.download_rounded,
        ),
        _FeatureData(
          title: s.kageFeature4Title,
          description: s.kageFeature4Desc,
          icon: Icons.palette_outlined,
        ),
      ],
    );

const _joninMonthlyUrl = 'https://store.tilstack.me/prd_1epnxl';
const _joninAnnualUrl = 'https://store.tilstack.me/prd_xqbqdx';
const _kageMonthlyUrl = 'https://store.tilstack.me/prd_hdj1oy';
const _kageAnnualUrl = 'https://store.tilstack.me/prd_0jx2mh';

String _licenseUrl(SubscriptionPlan plan, bool isAnnual) {
  if (plan == SubscriptionPlan.jonin) {
    return isAnnual ? _joninAnnualUrl : _joninMonthlyUrl;
  }
  return isAnnual ? _kageAnnualUrl : _kageMonthlyUrl;
}

// ── Modal ─────────────────────────────────────────────────────────────────────

class _SubscriptionModal extends StatefulWidget {
  final SubscriptionPlan plan;

  const _SubscriptionModal({required this.plan});

  @override
  State<_SubscriptionModal> createState() => _SubscriptionModalState();
}

class _SubscriptionModalState extends State<_SubscriptionModal> {
  bool _isAnnual = false;

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    final data = widget.plan == SubscriptionPlan.jonin
        ? _buildJoninPlan(s)
        : _buildKagePlan(s);

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: theme.borderSubtle)),
      ),
      child: Column(
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Scrollable body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: data.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: data.color.withValues(alpha: 0.35),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              data.emoji,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${s.subscriptionRankUpgradeTitle} ${data.name}',
                          style: GoogleFonts.rajdhani(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: theme.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${s.subscriptionRankUpgradeDesc} ${data.name}.',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            color: theme.textSecondary,
                            height: 1.55,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Billing cards ──
                  Row(
                    children: [
                      Expanded(
                        child: SubscriptionBillingCard(
                          label: s.subscriptionBillingMonthly,
                          price: data.monthlyPrice,
                          period: '/ ${s.monthly.toLowerCase()}',
                          badge: null,
                          isSelected: !_isAnnual,
                          color: data.color,
                          onTap: () => setState(() => _isAnnual = false),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SubscriptionBillingCard(
                          label: s.subscriptionBillingAnnual,
                          price: data.annualPrice,
                          period: '/ ${s.annual.toLowerCase()}',
                          badge: s.subscriptionSave10,
                          isSelected: _isAnnual,
                          color: data.color,
                          onTap: () => setState(() => _isAnnual = true),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Device note
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.devices_rounded,
                            size: 14, color: theme.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          s.subscriptionAllDevices,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            color: theme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── CTA button ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => UrlLauncherService.openUrl(
                        _licenseUrl(widget.plan, _isAnnual),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: data.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      icon: const Icon(Icons.workspace_premium, size: 18),
                      label: Text(
                        '${s.subscriptionObtainPass} ${data.name} ${_isAnnual ? s.subscriptionBillingAnnual.toLowerCase() : s.subscriptionBillingMonthly.toLowerCase()}',
                        style: GoogleFonts.rajdhani(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Already have a license
                  Center(
                    child: TextButton(
                      onPressed: () =>
                          GoRouter.of(context).push('/subscription'),
                      child: Text(
                        s.subscriptionAlreadyLicense,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: data.color,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  Divider(color: theme.borderSubtle),
                  const SizedBox(height: 16),

                  // ── Features section ──
                  Text(
                    '${s.subscriptionFeaturesTitle} ${data.name}',
                    style: GoogleFonts.rajdhani(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: theme.backgroundCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.borderSubtle),
                    ),
                    child: Column(
                      children: [
                        for (int i = 0; i < data.features.length; i++) ...[
                          if (i > 0)
                            Divider(height: 1, color: theme.borderSubtle),
                          SubscriptionFeatureItem(
                            title: data.features[i].title,
                            description: data.features[i].description,
                            icon: data.features[i].icon,
                            color: data.color,
                            isLast: i == data.features.length - 1,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
