import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/models/anime_entry.dart';
import '../../../core/models/character.dart';
import '../../../core/models/creator_entry.dart';
import '../../../core/providers/otadex_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../core/widgets/otadex_image.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/rank_theme.dart';
import '../../character/presentation/widgets/char_pill.dart';
import '../../home/presentation/widgets/section_header.dart';

class CreatorScreen extends ConsumerStatefulWidget {
  final String creatorId;

  const CreatorScreen({super.key, required this.creatorId});

  @override
  ConsumerState<CreatorScreen> createState() => _CreatorScreenState();
}

class _CreatorScreenState extends ConsumerState<CreatorScreen> {
  bool _showFullBio = false;

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final serviceAsync = ref.watch(otadexServiceProvider);

    return Scaffold(
      backgroundColor: theme.backgroundPrimary,
      extendBodyBehindAppBar: true,
      body: serviceAsync.when(
        loading: () => const SkeletonScreen(),
        error: (_, __) => _buildErrorState(theme),
        data: (service) {
          final creator = service.creatorById(widget.creatorId);
          if (creator == null) return _buildErrorState(theme);

          // Works: find matching animes by name
          final works = service.animes
              .where((a) => creator.works.contains(a.name))
              .toList();

          // Characters created by this creator
          final characters = service.characters
              .where((c) => c.creatorId == creator.id)
              .take(8)
              .toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CreatorHeader(
                  creator: creator,
                  theme: theme,
                  onBack: () => context.pop(),
                ),
                _BioSection(
                  bio: creator.bio,
                  showFull: _showFullBio,
                  onToggle: () =>
                      setState(() => _showFullBio = !_showFullBio),
                  theme: theme,
                ),
                _StatsRow(creator: creator, works: works, theme: theme),
                if (works.isNotEmpty) ...[
                  const SectionHeader(title: 'Bibliographie'),
                  _BibliographyGrid(
                    works: works,
                    theme: theme,
                    onTap: (a) => context.push('/anime/${a.id}'),
                  ),
                ],
                if (characters.isNotEmpty) ...[
                  SectionHeader(
                    title: 'Personnages de ${creator.name}',
                  ), // ignore: prefer_const_constructors — title uses interpolation
                  _CharactersRow(
                    characters: characters,
                    theme: theme,
                    onTap: (c) => context.push('/character/${c.id}'),
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
          Icon(Icons.person_off_rounded, color: theme.textSecondary, size: 56),
          const SizedBox(height: 16),
          Text(
            'Créateur introuvable',
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

// ── ZONE 1 — HEADER CRÉATEUR ─────────────────────────────────────────────────

class _CreatorHeader extends StatelessWidget {
  final CreatorEntry creator;
  final RankTheme theme;
  final VoidCallback onBack;

  const _CreatorHeader({
    required this.creator,
    required this.theme,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [theme.backgroundCard, theme.backgroundPrimary],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 24),
          child: Column(
            children: [
              // Back button row
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: onBack,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.backgroundElevated,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: theme.textPrimary,
                      size: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Avatar cercle avec initiales
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.backgroundElevated,
                  border: Border.all(
                    color: theme.accentColor,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.accentGlow,
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    creator.initials,
                    style: GoogleFonts.rajdhani(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: theme.accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Nom créateur
              Text(
                creator.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.rajdhani(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: theme.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              // Nationalité + spécialité
              const SizedBox(height: 4),
              Text(
                [
                  if (creator.nationality != null) creator.nationality!,
                  if (creator.role.isNotEmpty) creator.role,
                ].join(' · '),
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: theme.textSecondary,
                ),
              ),

              // Maison d'édition pill
              if (creator.serializedIn != null) ...[
                const SizedBox(height: 10),
                CharPill(
                  creator.serializedIn!,
                  bg: theme.accentColor.withValues(alpha: 0.15),
                  color: theme.accentColor,
                  border: Border.all(
                    color: theme.accentColor.withValues(alpha: 0.35),
                  ),
                  fontSize: 12,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── ZONE 2 — BIOGRAPHIE ──────────────────────────────────────────────────────

class _BioSection extends StatelessWidget {
  final String? bio;
  final bool showFull;
  final VoidCallback onToggle;
  final RankTheme theme;

  const _BioSection({
    required this.bio,
    required this.showFull,
    required this.onToggle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final text = bio?.isNotEmpty == true ? bio! : 'Aucune biographie disponible.';
    final hasMore = (bio?.length ?? 0) > 180;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À propos',
            style: GoogleFonts.rajdhani(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            maxLines: showFull ? null : 4,
            overflow: showFull ? TextOverflow.visible : TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: theme.textSecondary,
              height: 1.65,
            ),
          ),
          if (hasMore) ...[
            const SizedBox(height: 6),
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
        ],
      ),
    );
  }
}

// ── ZONE 3 — STATISTIQUES RAPIDES ────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final CreatorEntry creator;
  final List<AnimeEntry> works;
  final RankTheme theme;

  const _StatsRow({
    required this.creator,
    required this.works,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final debutYear = creator.debutYear ?? creator.bornYear;
    final seriesPhare = works.isNotEmpty ? works.first.name : '—';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Row(
        children: [
          _QuickStat(
            label: 'Œuvres',
            value: creator.works.length.toString(),
            theme: theme,
          ),
          _VerticalDivider(theme: theme),
          _QuickStat(
            label: 'Depuis',
            value: debutYear?.toString() ?? '—',
            theme: theme,
          ),
          _VerticalDivider(theme: theme),
          _QuickStat(
            label: 'Série phare',
            value: seriesPhare,
            theme: theme,
            small: true,
          ),
        ],
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String label;
  final String value;
  final RankTheme theme;
  final bool small;

  const _QuickStat({
    required this.label,
    required this.value,
    required this.theme,
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
              fontSize: small ? 13 : 18,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
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

class _VerticalDivider extends StatelessWidget {
  final RankTheme theme;
  const _VerticalDivider({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: theme.borderSubtle);
  }
}

// ── ZONE 4 — BIBLIOGRAPHIE ───────────────────────────────────────────────────

class _BibliographyGrid extends StatelessWidget {
  final List<AnimeEntry> works;
  final RankTheme theme;
  final void Function(AnimeEntry) onTap;

  const _BibliographyGrid({
    required this.works,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 169 / 120,
        ),
        itemCount: works.length,
        itemBuilder: (context, i) {
          final anime = works[i];
          return GestureDetector(
            onTap: () => onTap(anime),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [anime.cardColor, anime.accentColor],
                      ),
                    ),
                  ),

                  // Bottom overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.4, 1.0],
                        colors: [
                          AppColors.backgroundDeep.withValues(alpha: 0.0),
                          AppColors.backgroundDeep.withValues(alpha: 0.88),
                        ],
                      ),
                    ),
                  ),

                  // Text info
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

// ── ZONE 5 — PERSONNAGES ─────────────────────────────────────────────────────

class _CharactersRow extends StatelessWidget {
  final List<Character> characters;
  final RankTheme theme;
  final void Function(Character) onTap;

  const _CharactersRow({
    required this.characters,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 194,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: characters.length,
        itemBuilder: (context, i) {
          final character = characters[i];
          return GestureDetector(
            onTap: () => onTap(character),
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Image or fallback
                    character.imagePath != null
                        ? OtadexImage(
                            imagePath: character.imagePath!,
                            fit: BoxFit.cover,
                          )
                        : _buildFallback(character),

                    // Gradient scrim
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.45, 1.0],
                          colors: [
                            AppColors.backgroundDeep.withValues(alpha: 0.0),
                            AppColors.backgroundDeep.withValues(alpha: 0.90),
                          ],
                        ),
                      ),
                    ),

                    // Name
                    Positioned(
                      bottom: 8,
                      left: 8,
                      right: 8,
                      child: Text(
                        character.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rajdhani(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFallback(Character character) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [character.cardColor, character.accentColor],
        ),
      ),
      child: Center(
        child: Text(
          character.initials,
          style: GoogleFonts.rajdhani(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: character.accentColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
