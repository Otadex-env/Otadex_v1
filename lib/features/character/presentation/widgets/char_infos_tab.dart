import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/character.dart';
import '../../../../core/providers/anilist_providers.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/subscription/rank_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/auth_gate_modal.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/widgets/subscription_modal.dart';
import 'char_discover_section.dart';
import 'char_gallery_strip.dart';
import 'char_identity_grid.dart';
import 'char_powers_section.dart';
import 'char_quotes_carousel.dart';
import 'char_section_header.dart';
import 'char_voice_actors_row.dart';

/// Onglet « Infos » d'une fiche personnage.
///
/// Ordre voulu : on MONTRE d'abord (fiche rapide, galerie), on RACONTE ensuite
/// (histoire, pouvoirs, citations), puis la communauté (commentaires).
class CharDetailInfosTab extends ConsumerStatefulWidget {
  final Character character;
  final int? anilistId;
  final List<String> images;

  const CharDetailInfosTab({
    super.key,
    required this.character,
    required this.anilistId,
    this.images = const [],
  });

  @override
  ConsumerState<CharDetailInfosTab> createState() => _CharDetailInfosTabState();
}

class _CharDetailInfosTabState extends ConsumerState<CharDetailInfosTab> {
  bool _aboutExpanded = false;

  Character get c => widget.character;
  Color get _accent => c.accentColor;
  bool get _isKage => ref.watch(effectiveRankProvider) == UserRank.kage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CharIdentityGrid(character: c),
        CharGalleryStrip(character: c, images: widget.images),
        _buildAboutSection(),
        if (c.powers.isNotEmpty)
          CharPowersSection(powers: c.powers, accent: _accent),
        CharQuotesCarousel(character: c),
        _buildVoiceActorsSection(),
        _buildTriviaSection(),
        _buildCommentsSection(),
        CharDiscoverSection(currentCharId: c.id),
      ],
    );
  }

  // ── À propos ──────────────────────────────────────────────────────

  /// Sépare la 1re phrase (accroche, mise en avant) du reste de la bio.
  /// Si la 1re phrase est trop longue pour être une accroche, tout reste en corps.
  (String?, String) _splitBio(String bio) {
    final m = RegExp(r'[.!?](\s|$)').firstMatch(bio);
    if (m == null) return (null, bio);
    final lead = bio.substring(0, m.start + 1).trim();
    if (lead.length < 25 || lead.length > 170) return (null, bio);
    return (lead, bio.substring(m.end).trim());
  }

  Widget _buildAboutSection() {
    final bio = c.bio?.trim();
    final hasBio = bio != null && bio.isNotEmpty;
    final (lead, rest) = hasBio ? _splitBio(bio) : (null, '');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CharSectionHeader(
            icon: Icons.auto_stories_rounded,
            title: 'Histoire',
            accent: _accent,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border(left: BorderSide(color: _accent, width: 3)),
            ),
            child: !hasBio
                ? Text(
                    'Aucune description disponible.',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 14, color: AppColors.textSecondary),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (lead != null)
                        Text(
                          lead,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      if (rest.isNotEmpty) ...[
                        if (lead != null) const SizedBox(height: 8),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.topCenter,
                          child: Text(
                            rest,
                            maxLines: _aboutExpanded ? null : 3,
                            overflow: _aboutExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () =>
                              setState(() => _aboutExpanded = !_aboutExpanded),
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              _aboutExpanded ? 'Réduire ↑' : 'Lire la suite ↓',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 13,
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // ── Doubleurs ─────────────────────────────────────────────────────

  Widget _buildVoiceActorsSection() {
    // Sans doubleur Otadex ni identifiant AniList : on n'affiche rien plutôt
    // qu'un titre suivi de « Aucun doubleur disponible ».
    if (c.voiceActors.isEmpty && widget.anilistId == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CharSectionHeader(
            icon: Icons.mic_rounded,
            title: 'Doubleurs',
            accent: _accent,
          ),
          const SizedBox(height: 14),
          if (c.voiceActors.isNotEmpty)
            CharVoiceActorsRow(
              accent: _accent,
              actors: [
                for (final va in c.voiceActors)
                  VoiceActorItem(
                    name: va.nom,
                    language: va.langue,
                    imageUrl: va.imageUrl,
                  ),
              ],
            )
          else
            _buildVoiceActorsFromAnilist(),
        ],
      ),
    );
  }

  Widget _buildVoiceActorsFromAnilist() {
    final dataAsync = ref.watch(charFullDataProvider(widget.anilistId!));
    return dataAsync.when(
      loading: () => shimmerBox(height: 110, radius: 12),
      error: (_, __) => const SizedBox.shrink(),
      data: (data) {
        if (data == null) return const SizedBox.shrink();
        final edges = (data['media']?['edges'] as List<dynamic>?) ?? [];
        final actors = <VoiceActorItem>[];
        final seen = <Object?>{};
        for (final edge in edges) {
          for (final va in (edge['voiceActors'] as List<dynamic>?) ?? []) {
            final m = va as Map<String, dynamic>;
            if (!seen.add(m['id'])) continue;
            actors.add(VoiceActorItem(
              name: (m['name']?['full'] as String?) ?? '—',
              language: (m['languageV2'] as String?) ?? '',
              imageUrl: (m['image']?['large'] as String?) ?? '',
              id: '${m['id']}',
            ));
          }
        }
        if (actors.isEmpty) return const SizedBox.shrink();
        return CharVoiceActorsRow(
          accent: _accent,
          actors: actors,
          onTap: (a) => context.push('/voice-actor/${a.id}'),
        );
      },
    );
  }

  // ── Commentaires ─────────────────────────────────────────────────

  Widget _buildCommentsSection() {
    final commentsAsync = ref.watch(commentsForCharacterProvider(c.id));
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CharSectionHeader(
            icon: Icons.forum_rounded,
            title: 'Commentaires',
            accent: _accent,
            trailing: GestureDetector(
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.edit_rounded,
                        size: 13, color: AppColors.accent),
                    const SizedBox(width: 5),
                    Text(
                      'Commenter',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          commentsAsync.when(
            loading: () => shimmerBox(height: 60, radius: 10),
            error: (_, __) => const SizedBox.shrink(),
            data: (comments) {
              if (comments.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundElevated,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.chat_bubble_outline_rounded,
                          color: _accent.withValues(alpha: 0.7), size: 26),
                      const SizedBox(height: 8),
                      Text(
                        'Sois le premier à commenter !',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
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
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar : initiale du pseudo, à la couleur du personnage.
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accent.withValues(alpha: 0.2),
            ),
            child: Center(
              child: Text(
                pseudo.isNotEmpty ? pseudo[0].toUpperCase() : '?',
                style: GoogleFonts.rajdhani(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pseudo,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
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
                            final ok = await ref
                                .read(firestoreCharacterServiceProvider)
                                .submitComment(c.id, controller.text);
                            if (!ok) {
                              // Échec : on garde la feuille ouverte (le texte
                              // saisi est conservé) et on réactive le bouton.
                              if (sheetCtx.mounted) {
                                setSheetState(() => isSubmitting = false);
                              }
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Impossible de publier. Vérifie ta connexion et réessaie.')),
                                );
                              }
                              return;
                            }
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
                      isSubmitting
                          ? 'Publication...'
                          : 'Publier le commentaire',
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
      padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CharSectionHeader(
            icon: Icons.lightbulb_rounded,
            title: 'Le savais-tu ?',
            accent: _accent,
          ),
          const SizedBox(height: 12),
          if (!_isKage)
            GestureDetector(
              // Carte informative « Exclusif Kage ». Le renvoi vers le modal
              // d'achat n'est actif que si kEnablePaidPlans est true.
              onTap: kEnablePaidPlans
                  ? () => showSubscriptionModal(context, SubscriptionPlan.kage)
                  : null,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.statPurple.withValues(alpha: 0.18),
                      AppColors.backgroundElevated,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: AppColors.statPurple.withValues(alpha: 0.3)),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Icon(Icons.lock_rounded,
                        color: AppColors.statPurple, size: 26),
                    const SizedBox(height: 8),
                    Text(
                      'Exclusif Kage',
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.statPurple,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${c.trivia.length} anecdotes réservées aux Kage',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                for (var i = 0; i < c.trivia.length; i++)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _accent.withValues(alpha: 0.2),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: GoogleFonts.rajdhani(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _accent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            c.trivia[i],
                            style: GoogleFonts.nunitoSans(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
