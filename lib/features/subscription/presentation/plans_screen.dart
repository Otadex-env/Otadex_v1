import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/presentation/widgets/billing_toggle.dart';
import '../../profile/presentation/widgets/plan_card.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  bool _isAnnual = false;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    final currentRank = profile.rank;

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.textPrimary,
                  size: 20,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            'Débloque OTADEX Premium ⭐',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Rejoins +2 000 fans déjà abonnés',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: BillingToggle(
                        cycle: _isAnnual ? 'annuel' : 'mensuel',
                        onChanged: (v) =>
                            setState(() => _isAnnual = v == 'annuel'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Genin
                          PlanCard(
                            name: 'Genin',
                            tag: currentRank == 'genin' ? 'ACTUEL' : null,
                            tagColor: AppColors.success,
                            price: 'Gratuit',
                            priceColor: AppColors.textPrimary,
                            features: const [
                              (true, 'Fiches & navigation'),
                              (true, 'Likes & commentaires'),
                              (true, 'Collection · 10 max'),
                              (false, 'Publicités affichées'),
                              (false, 'IA désactivée'),
                            ],
                            buttonLabel: currentRank == 'genin'
                                ? 'Plan actuel'
                                : 'Rétrograder',
                            buttonEnabled: currentRank != 'genin',
                            borderColor:
                                AppColors.success.withValues(alpha: 0.4),
                            isCta: false,
                            onUpgrade: currentRank == 'genin'
                                ? null
                                : () => _confirmDowngrade(),
                          ),
                          const SizedBox(height: 12),
                          // Jonin — blue glow
                          _GlowWrapper(
                            color: AppColors.statBlue,
                            child: PlanCard(
                              name: 'Jonin',
                              tag: 'POPULAIRE',
                              tagColor: AppColors.statBlue,
                              price: _isAnnual
                                  ? '1 800 FCFA/mois\nfacturé 21 600/an'
                                  : '2 000 FCFA/mois',
                              priceColor: AppColors.statBlue,
                              features: const [
                                (true, 'Collection illimitée'),
                                (true, 'Sans publicités'),
                                (true, 'IA chatbot + quiz'),
                                (true, 'Badge Jonin 🥷'),
                                (false, 'Génération images IA'),
                              ],
                              buttonLabel: currentRank == 'jonin'
                                  ? 'Plan actuel'
                                  : 'Devenir Jonin',
                              buttonEnabled: currentRank != 'jonin',
                              borderColor: AppColors.statBlue,
                              isCta: currentRank != 'jonin',
                              onUpgrade: currentRank == 'jonin'
                                  ? null
                                  : () => _showPaymentSheet('jonin'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Kage — gradient
                          _KageCard(
                            isAnnual: _isAnnual,
                            isCurrentPlan: currentRank == 'kage',
                            onUpgrade: () => _showPaymentSheet('kage'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Modes de paiement acceptés',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PaymentPill(label: '🟠 Orange Money'),
                        SizedBox(width: 8),
                        _PaymentPill(label: '🟡 MTN MoMo'),
                        SizedBox(width: 8),
                        _PaymentPill(label: '💳 Visa/MC'),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            'Annulation possible à tout moment',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            'Renouvellement automatique · Prix en FCFA',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDowngrade() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundCard,
        title: Text(
          'Rétrograder vers Genin ?',
          style: GoogleFonts.dmSans(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Tu perdras tes avantages premium.',
          style: GoogleFonts.nunitoSans(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () async {
              Navigator.pop(ctx);
              ref
                  .read(userProfileProvider.notifier)
                  .updateIdentity(rank: 'genin');
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_rank', 'genin');
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .update({'abonnement': 'genin'});
              }
            },
            child: const Text(
              'Confirmer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet(String plan) {
    final isAnnual = _isAnnual;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textDisabled,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Finaliser ton abonnement',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _planRecap(plan, isAnnual),
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            _PaymentOptionButton(
              label: '🟠 Payer avec Orange Money',
              onTap: () => _processPayment(plan),
            ),
            const SizedBox(height: 8),
            _PaymentOptionButton(
              label: '🟡 Payer avec MTN MoMo',
              onTap: () => _processPayment(plan),
            ),
            const SizedBox(height: 8),
            _PaymentOptionButton(
              label: '💳 Payer par carte bancaire',
              onTap: () => _processPayment(plan),
            ),
            const SizedBox(height: 12),
            Text(
              'Intégration Chariow activée — Phase 2',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                color: AppColors.textDisabled,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _planRecap(String plan, bool isAnnual) {
    if (plan == 'jonin') {
      return isAnnual
          ? 'Jonin · 1 800 FCFA/mois facturé annuellement'
          : 'Jonin · 2 000 FCFA/mois';
    }
    return isAnnual
        ? 'Kage · 4 500 FCFA/mois facturé annuellement'
        : 'Kage · 5 000 FCFA/mois';
  }

  Future<void> _processPayment(String plan) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.accent),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    Navigator.pop(context); // dismiss dialog
    Navigator.pop(context); // dismiss sheet
    ref.read(userProfileProvider.notifier).updateIdentity(rank: plan);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_rank', plan);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .update({'abonnement': plan});
    }
    if (!mounted) return;
    final rankName = plan == 'jonin' ? 'Jonin' : 'Kage';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🎉 Bienvenue chez les $rankName !'),
        backgroundColor:
            plan == 'jonin' ? AppColors.statBlue : AppColors.statPurple,
      ),
    );
    context.pop();
  }
}

// ── Helpers ──────────────────────────────────────────────────────────────────

class _GlowWrapper extends StatelessWidget {
  final Color color;
  final Widget child;
  const _GlowWrapper({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.25),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _KageCard extends StatelessWidget {
  final bool isAnnual;
  final bool isCurrentPlan;
  final VoidCallback onUpgrade;

  const _KageCard({
    required this.isAnnual,
    required this.isCurrentPlan,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final price = isAnnual
        ? '4 500 FCFA/mois\nfacturé 54 000/an'
        : '5 000 FCFA/mois';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A0A2E), Color(0xFF0D0D0F)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.statPurple, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x408B5CF6),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.statPurple, AppColors.statPurplePastel],
                ).createShader(bounds),
                child: Text(
                  'Kage',
                  style: GoogleFonts.rajdhani(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (isCurrentPlan)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.statPurple.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'ACTUEL',
                    style: GoogleFonts.rajdhani(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.statPurple,
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
              color: AppColors.statPurple,
            ),
          ),
          const SizedBox(height: 10),
          for (final label in const [
            'Tout Jonin inclus',
            'Génération images IA ⭐',
            'Sans watermark',
            'Thèmes exclusifs 👑',
            'Priorité Fan du Mois',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  const Text(
                    '✓',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: isCurrentPlan ? null : onUpgrade,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: isCurrentPlan
                    ? null
                    : const LinearGradient(
                        colors: [AppColors.statPurple, Color(0xFF6D28D9)],
                      ),
                color: isCurrentPlan ? AppColors.backgroundElevated : null,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isCurrentPlan ? 'Plan actuel 👑' : 'Obtenir Kage Pass 👑',
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isCurrentPlan ? AppColors.textDisabled : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PaymentOptionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.backgroundElevated,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _PaymentPill extends StatelessWidget {
  final String label;
  const _PaymentPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunitoSans(
          fontSize: 10,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}
