import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/services/url_launcher_service.dart';
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
  final TextEditingController _licenseController = TextEditingController();
  String? _savedLicense;
  bool _isActivating = false;

  static const _storeRootUrl = 'https://store.tilstack.me/';
  static const _joninMonthlyUrl = 'https://store.tilstack.me/prd_1epnxl';
  static const _joninAnnualUrl = 'https://store.tilstack.me/prd_xqbqdx';
  static const _kageMonthlyUrl = 'https://store.tilstack.me/prd_hdj1oy';
  static const _kageAnnualUrl = 'https://store.tilstack.me/prd_0jx2mh';
  static const _licensePrefKey = 'chariow_license_key';

  @override
  void initState() {
    super.initState();
    _loadSavedLicense();
  }

  Future<void> _loadSavedLicense() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_licensePrefKey);
    if (stored != null && mounted) {
      setState(() {
        _savedLicense = stored;
        _licenseController.text = stored;
      });
    }
  }

  @override
  void dispose() {
    _licenseController.dispose();
    super.dispose();
  }

  String _planUrl(String plan) {
    if (plan == 'jonin') {
      return _isAnnual ? _joninAnnualUrl : _joninMonthlyUrl;
    }
    return _isAnnual ? _kageAnnualUrl : _kageMonthlyUrl;
  }

  Future<void> _openUrl(String url) => UrlLauncherService.openUrl(url);

  Future<void> _activateLicense() async {
    final license = _licenseController.text.trim();
    if (license.isEmpty) {
      _showMessage('Renseigne ta clé de licence Chariow.');
      return;
    }
    if (!_isValidLicense(license)) {
      _showMessage(
        'Clé de licence invalide. Vérifie ton code Chariow ou contacte le support.',
      );
      return;
    }

    setState(() => _isActivating = true);
    final plan = _planFromLicense(license);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_licensePrefKey, license);
    await prefs.setString(AppConstants.keyUserRank, plan);
    await prefs.setString(AppConstants.keySubscriptionPlan, plan);
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    ref.read(userProfileProvider.notifier).updateIdentity(rank: plan);
    setState(() {
      _savedLicense = license;
      _isActivating = false;
    });
    _showMessage(
      plan == AppConstants.rankKage
          ? 'Licence Kage activée. Tes fonctionnalités premium sont prêtes.'
          : 'Licence Jonin activée. Tes fonctionnalités premium sont prêtes.',
    );
  }

  bool _isValidLicense(String code) {
    const knownChariowLicenses = <String>{
      // Ajoute ici tes clés de licence Chariow valides pour une validation locale.
      // 'EXEMPLE-JONIN-MENSUEL-XXXX-XXXX',
      // 'EXEMPLE-KAGE-ANNUEL-XXXX-XXXX',
    };
    if (knownChariowLicenses.isNotEmpty) {
      return knownChariowLicenses.contains(code);
    }
    final normalized = code.toUpperCase();
    final hasTier = normalized.contains('JONIN') || normalized.contains('KAGE');
    return code.length >= 16 && hasTier;
  }

  String _planFromLicense(String code) {
    final normalized = code.toUpperCase();
    if (normalized.contains('KAGE')) return AppConstants.rankKage;
    return AppConstants.rankJonin;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Licence Chariow'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Passe à Tchopé Plus',
                style: GoogleFonts.rajdhani(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cette fonctionnalité nécessite un abonnement Tchopé Plus pour être utilisée. Achetez votre clé de licence sur Chariow puis activez-la ici.',
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
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.backgroundCard,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activer une licence',
                      style: GoogleFonts.rajdhani(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _licenseController,
                      decoration: InputDecoration(
                        hintText: 'XXXX-XXXX-XXXX-XXXX-XXXX-XXXX',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide:
                              const BorderSide(color: AppColors.borderSubtle),
                        ),
                        filled: true,
                        fillColor: AppColors.backgroundElevated,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isActivating ? null : _activateLicense,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.rankJonin,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isActivating
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Activer',
                                style: GoogleFonts.nunitoSans(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: TextButton(
                        onPressed: () => _openUrl(_storeRootUrl),
                        child: Text(
                          'Je n’ai pas de licence',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 13,
                            color: AppColors.rankJonin,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    if (_savedLicense != null) ...[
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        'Licence active :',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _savedLicense!,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Fonctionnalités Premium',
                style: GoogleFonts.rajdhani(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
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
                onUpgrade: () => _openUrl(_planUrl('jonin')),
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
                onUpgrade: () => _openUrl(_planUrl('kage')),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  'Utilise les clés de licence Chariow. Aucune API de paiement intégrée dans l’application.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
