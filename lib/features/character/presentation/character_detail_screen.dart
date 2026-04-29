import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/character.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/rank_theme.dart';
import 'widgets/char_ai_card.dart';
import 'widgets/char_circle_button.dart';
import 'widgets/char_comment_card.dart';
import 'widgets/char_pill.dart';
import 'widgets/char_section_header.dart';
import 'widgets/char_tab_delegate.dart';

class CharacterDetailScreen extends StatefulWidget {
  final Character character;
  const CharacterDetailScreen({super.key, required this.character});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  int _activeTab = 0;
  bool _isLiked = false;
  bool _isCollected = false;
  bool _aboutExpanded = false;
  int _userRating = 3;

  Character get c => widget.character;

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Scaffold(
      backgroundColor: theme.backgroundPrimary,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHero(theme)),
              SliverPersistentHeader(
                pinned: true,
                delegate: CharTabDelegate(
                  activeTab: _activeTab,
                  onTap: (i) => setState(() => _activeTab = i),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  color: theme.backgroundCard,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuickStats(theme),
                      _buildPowers(theme),
                      _buildAbout(theme),
                      _buildQuoteCard(theme),
                      _buildGallery(),
                      _buildPopularity(theme),
                      _buildRatingCard(theme),
                      _buildSeriesSection(theme),
                      _buildOtherCharacters(theme),
                      _buildAISection(theme),
                      _buildComments(theme),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildFAB(theme),
        ],
      ),
    );
  }

  // ── HERO ──────────────────────────────────────────────────────────────────

  Widget _buildHero(RankTheme theme) {
    return SizedBox(
      height: 400,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A0A2E), Color(0xFF2D1B69)],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 60,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(150),
                  gradient: const RadialGradient(
                    colors: [
                      Color(0x728B5CF6),
                      Color(0x403B82F6),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.35, 0.65],
                  ),
                ),
              ),
            ),
          ),
          _buildHeroVisual(),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 200,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.backgroundPrimary,
                      theme.backgroundCard,
                    ],
                    stops: const [0.0, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CharCircleButton(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                  Row(
                    children: [
                      CharCircleButton(
                        onTap: () {},
                        child: const Icon(Icons.ios_share_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => setState(() => _isLiked = !_isLiked),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isLiked
                                    ? AppColors.error
                                    : AppColors.error.withValues(alpha: 0.85),
                              ),
                              child: const Icon(Icons.favorite_rounded,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '38.2k',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                shadows: const [
                                  Shadow(color: Colors.black54, blurRadius: 4)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    CharPill('PROTAGONISTE', bg: theme.accentColor),
                    CharPill(
                      'SHŌNEN',
                      bg: const Color(0xFF3B82F6).withValues(alpha: 0.2),
                      border:
                          Border.all(color: const Color(0xFF3B82F6)),
                      color: const Color(0xFF93C5FD),
                    ),
                    CharPill(
                      'GRADE SPÉCIAL',
                      bg: const Color(0xFF8B5CF6).withValues(alpha: 0.2),
                      border:
                          Border.all(color: const Color(0xFF8B5CF6)),
                      color: const Color(0xFFC4B5FD),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  c.name.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 1,
                    height: 1,
                    shadows: const [
                      Shadow(color: Colors.black45, blurRadius: 8)
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  c.animeName,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 13, color: theme.textSecondary),
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(children: [
                    const TextSpan(
                        text:
                            '❤️ 38 247 likes  ·  🎴 12 804 collections  ·  📺 '),
                    TextSpan(
                      text: c.animeName,
                      style: TextStyle(
                          color: theme.accentColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ]),
                  style: GoogleFonts.nunitoSans(
                      fontSize: 12, color: theme.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroVisual() {
    if (c.imagePath != null) {
      return Positioned(
        left: 0,
        right: 0,
        top: 44,
        bottom: 80,
        child: Image.asset(
          c.imagePath!,
          fit: BoxFit.contain,
          alignment: Alignment.bottomCenter,
          errorBuilder: (_, __, ___) => _buildSilhouette(),
        ),
      );
    }
    return _buildSilhouette();
  }

  Widget _buildSilhouette() {
    return Positioned(
      left: 0,
      right: 0,
      top: 60,
      bottom: 80,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), width: 2),
              ),
              child: Center(
                child: Text(
                  c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                  style: GoogleFonts.rajdhani(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 60,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white.withValues(alpha: 0.12),
                border:
                    Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── QUICK STATS ───────────────────────────────────────────────────────────

  Widget _buildQuickStats(RankTheme theme) {
    final cells = [
      ('ÂGE', '28 ans', false),
      ('GENRE', 'Masculin ♂', false),
      ('NATIONALITÉ', '🇯🇵 Japonaise', false),
      ('STATUT', 'Actif', true),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 2.6,
        children: cells.map((cell) {
          final (label, value, dot) = cell;
          return Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 10,
                    color: theme.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: theme.textPrimary,
                      ),
                    ),
                    if (dot) ...[
                      const SizedBox(width: 6),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF10B981),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981)
                                  .withValues(alpha: 0.6),
                              blurRadius: 6,
                            )
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── POWERS ────────────────────────────────────────────────────────────────

  Widget _buildPowers(RankTheme theme) {
    final powers = [
      (
        "L'Infini",
        const Color(0xFF8B5CF6).withValues(alpha: 0.15),
        const Color(0xFF8B5CF6),
        const Color(0xFFC4B5FD)
      ),
      (
        'Vide Illimité',
        const Color(0xFF8B5CF6).withValues(alpha: 0.15),
        const Color(0xFF8B5CF6),
        const Color(0xFFC4B5FD)
      ),
      (
        'Technique Inversée',
        const Color(0xFF10B981).withValues(alpha: 0.15),
        const Color(0xFF10B981),
        const Color(0xFF6EE7B7)
      ),
      (
        'Domaine Expansif',
        const Color(0xFF3B82F6).withValues(alpha: 0.15),
        const Color(0xFF3B82F6),
        const Color(0xFF93C5FD)
      ),
      (
        'Infini Pourpre',
        AppColors.error.withValues(alpha: 0.15),
        AppColors.error,
        const Color(0xFFFCA5A5)
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚡ Pouvoirs & Capacités',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: powers.map((p) {
              final (name, bg, border, textColor) = p;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: Text(
                  name,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ── ABOUT ─────────────────────────────────────────────────────────────────

  Widget _buildAbout(RankTheme theme) {
    const bio =
        'Considéré comme le sorcier le plus puissant de son époque, ce maître des arts occultes dirige la plus grande école de jujutsu. '
        'Il maîtrise une technique héréditaire unique qui rend son corps physiquement intouchable. '
        'Derrière son attitude désinvolte se cache une vision profonde : former une nouvelle génération de guerriers capables de faire face aux menaces les plus obscures.';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'À propos',
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bio,
            maxLines: _aboutExpanded ? null : 3,
            overflow: _aboutExpanded ? null : TextOverflow.ellipsis,
            style: GoogleFonts.nunitoSans(
              fontSize: 14,
              color: theme.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _aboutExpanded = !_aboutExpanded),
            child: Text(
              _aboutExpanded ? 'Réduire ↑' : 'Lire la suite →',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: theme.accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── QUOTE CARD ────────────────────────────────────────────────────────────

  Widget _buildQuoteCard(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundElevated,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Positioned(
              top: -8,
              left: 4,
              child: Text(
                '"',
                style: GoogleFonts.nunitoSans(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  color: theme.accentColor.withValues(alpha: 0.2),
                  height: 1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dans ce monde, le talent bat le travail acharné. Et le talent né est battu par le talent éveillé.',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: theme.textPrimary,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '— ${c.name}, ${c.animeName}',
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunitoSans(
                              fontSize: 11, color: theme.textSecondary),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.ios_share_rounded,
                          color: theme.textSecondary, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── GALLERY ───────────────────────────────────────────────────────────────

  Widget _buildGallery() {
    final palettes = [
      [const Color(0xFF3B82F6), const Color(0xFF1A0A2E)],
      [const Color(0xFF8B5CF6), const Color(0xFF1E1B4B)],
      [const Color(0xFFFF6D1B), const Color(0xFF2D0A0A)],
      [const Color(0xFF10B981), const Color(0xFF064E3B)],
    ];
    Widget tile(int seed, double h, {bool more = false}) {
      final colors = palettes[seed % palettes.length];
      return Container(
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: more
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.grid_view_rounded,
                        color: Colors.white, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      '+28',
                      style: GoogleFonts.nunitoSans(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              )
            : Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    'OTADEX',
                    style: GoogleFonts.rajdhani(
                      fontSize: 8,
                      color: Colors.white.withValues(alpha: 0.35),
                      letterSpacing: 1,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
      );
    }

    return Column(
      children: [
        const CharSectionHeader(title: '📸 Galerie', action: 'Voir tout →'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    tile(0, 150),
                    const SizedBox(height: 4),
                    tile(2, 110),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  children: [
                    tile(1, 110),
                    const SizedBox(height: 4),
                    Stack(
                      children: [
                        tile(3, 150, more: true),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.grid_view_rounded,
                                    color: Colors.white, size: 24),
                                const SizedBox(height: 4),
                                Text(
                                  '+28',
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── POPULARITY ────────────────────────────────────────────────────────────

  Widget _buildPopularity(RankTheme theme) {
    return Column(
      children: [
        const CharSectionHeader(title: '🏆 Popularité & Fan du Mois'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SCORE DE POPULARITÉ',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    color: theme.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                _statBar('❤️', 'Likes', '38 247', 0.95, theme.accentColor,
                    theme),
                _statBar('💬', 'Commentaires', '4 892', 0.72,
                    const Color(0xFF3B82F6), theme),
                _statBar('🗳️', 'Votes Fan du Mois', '1 240', 0.81,
                    const Color(0xFF8B5CF6), theme),
                _statBar('🧠', 'Quiz réussis', '3 210', 0.65,
                    const Color(0xFF10B981), theme),
                const SizedBox(height: 14),
                Text(
                  'TOP 3 FANS CE MOIS-CI',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    color: theme.textSecondary,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 4),
                _fanRow('🥇', 'Jean-Paul_Otaku', 'JONIN',
                    const Color(0xFF3B82F6), '4 820 pts', theme),
                _fanRow('🥈', 'Awa_Fan25', 'GENIN', const Color(0xFF5A5A6A),
                    '3 102 pts', theme),
                _fanRow('🥉', 'OtakuPro237', 'JONIN', const Color(0xFF3B82F6),
                    '2 874 pts', theme),
                const SizedBox(height: 14),
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.accentColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: theme.accentColor.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '🗳️ Voter pour ${c.name} ce mois-ci',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Votre vote rapporte 10 pts à votre score Fan',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 11, color: theme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── RATING ────────────────────────────────────────────────────────────────

  Widget _buildRatingCard(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundElevated,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ta note',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 13, color: theme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(5, (i) {
                      return GestureDetector(
                        onTap: () => setState(() => _userRating = i + 1),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Icon(
                            i < _userRating
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: i < _userRating
                                ? AppColors.warning
                                : const Color(0xFF4A4A5A),
                            size: 28,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_userRating / 5 — 2 847 notes',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 12, color: theme.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFFF6D1B)]),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warning.withValues(alpha: 0.4),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    c.rating.toStringAsFixed(1),
                    style: GoogleFonts.rajdhani(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/5',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 10, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SERIES & CREATOR ──────────────────────────────────────────────────────

  Widget _buildSeriesSection(RankTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CharSectionHeader(title: '📖 Série & Créateur'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A0A2E), Color(0xFF2D1B69)],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 22,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        c.animeName,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Shōnen · 2020 · 24 épisodes · Studio Lumen',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 11, color: theme.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        children: ['Shōnen', 'Action', 'Surnaturel']
                            .map((g) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.backgroundCard,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    g,
                                    style: GoogleFonts.nunitoSans(
                                        fontSize: 10,
                                        color: theme.textSecondary),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: theme.textSecondary, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            "✏️ CRÉATEUR DE L'ŒUVRE",
            style: GoogleFonts.nunitoSans(
              fontSize: 12,
              color: theme.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF3B82F6),
                      ),
                      child: Center(
                        child: Text(
                          'AG',
                          style: GoogleFonts.rajdhani(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -6,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFF8B5CF6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Mangaka',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akari Goro',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                      Text(
                        'Né en 1992 · Studio Lumen',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 12, color: theme.textSecondary),
                      ),
                      Text(
                        '2 œuvres publiées',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          color: theme.accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.accentColor),
                  ),
                  child: Text(
                    'Biblio →',
                    style: GoogleFonts.nunitoSans(
                      fontSize: 11,
                      color: theme.accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── OTHER CHARACTERS ──────────────────────────────────────────────────────

  Widget _buildOtherCharacters(RankTheme theme) {
    final others = [
      ('Yuto Akira', 'Protagoniste', const Color(0xFF3d0505),
          const Color(0xFF7c1515)),
      ('Mei Tsuki', 'Protagoniste', const Color(0xFF050520),
          const Color(0xFF1a1a4a)),
      ('Nora Kishi', 'Protagoniste', const Color(0xFF201005),
          const Color(0xFF4a2a10)),
      ('Ryomen Void', 'Antagoniste', const Color(0xFF1a0000),
          const Color(0xFF3d0000)),
      ('Naoki Kento', 'Allié', const Color(0xFF0a1a0a),
          const Color(0xFF1a3020)),
    ];
    return Column(
      children: [
        const CharSectionHeader(
            title: 'Autres personnages', action: 'Voir tout →'),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: others.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final (name, role, c1, c2) = others[i];
              final isAntag = role == 'Antagoniste';
              return Container(
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c1, c2],
                  ),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.06)),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 30,
                      bottom: 40,
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isAntag ? AppColors.error : theme.accentColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          role.toUpperCase(),
                          style: GoogleFonts.nunitoSans(
                            fontSize: 8,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 60,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12)),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.85)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      right: 8,
                      bottom: 14,
                      child: Text(
                        name,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          shadows: const [
                            Shadow(color: Colors.black54, blurRadius: 4)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 4,
                      child: Text(
                        c.animeName
                            .substring(0, c.animeName.length.clamp(0, 8)),
                        style: GoogleFonts.nunitoSans(
                          fontSize: 9,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ── AI SECTION ────────────────────────────────────────────────────────────

  Widget _buildAISection(RankTheme theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CharSectionHeader(title: '🤖 Fonctionnalités IA'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Text(
            'Disponible pour les abonnés Jonin et Kage',
            style: GoogleFonts.nunitoSans(
              fontSize: 12,
              color: theme.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: CharAICard(
                    bg: const Color(0xFF1A1A2E),
                    border: const Color(0xFF3B82F6),
                    icon: '💬',
                    title: 'Parle à ${c.name}',
                    subtitle: 'Chatbot IA · Jonin+',
                    subtitleColor: const Color(0xFF3B82F6),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CharAICard(
                    bg: const Color(0xFF1A0A2E),
                    border: const Color(0xFF8B5CF6),
                    icon: '🧠',
                    title: 'Quiz · ${c.name}?',
                    subtitle: '5 questions · +5pts · Jonin+',
                    subtitleColor: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── COMMENTS ──────────────────────────────────────────────────────────────

  Widget _buildComments(RankTheme theme) {
    return Column(
      children: [
        const CharSectionHeader(
            title: '💬 Commentaires (4 892)', action: 'Voir tout →'),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'JP',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.backgroundPrimary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Ajouter un commentaire...',
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 14,
                                    color: theme.textSecondary),
                              ),
                            ),
                            Text(
                              'Envoyer',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 13,
                                color: theme.textSecondary
                                    .withValues(alpha: 0.5),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Commentaires modérés · ⚑ Signaler un contenu',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 11, color: theme.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const CharCommentCard(
          initials: 'JP',
          name: 'Jean-Paul_Otaku',
          tier: 'JONIN',
          tierColor: Color(0xFF3B82F6),
          time: 'il y a 2h',
          body: "Ce personnage est clairement le plus stylé de tout l'animé. Son design, ses pouvoirs, son attitude... PARFAIT. 🔥",
          likes: '247',
        ),
        const CharCommentCard(
          initials: 'AW',
          name: 'Awa_Fan',
          tier: 'GENIN',
          tierColor: Color(0xFF5A5A6A),
          time: 'il y a 5h',
          body: 'Même comme ça je reste fan numéro 1 ! 😭',
          likes: '89',
        ),
        const CharCommentCard(
          initials: 'OP',
          name: 'OtakuPro237',
          tier: 'JONIN',
          tierColor: Color(0xFF3B82F6),
          time: 'hier',
          body: 'La scène du Vide Illimité... incomparable.',
          likes: '156',
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Voir tous les commentaires (4 892)',
                style: GoogleFonts.nunitoSans(
                    fontSize: 14, color: theme.textPrimary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── FAB ───────────────────────────────────────────────────────────────────

  Widget _buildFAB(RankTheme theme) {
    return Positioned(
      right: 20,
      bottom: 80,
      child: GestureDetector(
        onTap: () => setState(() => _isCollected = !_isCollected),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.accentColor,
            boxShadow: [
              BoxShadow(
                color: theme.accentColor
                    .withValues(alpha: _isCollected ? 0.2 : 0.45),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            _isCollected
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────────────────────────────────

  Widget _statBar(String icon, String label, String value, double pct,
      Color color, RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$icon  $label',
                style: GoogleFonts.nunitoSans(
                    fontSize: 13, color: theme.textSecondary),
              ),
              Text(
                value,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: theme.backgroundPrimary,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fanRow(String medal, String name, String tier, Color tierColor,
      String pts, RankTheme theme) {
    final initials = name.split('_')[0].substring(0, 2).toUpperCase();
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          SizedBox(
              width: 28,
              child: Text(medal, style: const TextStyle(fontSize: 18))),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [Color(0xFFFF6D1B), Color(0xFF8B5CF6)]),
            ),
            child: Center(
              child: Text(
                initials,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ),
          ),
          CharPill(tier, bg: tierColor, fontSize: 9),
          const SizedBox(width: 8),
          Text(
            pts,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: theme.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
