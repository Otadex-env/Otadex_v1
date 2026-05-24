import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/models/anime_entry.dart';
import '../../../core/models/character.dart';
import '../../../core/models/creator_entry.dart';
import '../../../core/providers/otadex_providers.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/otadex_image.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/rank_theme.dart';
import '../../character/presentation/widgets/char_pill.dart';
import '../../home/presentation/widgets/section_header.dart';

class AnimeDetailScreen extends ConsumerStatefulWidget {
  final String animeId;

  const AnimeDetailScreen({super.key, required this.animeId});

  @override
  ConsumerState<AnimeDetailScreen> createState() => _AnimeDetailScreenState();
}

class _AnimeDetailScreenState extends ConsumerState<AnimeDetailScreen> {
  bool _showFullSynopsis = false;

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final animesAsync = ref.watch(allAnimesProvider);
    final allCharsAsync = ref.watch(allCharactersProvider);
    final allCreatorsAsync = ref.watch(allCreatorsProvider);

    return Scaffold(
      backgroundColor: theme.backgroundPrimary,
      extendBodyBehindAppBar: true,
      body: animesAsync.when(
        loading: () => const SkeletonScreen(),
        error: (_, __) => _buildErrorState(theme),
        data: (animes) {
          final matching = animes.where((a) => a.id == widget.animeId).toList();
          if (matching.isEmpty) return _buildErrorState(theme);
          final anime = matching.first;

          final allChars = allCharsAsync.valueOrNull ?? [];
          final characters = allChars
              .where((c) =>
                  c.animeName == anime.name || c.animeId == anime.id)
              .take(6)
              .toList();

          final allCreators = allCreatorsAsync.valueOrNull ?? [];
          final creatorMatches = anime.creatorId != null
              ? allCreators
                  .where((cr) => cr.id == anime.creatorId)
                  .toList()
              : <CreatorEntry>[];
          final creator =
              creatorMatches.isNotEmpty ? creatorMatches.first : null;

          final similar = animes
              .where((a) =>
                  a.id != anime.id &&
                  a.genres.any(anime.genres.contains))
              .take(4)
              .toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroBanner(anime: anime, theme: theme),
                _StatsBand(anime: anime, theme: theme),
                if (characters.isNotEmpty) ...[
                  const SectionHeader(title: 'Personnages principaux'),
                  _CharactersList(
                    characters: characters,
                    theme: theme,
                  ),
                ],
                _SynopsisSection(
                  synopsis: anime.synopsis,
                  showFull: _showFullSynopsis,
                  onToggle: () =>
                      setState(() => _showFullSynopsis = !_showFullSynopsis),
                  theme: theme,
                ),
                if (creator != null) ...[
                  const SectionHeader(title: 'Créateur'),
                  _CreatorCard(
                    creator: creator,
                    theme: theme,
                    onTap: () => context.push('/creator/${creator.id}'),
                  ),
                ],
                if (similar.isNotEmpty) ...[
                  const SectionHeader(title: 'Tu pourrais aussi aimer'),
                  _SimilarRow(
                    animes: similar,
                    theme: theme,
                    onTap: (a) => context.push('/anime/${a.id}'),
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(RankTheme theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.movie_filter_rounded, color: theme.textSecondary, size: 56),
          const SizedBox(height: 16),
          Text(
            'Animé introuvable',
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cette fiche n\'est pas disponible.',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── ZONE 1 — HERO BANNER ─────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final AnimeEntry anime;
  final RankTheme theme;

  const _HeroBanner({required this.anime, required this.theme});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background (placeholder cover art)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [anime.cardColor, anime.accentColor],
              ),
            ),
          ),

          // Decorative icon watermark
          Center(
            child: Icon(
              Icons.play_circle_outline_rounded,
              size: 96,
              color: AppColors.textPrimary.withValues(alpha: 0.08),
            ),
          ),

          // Gradient scrim: transparent → backgroundPrimary
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.35, 1.0],
                colors: [
                  AppColors.backgroundDeep.withValues(alpha: 0.0),
                  theme.backgroundPrimary,
                ],
              ),
            ),
          ),

          // Back + share buttons
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  _CircleIconButton(
                    icon: Icons.share_rounded,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),

          // Title block pinned at bottom
          Positioned(
            bottom: 14,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Genre chips
                if (anime.genres.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: anime.genres.take(3).map((g) {
                      return CharPill(
                        g,
                        bg: theme.accentColor.withValues(alpha: 0.20),
                        color: theme.accentColor,
                        border: Border.all(
                          color: theme.accentColor.withValues(alpha: 0.40),
                        ),
                        fontSize: 10,
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 8),

                // Main title
                Text(
                  anime.name,
                  style: GoogleFonts.rajdhani(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: AppColors.backgroundDeep.withValues(alpha: 0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),

                // Japanese subtitle
                if (anime.originalTitle.isNotEmpty)
                  Text(
                    anime.originalTitle,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── ZONE 2 — STATS BAND ──────────────────────────────────────────────────────

class _StatsBand extends StatelessWidget {
  final AnimeEntry anime;
  final RankTheme theme;

  const _StatsBand({required this.anime, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: theme.backgroundCard,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          _StatCell(label: 'Année', value: anime.year.toString(), theme: theme),
          _Divider(theme: theme),
          _StatCell(
            label: 'Épisodes',
            value: anime.episodes > 0 ? anime.episodes.toString() : '—',
            theme: theme,
          ),
          _Divider(theme: theme),
          _StatCell(
            label: 'Note',
            value: anime.rating > 0 ? anime.rating.toStringAsFixed(1) : '—',
            theme: theme,
            valueColor: AppColors.starYellow,
          ),
          _Divider(theme: theme),
          _StatCell(
            label: 'Studio',
            value: anime.studio.isNotEmpty ? anime.studio : '—',
            theme: theme,
            small: true,
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final RankTheme theme;
  final Color? valueColor;
  final bool small;

  const _StatCell({
    required this.label,
    required this.value,
    required this.theme,
    this.valueColor,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: GoogleFonts.rajdhani(
              fontSize: small ? 13 : 16,
              fontWeight: FontWeight.w700,
              color: valueColor ?? theme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              color: theme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  final RankTheme theme;
  const _Divider({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: theme.borderSubtle);
  }
}

// ── ZONE 3A — LISTE PERSONNAGES ──────────────────────────────────────────────

class _CharactersList extends StatelessWidget {
  final List<Character> characters;
  final RankTheme theme;

  const _CharactersList({
    required this.characters,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: characters
            .map((c) => _CharacterRow(character: c, theme: theme))
            .toList(),
      ),
    );
  }
}

class _CharacterRow extends StatelessWidget {
  final Character character;
  final RankTheme theme;

  const _CharacterRow({
    required this.character,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          // Avatar — assets locaux en priorité
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 52,
              height: 52,
              child: Builder(builder: (_) {
                final localImgs =
                    AppAssets.getByCharacterId(character.id);
                final imgPath = localImgs.isNotEmpty
                    ? localImgs.first
                    : character.imagePath ?? '';
                return imgPath.isNotEmpty
                    ? OtadexImage(imagePath: imgPath, fit: BoxFit.cover)
                    : _InitialsBox(character: character);
              }),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        character.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rajdhani(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                    ),
                    if (character.role != null) ...[
                      const SizedBox(width: 6),
                      CharPill(
                        character.role!,
                        bg: theme.accentColor.withValues(alpha: 0.15),
                        color: theme.accentColor,
                        fontSize: 9,
                      ),
                    ],
                  ],
                ),
                Text(
                  character.animeName,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: theme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _InitialsBox extends StatelessWidget {
  final Character character;
  const _InitialsBox({required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: character.cardColor,
      child: Center(
        child: Text(
          character.initials,
          style: GoogleFonts.rajdhani(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: character.accentColor,
          ),
        ),
      ),
    );
  }
}

// ── ZONE 3B — SYNOPSIS ───────────────────────────────────────────────────────

class _SynopsisSection extends StatelessWidget {
  final String synopsis;
  final bool showFull;
  final VoidCallback onToggle;
  final RankTheme theme;

  const _SynopsisSection({
    required this.synopsis,
    required this.showFull,
    required this.onToggle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    if (synopsis.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Synopsis',
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            synopsis,
            maxLines: showFull ? null : 3,
            overflow: showFull ? TextOverflow.visible : TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: theme.textSecondary,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onToggle,
            child: Text(
              showFull ? 'Réduire' : 'Lire la suite',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── ZONE 3C — CRÉATEUR ───────────────────────────────────────────────────────

class _CreatorCard extends StatelessWidget {
  final CreatorEntry creator;
  final RankTheme theme;
  final VoidCallback onTap;

  const _CreatorCard({
    required this.creator,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 72,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: theme.backgroundElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.borderSubtle),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            // Initials avatar
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.backgroundCard,
                border: Border.all(color: theme.accentColor.withValues(alpha: 0.5), width: 2),
              ),
              child: Center(
                child: Text(
                  creator.initials,
                  style: GoogleFonts.rajdhani(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: theme.accentColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    creator.name,
                    style: GoogleFonts.rajdhani(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.textPrimary,
                    ),
                  ),
                  Text(
                    [
                      creator.role.isNotEmpty ? creator.role : 'Mangaka',
                      if (creator.nationality != null) creator.nationality!,
                    ].join(' · '),
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: theme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: theme.textSecondary, size: 20),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

// ── ZONE 3D — SIMILAR ANIMES ─────────────────────────────────────────────────

class _SimilarRow extends StatelessWidget {
  final List<AnimeEntry> animes;
  final RankTheme theme;
  final void Function(AnimeEntry) onTap;

  const _SimilarRow({
    required this.animes,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 114,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: animes.length,
        itemBuilder: (context, i) {
          final anime = animes[i];
          return GestureDetector(
            onTap: () => onTap(anime),
            child: Container(
              width: 150,
              height: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [anime.cardColor, anime.accentColor],
                ),
              ),
              child: Stack(
                children: [
                  // Scrim bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(12),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.backgroundDeep.withValues(alpha: 0.0),
                            AppColors.backgroundDeep.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          anime.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rajdhani(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          anime.year.toString(),
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
          );
        },
      ),
    );
  }
}

// ── WIDGET UTILITAIRE ────────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: AppColors.overlay,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 18),
      ),
    );
  }
}
