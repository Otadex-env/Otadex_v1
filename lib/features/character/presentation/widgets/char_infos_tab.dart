import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/character.dart';
import '../../../../core/providers/anilist_providers.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_gate_modal.dart';
import '../../../../core/widgets/otadex_image.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/widgets/subscription_modal.dart';
import 'char_discover_section.dart';

class CharDetailInfosTab extends ConsumerStatefulWidget {
  final Character character;
  final int? anilistId;
  final String rank;

  const CharDetailInfosTab({
    super.key,
    required this.character,
    required this.anilistId,
    required this.rank,
  });

  @override
  ConsumerState<CharDetailInfosTab> createState() => _CharDetailInfosTabState();
}

class _CharDetailInfosTabState extends ConsumerState<CharDetailInfosTab> {
  bool _aboutExpanded = false;

  Character get c => widget.character;
  bool get _isKage => widget.rank == 'kage';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIdentiteSection(),
        _buildAboutSection(),
        if (c.powers.isNotEmpty) _buildPowersSection(),
        if (c.quotes.isNotEmpty) _buildQuotesSection(),
        _buildVoiceActorsSection(),
        _buildTriviaSection(),
        _buildCommentsSection(),
        CharDiscoverSection(currentCharId: c.id),
      ],
    );
  }

  // ── Identité ──────────────────────────────────────────────────────

  Widget _buildIdentiteSection() {
    final cells = [
      ('Âge', c.age ?? '—'),
      ('Genre', c.gender ?? '—'),
      ('Statut', c.status ?? c.role ?? '—'),
      ('Nationalité', c.nationality ?? '—'),
      ('Groupe sanguin', c.bloodType ?? '—'),
      ('Naissance', c.birthday ?? c.dateOfBirth ?? '—'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.6,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        children: cells.map((cell) {
          final (label, value) = cell;
          return Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── À propos ──────────────────────────────────────────────────────

  Widget _buildAboutSection() {
    final bio = c.bio ?? 'Aucune description disponible.';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À propos',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bio,
            maxLines: _aboutExpanded ? null : 6,
            overflow: _aboutExpanded ? null : TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _aboutExpanded = !_aboutExpanded),
            child: Text(
              _aboutExpanded ? 'Réduire ↑' : 'Lire la suite ↓',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pouvoirs ──────────────────────────────────────────────────────

  Widget _buildPowersSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚔️ Pouvoirs & Capacités',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: c.powers.map((power) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.statPurple.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                      color: AppColors.statPurple.withValues(alpha: 0.55)),
                ),
                child: Text(
                  power,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.statPurplePastel,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── Citations ─────────────────────────────────────────────────────

  Widget _buildQuotesSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💬 Citations',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...c.quotes.map(_buildQuoteCard),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(String quote) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Positioned(
            top: -8,
            left: 2,
            child: Text(
              '"',
              style: GoogleFonts.nunitoSans(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: AppColors.accent.withValues(alpha: 0.16),
                height: 1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '— ${c.name}, ${c.animeName}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.ios_share_rounded,
                        color: AppColors.textSecondary, size: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Doubleurs ─────────────────────────────────────────────────────

  Widget _buildVoiceActorsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🎙️ Doubleurs',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          if (c.voiceActors.isNotEmpty)
            _buildMockVoiceActors()
          else if (widget.anilistId != null)
            _buildVoiceActorsList()
          else
            Text(
              'Aucun doubleur disponible',
              style: GoogleFonts.nunitoSans(
                  fontSize: 13, color: AppColors.textSecondary),
            ),
        ],
      ),
    );
  }

  Widget _buildMockVoiceActors() {
    return Column(
      children: c.voiceActors.map((va) {
        return Container(
          height: 64,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.backgroundElevated,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: _buildVoiceActorRow(
            name: va.nom,
            lang: va.langue,
            imageChild: va.imageUrl.isNotEmpty
                ? OtadexImage(imagePath: va.imageUrl, fit: BoxFit.cover)
                : Container(
                    color: AppColors.backgroundCard,
                    child: Center(
                      child: Text(
                        va.nom.isNotEmpty ? va.nom[0].toUpperCase() : '?',
                        style: GoogleFonts.rajdhani(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVoiceActorsList() {
    final dataAsync = ref.watch(charFullDataProvider(widget.anilistId!));
    return dataAsync.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: shimmerBox(height: 80, radius: 12),
      ),
      error: (_, __) => Text('Aucun doubleur disponible',
          style: GoogleFonts.nunitoSans(
              fontSize: 13, color: AppColors.textSecondary)),
      data: (data) {
        if (data == null) {
          return Text('Aucun doubleur disponible',
              style: GoogleFonts.nunitoSans(
                  fontSize: 13, color: AppColors.textSecondary));
        }
        final edges = (data['media']?['edges'] as List<dynamic>?) ?? [];
        final voiceActors = <Map<String, dynamic>>[];
        for (final edge in edges) {
          final vas = (edge['voiceActors'] as List<dynamic>?) ?? [];
          for (final va in vas) {
            final vaMap = va as Map<String, dynamic>;
            if (!voiceActors.any((v) => v['id'] == vaMap['id'])) {
              voiceActors.add(vaMap);
            }
          }
        }
        if (voiceActors.isEmpty) {
          return Text('Aucun doubleur disponible',
              style: GoogleFonts.nunitoSans(
                  fontSize: 13, color: AppColors.textSecondary));
        }
        return Column(
          children: voiceActors.map((va) {
            final name = (va['name']?['full'] as String?) ?? '—';
            final lang = (va['languageV2'] as String?) ?? '';
            final img = (va['image']?['large'] as String?) ?? '';
            return GestureDetector(
              onTap: () => context.push('/voice-actor/${va['id']}'),
              child: Container(
                height: 64,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _buildVoiceActorRow(
                  name: name,
                  lang: lang,
                  imageChild: OtadexImage(imagePath: img, fit: BoxFit.cover),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildVoiceActorRow({
    required String name,
    required String lang,
    required Widget imageChild,
  }) {
    return Row(
      children: [
        ClipOval(child: SizedBox(width: 48, height: 48, child: imageChild)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              Text(lang,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Commentaires ─────────────────────────────────────────────────

  Widget _buildCommentsSection() {
    final commentsAsync = ref.watch(commentsForCharacterProvider(c.id));
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '💬 Commentaires',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showCommentSheet,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.35)),
                  ),
                  child: Text(
                    'Commenter ✏️',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          commentsAsync.when(
            loading: () => shimmerBox(height: 60, radius: 10),
            error: (_, __) => const SizedBox.shrink(),
            data: (comments) {
              if (comments.isEmpty) {
                return Text(
                  'Sois le premier à commenter !',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 13, color: AppColors.textSecondary),
                );
              }
              return Column(
                children: comments.take(5).map(_buildCommentCard).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Map<String, dynamic> comment) {
    final pseudo = (comment['pseudo'] as String?) ?? 'Fan OTADEX';
    final texte = (comment['texte'] as String?) ?? '';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            pseudo,
            style: GoogleFonts.nunitoSans(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            texte,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentSheet() {
    if (!ref.read(isLoggedInProvider)) {
      showAuthGateModal(context);
      return;
    }
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        bool isSubmitting = false;
        return StatefulBuilder(
          builder: (_, setSheetState) => Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(sheetCtx).viewInsets.bottom),
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderSubtle,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Commenter ${c.name}',
                    style: GoogleFonts.rajdhani(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    autofocus: true,
                    maxLines: 4,
                    maxLength: 300,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 14, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Partage ton avis sur ${c.name}...',
                      hintStyle: GoogleFonts.nunitoSans(
                          color: AppColors.textSecondary, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.backgroundCard,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () async {
                            if (controller.text.trim().isEmpty) return;
                            setSheetState(() => isSubmitting = true);
                            await ref
                                .read(firestoreCharacterServiceProvider)
                                .submitComment(c.id, controller.text);
                            if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Commentaire publié ! +3 score fan ⭐')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      isSubmitting ? 'Publication...' : 'Publier le commentaire',
                      style:
                          GoogleFonts.nunitoSans(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ── Trivia ────────────────────────────────────────────────────────

  Widget _buildTriviaSection() {
    if (c.trivia.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚡ Le savais-tu ?',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          if (!_isKage)
            GestureDetector(
              onTap: () =>
                  showSubscriptionModal(context, SubscriptionPlan.kage),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.statPurple.withValues(alpha: 0.15),
                      AppColors.backgroundElevated,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        '👑 Exclusif Kage',
                        style: GoogleFonts.rajdhani(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.statPurple,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Contenu réservé aux Kage',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Column(
              children: c.trivia.map((fact) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('✦',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 16, color: AppColors.accent)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(fact,
                            style: GoogleFonts.nunitoSans(
                                fontSize: 14,
                                color: AppColors.textSecondary)),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
