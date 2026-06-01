import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/price_formatter.dart';
import '../../profile/presentation/widgets/billing_toggle.dart';
import '../../profile/presentation/widgets/plan_card.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  bool _isAnnual = false;

  static const _joninMonthlyUrl = 'https://store.tilstack.me/prd_1epnxl/checkout';
  static const _joninAnnualUrl = 'https://store.tilstack.me/prd_xqbqdx/checkout';
  static const _kageMonthlyUrl = 'https://store.tilstack.me/prd_hdj1oy/checkout';
  static const _kageAnnualUrl = 'https://store.tilstack.me/prd_0jx2mh/checkout';

  String _planUrl(String plan) {
    if (plan == 'jonin') {
      return _isAnnual ? _joninAnnualUrl : _joninMonthlyUrl;
    }
    return _isAnnual ? _kageAnnualUrl : _kageMonthlyUrl;
  }

  Future<void> _buyPlan(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Après ton achat, reviens ici pour activer ta licence 🔑",
          style: GoogleFonts.nunitoSans(fontSize: 13, color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.backgroundCard,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Activer',
          textColor: AppColors.rankJonin,
          onPressed: () => context.push('/activate-license'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'Plans OTADEX',
          style: GoogleFonts.rajdhani(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Débloque OTADEX Premium',
                style: GoogleFonts.rajdhani(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choisis ton plan, achète ta licence sur le store, puis active-la dans l\'app pour débloquer toutes les fonctionnalités.',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 24),
              BillingToggle(
                cycle: _isAnnual ? 'annuel' : 'mensuel',
                onChanged: (cycle) {
                  setState(() => _isAnnual = cycle == 'annuel');
                },
              ),
              const SizedBox(height: 18),
              PlanCard(
                name: 'Jonin',
                tag: 'POPULAIRE',
                tagColor: AppColors.statBlue,
                price: PlanPrices.jonin(_isAnnual, currency),
                priceColor: AppColors.statBlue,
                features: const [
                  (true, 'Collection illimitée'),
                  (true, 'Sans publicités'),
                  (true, 'IA chatbot'),
                  (true, 'Badge Jonin 🥷'),
                ],
                buttonLabel: _isAnnual
                    ? 'Acheter Jonin Annuel'
                    : 'Acheter Jonin Mensuel',
                buttonEnabled: true,
                borderColor: AppColors.statBlue,
                isCta: true,
                onUpgrade: () => _buyPlan(_planUrl('jonin')),
              ),
              const SizedBox(height: 12),
              PlanCard(
                name: 'Kage',
                tag: null,
                tagColor: AppColors.statPurple,
                price: PlanPrices.kage(_isAnnual, currency),
                priceColor: AppColors.statPurple,
                features: const [
                  (true, 'Tout Jonin inclus'),
                  (true, 'Génération images IA'),
                  (true, 'Sans watermark'),
                  (true, 'Thèmes exclusifs'),
                ],
                buttonLabel:
                    _isAnnual ? 'Acheter Kage Annuel' : 'Acheter Kage Mensuel',
                buttonEnabled: true,
                borderColor: AppColors.statPurple,
                isCta: true,
                onUpgrade: () => _buyPlan(_planUrl('kage')),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu as déjà une licence ?',
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Active ta clé Chariow pour débloquer les fonctionnalités premium immédiatement.',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => context.push('/activate-license'),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.rankJonin),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Activer ma licence',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.rankJonin,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Utilise les clés de licence Chariow. Aucune API de paiement intégrée dans l\'application.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    color: AppColors.textDisabled,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
