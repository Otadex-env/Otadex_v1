import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/character.dart';
import '../../../core/providers/anilist_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/rank_theme.dart';
import '../../../core/widgets/auth_gate_modal.dart';
import '../../../core/widgets/otadex_image.dart';
import '../../../core/widgets/subscription_modal.dart';
import 'widgets/char_ai_card.dart';
import 'widgets/char_circle_button.dart';
import 'widgets/char_comment_card.dart';
import 'widgets/char_pill.dart';

// ─── Tab identifiers ───────────────────────────────────────────────
enum _Tab { profil, combat, galerie, fans }

class CharacterDetailScreen extends ConsumerStatefulWidget {
  final Character character;
  const CharacterDetailScreen({super.key, required this.character});

  @override
  ConsumerState<CharacterDetailScreen> createState() =>
      _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends ConsumerState<CharacterDetailScreen>
    with SingleTickerProviderStateMixin {
  // ── State ────────────────────────────────────────────────────────
  _Tab _activeTab = _Tab.profil;
  bool _isLiked = false;
  bool _aboutExpanded = false;
  int _userRating = 3;

  // ── Hero animation ───────────────────────────────────────────────
  late final AnimationController _heroCtrl;
  late final Animation<double> _heroScale;
  late final Animation<double> _heroFade;

  Character get c => widget.character;

  static const _kFallbackImages = [
    'assets/images/characters/satoru_gojo/gojo_01.jpg',
    'assets/images/characters/satoru_gojo/gojo_02.png',
    'assets/images/characters/satoru_gojo/gojo_03.png',
    'assets/images/characters/satoru_gojo/gojo_04_portrait.png',
    'assets/images/characters/satoru_gojo/gojo_05_portrait.png',
  ];

  List<String> get _effectiveImages {
    final storageAsync = ref.watch(characterImagesProvider({
      'anime': c.animeName,
      'character': c.name,
    }));
    if (storageAsync.hasValue && storageAsync.value!.isNotEmpty) {
      return storageAsync.value!;
    }
    if (c.images.isNotEmpty) return c.images;
    if (c.imagePath?.isNotEmpty == true) return [c.imagePath!];
    return _kFallbackImages;
  }

  // ── Computed stats ───────────────────────────────────────────────
  int get _commentCount => (c.likes * 0.30).round();
  int get _collectionCount => (c.likes * 0.20).round();
  int get _voteCount => (c.likes * 0.08).round();
  int get _quizCount => (c.likes * 0.35).round();
  int get _ratingCount => (c.likes * 0.40).round();

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _heroScale = Tween<double>(begin: 1.10, end: 1.0).animate(
      CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic),
    );
    _heroFade = CurvedAnimation(
      parent: _heroCtrl,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );
    _heroCtrl.forward();
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  void _guardAuth(VoidCallback action) {
    final isLoggedIn = ref.read(isLoggedInProvider);
    if (isLoggedIn) {
      action();
    } else {
      showAuthGateModal(context);
    }
  }

  void _guardJonin() {
    final isLoggedIn = ref.read(isLoggedInProvider);
    if (!isLoggedIn) {
      showAuthGateModal(context,
          message:
              'Connecte-toi pour accéder aux fonctionnalités premium Jonin+.');
    } else {
      showSubscriptionModal(context, SubscriptionPlan.jonin);
    }
  }

  String _formatLikes(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return n.toString();
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final mq = MediaQuery.of(context);
    final profile = ref.watch(userProfileProvider);
    final isCollected = ref.watch(isCollectedProvider(c.id));

    final collectionAsync = ref.watch(collectionStreamProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildHero(theme, mq)),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    activeTab: _activeTab,
                    onTap: (t) => setState(() => _activeTab = t),
                    theme: theme,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: mq.padding.bottom + 80),
                    child: _buildTabContent(theme, mq),
                  ),
                ),
              ],
            ),
            _buildFAB(theme, isCollected, collectionAsync, profile.rank),
          ],
        ),
      ),
    );
  }

  // ── HERO ─────────────────────────────────────────────────────────

  Widget _buildHero(RankTheme theme, MediaQueryData mq) {
    final heroH = (mq.size.height * 0.50).clamp(320.0, 520.0);
    return SizedBox(
      height: heroH,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Character-specific gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color.lerp(c.cardColor, Colors.black, 0.4) ?? c.cardColor,
                  Color.lerp(c.cardColor, c.accentColor, 0.5) ??
                      c.accentColor.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
          // Radial atmosphere glow
          Positioned(
            left: 0,
            right: 0,
            top: heroH * 0.1,
            child: Center(
              child: Container(
                width: heroH * 0.65,
                height: heroH * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      c.accentColor.withValues(alpha: 0.22),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Animated character image
          Positioned(
            left: 0,
            right: 0,
            top: mq.padding.top + 48,
            bottom: 90,
            child: _buildAnimatedImage(),
          ),
          // Bottom gradient fade into background
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: heroH * 0.52,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.backgroundPrimary.withValues(alpha: 0.75),
                      theme.backgroundPrimary,
                    ],
                    stops: const [0.0, 0.58, 1.0],
                  ),
                ),
              ),
            ),
          ),
          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  CharCircleButton(
                    onTap: () => context.pop(),
                    child: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const Spacer(),
                  // Share button top-right
                  CharCircleButton(
                    onTap: _guardJonin,
                    child: const Icon(Icons.ios_share_rounded,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
          ),
          // Bottom identity block
          Positioned(
            left: 20,
            right: 20,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Tier + category pills
                Wrap(
                  spacing: 6,
                  runSpacing: 5,
                  children: [
                    CharPill(
                      c.tier.name.toUpperCase(),
                      bg: c.accentColor.withValues(alpha: 0.22),
                      border: Border.all(color: c.accentColor),
                      color: Colors.white,
                    ),
                    CharPill(
                      c.category.toUpperCase(),
                      bg: Colors.white.withValues(alpha: 0.10),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35)),
                      color: Colors.white70,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  c.name.toUpperCase(),
                  style: GoogleFonts.rajdhani(
                    fontSize: _heroNameSize(mq),
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.8,
                    height: 1,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 12)
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  c.animeName,
                  style: GoogleFonts.nunitoSans(
                      fontSize: 13, color: Colors.white60),
                ),
                const SizedBox(height: 14),
                // Action row
                Row(
                  children: [
                    _actionChip(
                      icon: _isLiked
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      label: _isLiked
                          ? _formatLikes(c.likes + 1)
                          : _formatLikes(c.likes),
                      isActive: _isLiked,
                      activeColor: AppColors.error,
                      onTap: () => _guardAuth(
                          () => setState(() => _isLiked = !_isLiked)),
                    ),
                    const SizedBox(width: 8),
                    _actionChip(
                      icon: Icons.star_rounded,
                      label: c.rating.toStringAsFixed(1),
                    ),
                    const Spacer(),
                    Text(
                      '🎴 $_collectionCount collections',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 11, color: Colors.white54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _heroNameSize(MediaQueryData mq) {
    if (mq.size.width >= 600) return 38;
    if (mq.size.width >= 400) return 30;
    return 26;
  }

  Widget _buildAnimatedImage() {
    return AnimatedBuilder(
      animation: _heroCtrl,
      builder: (_, child) => FadeTransition(
        opacity: _heroFade,
        child: Transform.scale(
          scale: _heroScale.value,
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      ),
      child: c.imagePath != null
          ? OtadexImage(
              imagePath: c.imagePath!,
              fit: BoxFit.contain,
            )
          : _buildSilhouette(),
    );
  }

  Widget _buildSilhouette() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.12),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.25), width: 2),
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
        ],
      ),
    );
  }

  Widget _actionChip({
    required IconData icon,
    required String label,
    bool isActive = false,
    Color activeColor = Colors.white,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.20)
              : Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isActive
                ? activeColor.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: isActive ? activeColor : Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── TAB CONTENT ──────────────────────────────────────────────────

  Widget _buildTabContent(RankTheme theme, MediaQueryData mq) {
    final isTablet = mq.size.width >= 600;
    return switch (_activeTab) {
      _Tab.profil => _buildProfilTab(theme, isTablet),
      _Tab.combat => _buildCombatTab(theme, isTablet),
      _Tab.galerie => _buildGalerieTab(theme, isTablet),
      _Tab.fans => _buildFansTab(theme, isTablet),
    };
  }

  // ── PROFIL TAB ────────────────────────────────────────────────────

  Widget _buildProfilTab(RankTheme theme, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuickStats(theme, isTablet),
        _buildAbout(theme),
        _buildQuoteCard(theme),
        _buildSeriesSection(theme),
        _buildOtherCharacters(theme),
      ],
    );
  }

  Widget _buildQuickStats(RankTheme theme, bool isTablet) {
    final cells = [
      ('ÂGE', '28 ans', false),
      ('GENRE', 'Masculin ♂', false),
      ('NATIONALITÉ', '🇯🇵 Japonaise', false),
      ('STATUT', 'Actif', true),
    ];
    final crossAxis = isTablet ? 4 : 2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'INFORMATIONS'),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: crossAxis,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: isTablet ? 2.2 : 2.8,
            children: cells.map((cell) {
              final (label, value, dot) = cell;
              return Container(
                decoration: BoxDecoration(
                  color: theme.backgroundElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            value,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: theme.textPrimary,
                            ),
                          ),
                        ),
                        if (dot) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.statGreen,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.statGreen
                                      .withValues(alpha: 0.55),
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
        ],
      ),
    );
  }

  Widget _buildAbout(RankTheme theme) {
    const bio =
        'Considéré comme le sorcier le plus puissant de son époque, ce maître des arts occultes '
        'dirige la plus grande école de jujutsu. Il maîtrise une technique héréditaire unique qui '
        'rend son corps physiquement intouchable. Derrière son attitude désinvolte se cache une '
        'vision profonde : former une nouvelle génération de guerriers capables de faire face aux '
        'menaces les plus obscures.';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'BIOGRAPHIE'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bio,
                  maxLines: _aboutExpanded ? null : 4,
                  overflow: _aboutExpanded ? null : TextOverflow.ellipsis,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    color: theme.textSecondary,
                    height: 1.65,
                  ),
                ),
                const SizedBox(height: 10),
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
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'CITATION EMBLÉMATIQUE'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(14),
              border:
                  Border.all(color: theme.accentColor.withValues(alpha: 0.15)),
            ),
            padding: const EdgeInsets.all(18),
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
                      color: theme.accentColor.withValues(alpha: 0.16),
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
                        'Dans ce monde, le talent bat le travail acharné. '
                        'Et le talent né est battu par le talent éveillé.',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: theme.textPrimary,
                          height: 1.6,
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
                              color: theme.textSecondary, size: 14),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeriesSection(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'SÉRIE & CRÉATEUR'),
          const SizedBox(height: 10),
          // Series card
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        c.cardColor,
                        c.accentColor.withValues(alpha: 0.4)
                      ],
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 18,
                      height: 26,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(9),
                        color: Colors.white.withValues(alpha: 0.65),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        children: ['Action', 'Surnaturel', 'Shōnen']
                            .map((g) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.backgroundPrimary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(g,
                                      style: GoogleFonts.nunitoSans(
                                          fontSize: 10,
                                          color: theme.textSecondary)),
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
          const SizedBox(height: 10),
          // Creator card
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.statBlue,
                      ),
                      child: Center(
                        child: Text(
                          'AG',
                          style: GoogleFonts.rajdhani(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -5,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.statPurple,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Mangaka',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Akari Goro',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: theme.textPrimary,
                        ),
                      ),
                      Text(
                        'Né en 1992 · Studio Lumen · 2 œuvres',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 12, color: theme.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
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
        ],
      ),
    );
  }

  Widget _buildOtherCharacters(RankTheme theme) {
    final others = [
      (
        'Yuto Akira',
        'Protagoniste',
        const Color(0xFF3d0505),
        const Color(0xFF7c1515)
      ),
      (
        'Mei Tsuki',
        'Protagoniste',
        const Color(0xFF050520),
        const Color(0xFF1a1a4a)
      ),
      (
        'Nora Kishi',
        'Protagoniste',
        const Color(0xFF201005),
        const Color(0xFF4a2a10)
      ),
      (
        'Ryomen Void',
        'Antagoniste',
        const Color(0xFF1a0000),
        const Color(0xFF3d0000)
      ),
      (
        'Naoki Kento',
        'Allié',
        const Color(0xFF0a1a0a),
        const Color(0xFF1a3020)
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _sectionLabel(theme, 'AUTRES PERSONNAGES'),
          ),
          SizedBox(
            height: 168,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: others.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final (name, role, c1, c2) = others[i];
                final isAntag = role == 'Antagoniste';
                return Container(
                  width: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [c1, c2]),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.07)),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 22,
                        bottom: 38,
                        child: Center(
                          child: Container(
                            width: 34,
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(17),
                              color: Colors.white.withValues(alpha: 0.40),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 2),
                          decoration: BoxDecoration(
                            color:
                                isAntag ? AppColors.error : theme.accentColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            role.toUpperCase(),
                            style: GoogleFonts.nunitoSans(
                              fontSize: 7,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(14)),
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
                        bottom: 12,
                        child: Text(
                          name,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── COMBAT TAB ────────────────────────────────────────────────────

  Widget _buildCombatTab(RankTheme theme, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPowers(theme, isTablet),
        _buildAttributeRadar(theme),
        _buildRatingCard(theme),
      ],
    );
  }

  Widget _buildPowers(RankTheme theme, bool isTablet) {
    final powers = [
      ("L'Infini", AppColors.statPurple, AppColors.statPurplePastel),
      ('Vide Illimité', AppColors.statPurple, AppColors.statPurplePastel),
      ('Technique Inversée', AppColors.statGreen, AppColors.statGreenPastel),
      ('Domaine Expansif', AppColors.statBlue, AppColors.statBluePastel),
      ('Infini Pourpre', AppColors.error, AppColors.errorPastel),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'POUVOIRS & CAPACITÉS'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: powers.map((p) {
              final (name, border, textColor) = p;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: border.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: border.withValues(alpha: 0.55)),
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

  Widget _buildAttributeRadar(RankTheme theme) {
    final attrs = [
      ('Force', 0.75, AppColors.error),
      ('Vitesse', 0.90, AppColors.statBlue),
      ('Technique', 1.00, AppColors.statPurple),
      ('Endurance', 0.70, AppColors.statGreen),
      ('Intelligence', 0.95, AppColors.warning),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'ATTRIBUTS'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: attrs.map((a) {
                final (label, val, color) = a;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(label,
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 13, color: theme.textSecondary)),
                          Text(
                            '${(val * 100).round()}',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: theme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: val,
                          minHeight: 6,
                          backgroundColor: theme.backgroundPrimary,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingCard(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'NOTATION'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(18),
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
                      const SizedBox(height: 10),
                      Row(
                        children: List.generate(5, (i) {
                          return GestureDetector(
                            onTap: () => _guardAuth(
                                () => setState(() => _userRating = i + 1)),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(
                                i < _userRating
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                color: i < _userRating
                                    ? AppColors.warning
                                    : theme.borderSubtle,
                                size: 30,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$_userRating / 5 — $_ratingCount notes',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 12, color: theme.textSecondary),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                        colors: [AppColors.warning, AppColors.gradientOrange]),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.warning.withValues(alpha: 0.35),
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
                      Text('/5',
                          style: GoogleFonts.nunitoSans(
                              fontSize: 10, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── GALERIE TAB ───────────────────────────────────────────────────

  Widget _buildGalerieTab(RankTheme theme, bool isTablet) {
    final crossAxis = isTablet ? 4 : 3;
    final images = _effectiveImages;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'GALERIE — ${images.length} PHOTOS'),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 0.9,
            ),
            itemCount: images.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: () => context.push(
                '/gallery/${c.id}',
                extra: {'images': images, 'initialIndex': i},
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: OtadexImage(
                  imagePath: images[i],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FANS TAB ──────────────────────────────────────────────────────

  Widget _buildFansTab(RankTheme theme, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPopularity(theme),
        _buildAISection(theme),
        _buildComments(theme),
      ],
    );
  }

  Widget _buildPopularity(RankTheme theme) {
    final likePct = (c.likes / 100).clamp(0.0, 1.0);
    final commentPct = (_commentCount / 30.0).clamp(0.0, 1.0);
    final votePct = (_voteCount / 10.0).clamp(0.0, 1.0);
    final quizPct = (_quizCount / 35.0).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'POPULARITÉ'),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statBar('❤️', 'Likes', _formatLikes(c.likes), likePct,
                    theme.accentColor, theme),
                _statBar('💬', 'Commentaires', _commentCount.toString(),
                    commentPct, AppColors.statBlue, theme),
                _statBar('🗳️', 'Votes Fan du Mois', _voteCount.toString(),
                    votePct, AppColors.statPurple, theme),
                _statBar('🧠', 'Quiz réussis', _quizCount.toString(), quizPct,
                    AppColors.statGreen, theme),
                const SizedBox(height: 16),
                _sectionLabel(theme, 'TOP 3 FANS CE MOIS-CI'),
                const SizedBox(height: 8),
                _fanRow('🥇', 'Jean-Paul_Otaku', 'JONIN', AppColors.statBlue,
                    '482 pts', theme),
                _fanRow('🥈', 'Awa_Fan25', 'GENIN', AppColors.textMuted,
                    '310 pts', theme),
                _fanRow('🥉', 'OtakuPro237', 'JONIN', AppColors.statBlue,
                    '287 pts', theme),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => _guardAuth(() {}),
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.accentColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: theme.accentColor.withValues(alpha: 0.28),
                          blurRadius: 14,
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
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Ton vote rapporte 10 pts à ton score Fan',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 11, color: theme.textSecondary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAISection(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'FONCTIONNALITÉS IA — JONIN+'),
          const SizedBox(height: 12),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _guardJonin,
                    child: CharAICard(
                      bg: AppColors.backgroundAIBlue,
                      border: AppColors.statBlue,
                      icon: '💬',
                      title: 'Parle à ${c.name}',
                      subtitle: 'Chatbot IA · Jonin+',
                      subtitleColor: AppColors.statBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _guardJonin,
                    child: CharAICard(
                      bg: AppColors.backgroundAIPurple,
                      border: AppColors.statPurple,
                      icon: '🧠',
                      title: 'Quiz · ${c.name}?',
                      subtitle: '5 questions · +5pts',
                      subtitleColor: AppColors.statPurple,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComments(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionLabel(theme, 'COMMENTAIRES ($_commentCount)'),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Voir tout →',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    color: theme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Comment input
          Container(
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: [AppColors.statBlue, AppColors.statPurple]),
                  ),
                  child: Center(
                    child: Text('JP',
                        style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _guardAuth(() {}),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.backgroundPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Ajouter un commentaire...',
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 13, color: theme.textSecondary),
                            ),
                          ),
                          Icon(Icons.send_rounded,
                              size: 15,
                              color:
                                  theme.textSecondary.withValues(alpha: 0.4)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const CharCommentCard(
            initials: 'JP',
            name: 'Jean-Paul_Otaku',
            tier: 'JONIN',
            tierColor: AppColors.statBlue,
            time: 'il y a 2h',
            body:
                "Ce personnage est clairement le plus stylé de tout l'animé. Son design, ses pouvoirs, son attitude... PARFAIT. 🔥",
            likes: '24',
          ),
          const CharCommentCard(
            initials: 'AW',
            name: 'Awa_Fan',
            tier: 'GENIN',
            tierColor: AppColors.textMuted,
            time: 'il y a 5h',
            body: 'Même comme ça je reste fan numéro 1 ! 😭',
            likes: '9',
          ),
          const CharCommentCard(
            initials: 'OP',
            name: 'OtakuPro237',
            tier: 'JONIN',
            tierColor: AppColors.statBlue,
            time: 'hier',
            body: 'La scène du Vide Illimité... incomparable.',
            likes: '15',
          ),
          const SizedBox(height: 8),
          Container(
            height: 46,
            decoration: BoxDecoration(
              color: theme.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Voir tous les commentaires ($_commentCount)',
                style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    color: theme.accentColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FAB ───────────────────────────────────────────────────────────

  Widget _buildFAB(
    RankTheme theme,
    bool isCollected,
    AsyncValue<List<String>> collectionAsync,
    String rank,
  ) {
    return Positioned(
      right: 20,
      bottom: 24,
      child: GestureDetector(
        onTap: () {
          if (!ref.read(isLoggedInProvider)) {
            showAuthGateModal(context);
            return;
          }
          _handleCollectTap(isCollected, collectionAsync, rank);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCollected ? theme.accentColor : theme.backgroundElevated,
            border: Border.all(
              color:
                  theme.accentColor.withValues(alpha: isCollected ? 0.0 : 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.accentColor
                    .withValues(alpha: isCollected ? 0.35 : 0.12),
                blurRadius: 14,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            isCollected
                ? Icons.bookmark_rounded
                : Icons.bookmark_border_rounded,
            color: isCollected ? Colors.white : theme.accentColor,
            size: 22,
          ),
        ),
      ),
    );
  }

  Future<void> _handleCollectTap(
    bool isCollected,
    AsyncValue<List<String>> collectionAsync,
    String rank,
  ) async {
    final service = ref.read(collectionServiceProvider);

    if (isCollected) {
      await service.removeFromCollection(c.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Retiré de ta collection')),
        );
      }
      return;
    }

    final currentCount = collectionAsync.valueOrNull?.length ?? 0;
    final isGenin = rank == 'genin';

    try {
      await service.addToCollection(
        c.id,
        isGenin: isGenin,
        currentCount: currentCount,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${c.name} ajouté à ta collection !'),
            backgroundColor: AppColors.statGreen,
          ),
        );
      }
    } catch (e) {
      if (e == 'LIMIT_REACHED' && mounted) {
        _showLimitModal();
      }
    }
  }

  void _showLimitModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎴', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(
              'Collection complète !',
              style: GoogleFonts.dmSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu as atteint la limite de 10 personnages.\nPasse Jonin pour une collection illimitée.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  context.push('/subscription');
                },
                child: const Text(
                  'Devenir Jonin — 2 000 FCFA/mois',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Pas maintenant',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────────────────────────

  Widget _sectionLabel(RankTheme theme, String text) {
    return Text(
      text,
      style: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: theme.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _statBar(String icon, String label, String value, double pct,
      Color color, RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$icon  $label',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 13, color: theme.textSecondary)),
              Text(value,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: theme.textPrimary,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 5,
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
      height: 46,
      child: Row(
        children: [
          SizedBox(
              width: 28,
              child: Text(medal, style: const TextStyle(fontSize: 18))),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  colors: [AppColors.gradientOrange, AppColors.statPurple]),
            ),
            child: Center(
              child: Text(initials,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  )),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: theme.textPrimary,
                )),
          ),
          CharPill(tier, bg: tierColor, fontSize: 9),
          const SizedBox(width: 8),
          Text(pts,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: theme.accentColor,
              )),
        ],
      ),
    );
  }
}

// ─── Tab bar delegate ─────────────────────────────────────────────────────────

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final _Tab activeTab;
  final ValueChanged<_Tab> onTap;
  final RankTheme theme;

  const _TabBarDelegate({
    required this.activeTab,
    required this.onTap,
    required this.theme,
  });

  static const _tabs = [
    (_Tab.profil, 'Profil'),
    (_Tab.combat, 'Combat'),
    (_Tab.galerie, 'Galerie'),
    (_Tab.fans, 'Fans'),
  ];

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: theme.backgroundPrimary,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: _tabs.map((entry) {
                final (tab, label) = entry;
                final active = tab == activeTab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(tab),
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            label,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight:
                                  active ? FontWeight.w700 : FontWeight.w500,
                              color: active
                                  ? theme.accentColor
                                  : theme.textSecondary,
                            ),
                          ),
                        ),
                        if (active)
                          Positioned(
                            bottom: 0,
                            left: 12,
                            right: 12,
                            child: Container(
                              height: 2,
                              decoration: BoxDecoration(
                                color: theme.accentColor,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Divider(height: 1, thickness: 1, color: theme.backgroundElevated),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.activeTab != activeTab || old.onTap != onTap || old.theme != theme;
}
