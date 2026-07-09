import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/character.dart';
import '../../../../core/providers/anilist_providers.dart';
import '../../../../core/providers/currency_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/price_formatter.dart';
import '../../../../core/widgets/subscription_modal.dart';

class CharDetailExclusifTab extends ConsumerStatefulWidget {
  final Character character;
  final String rank;
  final VoidCallback onShowQuoteImage;

  const CharDetailExclusifTab({
    super.key,
    required this.character,
    required this.rank,
    required this.onShowQuoteImage,
  });

  @override
  ConsumerState<CharDetailExclusifTab> createState() =>
      _CharDetailExclusifTabState();
}

class _CharDetailExclusifTabState extends ConsumerState<CharDetailExclusifTab> {
  bool _hasVoted = false;
  bool _isVoting = false;

  Character get c => widget.character;
  String get rank => widget.rank;

  Widget _buildVoteCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundAIBlue,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🏆 Fan du Mois',
            style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            _hasVoted
                ? 'Vote enregistré pour ${c.name} ce mois ✓'
                : 'Vote pour ${c.name} et gagne +10 score fan',
            style: GoogleFonts.nunitoSans(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _hasVoted ? null : _castVote,
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: _hasVoted
                    ? AppColors.backgroundElevated
                    : AppColors.warning,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: _isVoting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Text(
                        _hasVoted
                            ? 'Voté ce mois ✓'
                            : 'Voter pour ${c.name} 🏆',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: _hasVoted
                                ? AppColors.textSecondary
                                : Colors.white),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _castVote() async {
    if (_isVoting || _hasVoted) return;
    setState(() => _isVoting = true);
    final success = await ref
        .read(firestoreCharacterServiceProvider)
        .voteForCharacter(c.id);
    if (!mounted) return;
    setState(() {
      _isVoting = false;
      _hasVoted = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Vote enregistré pour ${c.name} ! +10 score fan 🏆'
              : 'Tu as déjà voté ce mois — reviens le mois prochain !',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isKage = rank == 'kage';
    final isJonin = rank == 'jonin';
    final currency = ref.watch(currencyProvider);
    final joninMonthly = PlanPrices.jonin(false, currency);
    final kageMonthly = PlanPrices.kage(false, currency);

    // ── Genin : tout verrouillé ──────────────────────────────────────
    if (!isKage && !isJonin) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('👑', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Contenu réservé Kage',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const _FeatureRow(
                icon: Icons.quiz_rounded,
                label: 'Quiz & scoring Fan du Mois',
                tier: 'Jonin+'),
            const SizedBox(height: 8),
            const _FeatureRow(
                icon: Icons.smart_toy_rounded,
                label: 'Chatbot IA personnage',
                tier: 'Kage'),
            const SizedBox(height: 8),
            const _FeatureRow(
                icon: Icons.auto_awesome_rounded,
                label: "Génération d'image citation",
                tier: 'Kage'),
            const SizedBox(height: 8),
            const _FeatureRow(
                icon: Icons.bolt_rounded,
                label: 'Anecdotes exclusives',
                tier: 'Kage'),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.push('/subscription'),
                child: Text(
                  'Obtenir Kage Pass 👑',
                  style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () =>
                  showSubscriptionModal(context, SubscriptionPlan.jonin),
              child: Text(
                'Commencer par Jonin — $joninMonthly',
                style: GoogleFonts.nunitoSans(
                    color: AppColors.statBlue,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    }

    // ── Jonin : quiz + vote accessible, reste verrouillé ────────────
    if (isJonin) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Column(
          children: [
            _buildVoteCard(),
            _QuizCard(character: c),
            const SizedBox(height: 4),
            _UpsellBanner(
              feature: 'Discuter avec ${c.name} via IA',
              tierLabel: 'Kage Pass ($kageMonthly)',
              tierColor: AppColors.statPurple,
              onTap: () => context.push('/subscription'),
            ),
            _UpsellBanner(
              feature: "Créer une image citation stylisée",
              tierLabel: 'Kage Pass',
              tierColor: AppColors.statPurple,
              onTap: () => context.push('/subscription'),
            ),
            _UpsellBanner(
              feature: 'Anecdotes exclusives sur ${c.name}',
              tierLabel: 'Kage Pass',
              tierColor: AppColors.statPurple,
              onTap: () => context.push('/subscription'),
            ),
          ],
        ),
      );
    }

    // ── Kage : tout accessible ───────────────────────────────────────
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        children: [
          // Chatbot
          GestureDetector(
            onTap: () => context.push(
              '/chat/${c.id}',
              extra: {
                'charName': c.name,
                'charImageUrl': c.imagePath ?? '',
                'charBio': c.bio ?? '',
              },
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: AppColors.backgroundAIPurple,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.statPurple.withValues(alpha: 0.4)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 64,
                          height: 64,
                          child: c.imagePath != null
                              ? Image.network(c.imagePath!, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _CharInitial(name: c.name))
                              : _CharInitial(name: c.name),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Parle à ${c.name}',
                              style: GoogleFonts.dmSans(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Assistant local · Sans Cloud Function',
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 13,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.statPurple,
                          AppColors.statPurpleDark
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Démarrer la conversation 💬',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Image citation
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.circular(16),
              border:
                  Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🎨 Citation illustrée',
                  style: GoogleFonts.dmSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
                const SizedBox(height: 6),
                Text(
                  'Génère une image stylisée avec une citation de ${c.name}',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 13, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: widget.onShowQuoteImage,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Générer ✨',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Vote Fan du Mois
          _buildVoteCard(),
          // Quiz
          _QuizCard(character: c),
        ],
      ),
    );
  }
}

// ── Sous-widgets ──────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tier;

  const _FeatureRow(
      {required this.icon, required this.label, required this.tier});

  @override
  Widget build(BuildContext context) {
    final isKage = tier == 'Kage';
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 13, color: AppColors.textSecondary)),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color:
                (isKage ? AppColors.statPurple : AppColors.statBlue)
                    .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tier,
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isKage ? AppColors.statPurple : AppColors.statBlue,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizCard extends StatelessWidget {
  final Character character;
  const _QuizCard({required this.character});

  @override
  Widget build(BuildContext context) {
    final c = character;
    return GestureDetector(
      onTap: () => context.push('/quiz/${c.id}', extra: {
        'charName': c.name,
        if (c.quizQuestions.isNotEmpty) 'quizQuestions': c.quizQuestions,
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.backgroundAIBlue,
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: AppColors.statBlue.withValues(alpha: 0.4)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🧠 Quiz personnage',
                style: GoogleFonts.dmSans(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(
              'Teste tes connaissances sur ${c.name} — 5 questions',
              style: GoogleFonts.nunitoSans(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.statBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Lancer le quiz 🧠',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpsellBanner extends StatelessWidget {
  final String feature;
  final String tierLabel;
  final Color tierColor;
  final VoidCallback onTap;

  const _UpsellBanner({
    required this.feature,
    required this.tierLabel,
    required this.tierColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: tierColor.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: tierColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline_rounded, color: tierColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(feature,
                      style: GoogleFonts.nunitoSans(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  Text('Disponible avec $tierLabel',
                      style: GoogleFonts.nunitoSans(
                          color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: tierColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('Débloquer',
                  style: GoogleFonts.nunitoSans(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharInitial extends StatelessWidget {
  final String name;
  const _CharInitial({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundElevated,
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: GoogleFonts.rajdhani(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
