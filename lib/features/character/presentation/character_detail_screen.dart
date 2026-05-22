import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/character.dart';
import '../../../core/providers/anilist_providers.dart';
import '../../../core/providers/otadex_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/rank_theme.dart';
import '../../../core/utils/price_formatter.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/widgets/auth_gate_modal.dart';
import '../../../core/widgets/otadex_image.dart';
import '../../../core/widgets/subscription_modal.dart';
import 'widgets/char_circle_button.dart';
import 'widgets/char_pill.dart';

// ─── Tab identifiers ───────────────────────────────────────────────
enum _Tab { infos, galerie, relations, medias, exclusif }

// ─── Provider données enrichies AniList (utilisé dans INFOS, RELATIONS, MEDIAS)
final _charFullDataProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>?, int>((ref, id) async {
  return ref.read(anilistServiceProvider).getFullCharacterData(id);
});

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
  _Tab _activeTab = _Tab.infos;
  bool _isLiked = false;
  bool _aboutExpanded = false;

  // ── Hero animation ───────────────────────────────────────────────
  late final AnimationController _heroCtrl;
  late final Animation<double> _heroScale;
  late final Animation<double> _heroFade;

  Character get c => widget.character;

  List<String> get _effectiveImages {
    final local = AppAssets.getByCharacterId(c.id);
    if (local.isNotEmpty) return local;
    final customImages = c.images.where((url) => url.isNotEmpty).toList();
    if (customImages.isNotEmpty) return customImages;
    if (c.imagePath?.isNotEmpty == true) return [c.imagePath!];
    final storageAsync = ref.watch(characterImagesProvider({
      'anime': c.animeName,
      'character': c.name,
    }));
    if (storageAsync.hasValue && storageAsync.value!.isNotEmpty) {
      return storageAsync.value!;
    }
    return [];
  }

  // ── Computed stats ───────────────────────────────────────────────
  int get _collectionCount => (c.likes * 0.20).round();

  // ── AniList ID helper ────────────────────────────────────────────
  int? get _anilistId {
    if (c.id.startsWith('anilist-')) {
      return int.tryParse(c.id.replaceFirst('anilist-', ''));
    }
    return null;
  }

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

  void _showLocalQuoteImage() {
    final quote = c.quotes.isNotEmpty
        ? c.quotes.first
        : 'Continue d\'avancer, meme quand le monde devient flou.';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 4 / 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (c.imagePath != null)
                        OtadexImage(imagePath: c.imagePath!, fit: BoxFit.cover)
                      else
                        Container(color: AppColors.backgroundElevated),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.10),
                              Colors.black.withValues(alpha: 0.82),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        right: 18,
                        bottom: 18,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"$quote"',
                              style: GoogleFonts.rajdhani(
                                fontSize: 24,
                                height: 1.05,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              c.name,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                              ),
                            ),
                            Text(
                              'OTADEX Kage Studio · rendu local',
                              style: GoogleFonts.nunitoSans(
                                fontSize: 11,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Image citation generee localement',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Terminer',
                  style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                    child: _buildTabContent(theme, mq, profile.rank),
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
                    fontSize: _heroNameSize(MediaQuery.of(context)),
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

  Widget _buildTabContent(RankTheme theme, MediaQueryData mq, String rank) {
    final isTablet = mq.size.width >= 600;
    return switch (_activeTab) {
      _Tab.infos => _buildInfosTab(theme, isTablet, rank),
      _Tab.galerie => _buildGalerieTab(theme, isTablet, rank),
      _Tab.relations => _buildRelationsTab(theme),
      _Tab.medias => _buildMediasTab(theme),
      _Tab.exclusif => _buildExclusifTab(theme, rank),
    };
  }

  // ── INFOS TAB ────────────────────────────────────────────────────

  Widget _buildInfosTab(RankTheme theme, bool isTablet, String rank) {
    final isKage = rank == 'kage';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildIdentiteSection(theme),
        _buildAboutSection(theme),
        if (c.powers.isNotEmpty) _buildPowersSection(theme),
        if (c.quotes.isNotEmpty) _buildQuotesSection(theme),
        _buildVoiceActorsSection(theme),
        _buildTriviaSection(theme, isKage),
        _buildDiscoverCharactersSection(),
      ],
    );
  }

  Widget _buildIdentiteSection(RankTheme theme) {
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

  Widget _buildAboutSection(RankTheme theme) {
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

  Widget _buildPowersSection(RankTheme theme) {
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

  Widget _buildQuotesSection(RankTheme theme) {
    if (c.quotes.isEmpty) return const SizedBox.shrink();

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
          ...c.quotes.map((quote) => _buildQuoteCard(theme, quote)),
        ],
      ),
    );
  }

  Widget _buildQuoteCard(RankTheme theme, String quote) {
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

  Widget _buildVoiceActorsSection(RankTheme theme) {
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
          else if (_anilistId != null)
            _buildVoiceActorsList(theme)
          else
            Text(
              'Aucun doubleur disponible',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
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
          child: Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: va.imageUrl.isNotEmpty
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
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    va.nom,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    va.langue,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVoiceActorsList(RankTheme theme) {
    final anilistId = _anilistId!;
    final dataAsync = ref.watch(_charFullDataProvider(anilistId));
    return dataAsync.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(
              color: AppColors.accent, strokeWidth: 2),
        ),
      ),
      error: (_, __) => Text(
        'Aucun doubleur disponible',
        style: GoogleFonts.nunitoSans(
            fontSize: 13, color: AppColors.textSecondary),
      ),
      data: (data) {
        if (data == null) {
          return Text(
            'Aucun doubleur disponible',
            style: GoogleFonts.nunitoSans(
                fontSize: 13, color: AppColors.textSecondary),
          );
        }
        final edges = (data['media']?['edges'] as List<dynamic>?) ?? [];
        final voiceActors = <Map<String, dynamic>>[];
        for (final edge in edges) {
          final vas = (edge['voiceActors'] as List<dynamic>?) ?? [];
          for (final va in vas) {
            final vaMap = va as Map<String, dynamic>;
            final alreadyAdded = voiceActors.any((v) => v['id'] == vaMap['id']);
            if (!alreadyAdded) voiceActors.add(vaMap);
          }
        }
        if (voiceActors.isEmpty) {
          return Text(
            'Aucun doubleur disponible',
            style: GoogleFonts.nunitoSans(
                fontSize: 13, color: AppColors.textSecondary),
          );
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
                child: Row(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 48,
                        height: 48,
                        child: OtadexImage(
                          imagePath: img,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          lang,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTriviaSection(RankTheme theme, bool isKage) {
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
          if (!isKage)
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
                      Text(
                        '✦',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 16,
                          color: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          fact,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
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

  // ── DISCOVER CHARACTERS (bottom of Infos tab) ────────────────────

  Widget _buildDiscoverCharactersSection() {
    final allAsync = ref.watch(allCharactersProvider);
    return allAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (all) {
        final others = all.where((ch) => ch.id != c.id).take(6).toList();
        if (others.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 26, 16, 4),
              child: Text(
                '👥 Découvrir d\'autres personnages',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Touche un portrait pour ouvrir sa fiche',
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 168,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemCount: others.length + 1,
                itemBuilder: (ctx, index) {
                  if (index == others.length) {
                    return _buildVoirToutTile(all.length);
                  }
                  return _buildPortraitCard(others[index]);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildPortraitCard(Character char) {
    final imgPath = char.images.isNotEmpty
        ? char.images.first
        : char.imagePath ?? '';
    final hasImage = imgPath.isNotEmpty;

    return GestureDetector(
      onTap: () => context.push('/character/${char.id}', extra: char),
      child: Container(
        width: 124,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [char.cardColor, AppColors.backgroundDeep],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasImage)
              OtadexImage(imagePath: imgPath, fit: BoxFit.cover),
            // gradient overlay bottom
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.4, 1.0],
                  colors: [Colors.transparent, Color(0xD9000000)],
                ),
              ),
            ),
            // accent strip top-left
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: char.accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // name + anime
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    char.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  if (char.animeName.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      char.animeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 9,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoirToutTile(int total) {
    return GestureDetector(
      onTap: () => context.push('/search'),
      child: Container(
        width: 124,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.backgroundElevated,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  '→',
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Voir tout',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$total personnages',
              style: GoogleFonts.nunitoSans(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── GALERIE TAB ───────────────────────────────────────────────────

  Widget _buildGalerieTab(RankTheme theme, bool isTablet, String rank) {
    final crossAxis = isTablet ? 4 : 3;
    final images = _effectiveImages;
    final isGenin = rank == 'genin';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel(theme, 'GALERIE — ${images.length} PHOTOS'),
          if (isGenin) ...[
            const SizedBox(height: 6),
            Text(
              'Images avec filigrane OTADEX · Kage Pass pour télécharger sans',
              style: GoogleFonts.nunitoSans(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
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
          if (isGenin) ...[
            const SizedBox(height: 16),
            Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Publicité · Passe Jonin pour supprimer',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── RELATIONS TAB ─────────────────────────────────────────────────

  Widget _buildRelationsTab(RankTheme theme) {
    // Priorité aux mock relations
    if (c.relations.isNotEmpty) {
      return _buildMockRelations(theme);
    }

    if (_anilistId == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Relations à venir via AniList',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunitoSans(
                fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final anilistId = _anilistId!;
    final dataAsync = ref.watch(_charFullDataProvider(anilistId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _sectionLabel(theme, 'RELATIONS'),
          ),
          dataAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(
                    color: AppColors.accent, strokeWidth: 2),
              ),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Aucune relation connue',
                style: GoogleFonts.nunitoSans(
                    fontSize: 14, color: AppColors.textSecondary),
              ),
            ),
            data: (data) {
              if (data == null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Aucune relation connue',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 14, color: AppColors.textSecondary),
                  ),
                );
              }
              final edges =
                  (data['relations']?['edges'] as List<dynamic>?) ?? [];
              if (edges.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Aucune relation connue',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 14, color: AppColors.textSecondary),
                  ),
                );
              }
              return SizedBox(
                height: 170,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: edges.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final edge = edges[i] as Map<String, dynamic>;
                    final node = (edge['node'] as Map<String, dynamic>?) ?? {};
                    final relType = (edge['relationType'] as String?) ?? 'ALLY';
                    final name = (node['name']?['full'] as String?) ?? '—';
                    final img = (node['image']?['large'] as String?) ?? '';

                    final (badgeLabel, badgeColor) = switch (relType) {
                      'FRIEND' => ('Ami', AppColors.statGreen),
                      'RIVAL' => ('Rival', AppColors.warning),
                      'ENEMY' => ('Ennemi', AppColors.error),
                      'FAMILY' => ('Famille', AppColors.statBlue),
                      _ => ('Allié', AppColors.textSecondary),
                    };

                    return SizedBox(
                      width: 90,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.backgroundElevated,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: SizedBox(
                                width: 60,
                                height: 60,
                                child: OtadexImage(
                                  imagePath: img,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              name,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 11,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: badgeColor.withValues(alpha: 0.4),
                                    width: 0.8),
                              ),
                              child: Text(
                                badgeLabel,
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 9,
                                  color: badgeColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMockRelations(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _sectionLabel(theme, 'RELATIONS'),
          ),
          SizedBox(
            height: 170,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: c.relations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final rel = c.relations[i];
                final badgeColor = switch (rel.relationColor) {
                  'green' => AppColors.statGreen,
                  'blue' => AppColors.statBlue,
                  'red' => AppColors.error,
                  'amber' => AppColors.warning,
                  _ => AppColors.textSecondary,
                };
                return SizedBox(
                  width: 90,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: OtadexImage(
                              imagePath: rel.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          rel.nom,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 11,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: badgeColor.withValues(alpha: 0.4),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            rel.relationType,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 9,
                              color: badgeColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── MÉDIAS TAB ────────────────────────────────────────────────────

  Widget _buildSameAnimeSection(RankTheme theme) {
    final animeId = c.animeId;
    if (animeId == null || animeId.isEmpty) return const SizedBox.shrink();
    final sameAnimeAsync = ref.watch(sameAnimeCharactersProvider(
        {'animeId': animeId, 'excludeId': c.id}));
    return sameAnimeAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (chars) {
        if (chars.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Text(
                'Autres personnages de ${c.animeName}',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: chars.length,
                itemBuilder: (context, index) {
                  final char = chars[index];
                  final imgPath = char.images.isNotEmpty
                      ? char.images.first
                      : char.imagePath ?? '';
                  return GestureDetector(
                    onTap: () => context.push('/character/${char.id}',
                        extra: char),
                    child: SizedBox(
                      width: 120,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: OtadexImage(
                              imagePath: imgPath,
                              width: 120,
                              height: 152,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            char.name,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            char.role ?? '',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMediasTab(RankTheme theme) {
    // Priorité aux mock media appearances
    if (c.mediaAppearances.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMockMedias(theme),
          _buildSameAnimeSection(theme),
        ],
      );
    }

    if (_anilistId == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Médias à venir via AniList',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          _buildSameAnimeSection(theme),
        ],
      );
    }

    final anilistId = _anilistId!;
    final dataAsync = ref.watch(_charFullDataProvider(anilistId));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: dataAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(
                color: AppColors.accent, strokeWidth: 2),
          ),
        ),
        error: (_, __) => Text(
          'Médias non disponibles',
          style: GoogleFonts.nunitoSans(
              fontSize: 14, color: AppColors.textSecondary),
        ),
        data: (data) {
          if (data == null) {
            return Text(
              'Médias non disponibles',
              style: GoogleFonts.nunitoSans(
                  fontSize: 14, color: AppColors.textSecondary),
            );
          }
          final edges = (data['media']?['edges'] as List<dynamic>?) ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sous-section A — Animé/Manga
              Text(
                '📺 Apparitions',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ...edges.map((edge) {
                final edgeMap = edge as Map<String, dynamic>;
                final node = (edgeMap['node'] as Map<String, dynamic>?) ?? {};
                final role = (edgeMap['characterRole'] as String?) ?? '';
                final title = (node['title']?['french'] as String?) ??
                    (node['title']?['romaji'] as String?) ??
                    '—';
                final format = (node['format'] as String?) ?? '';
                final year = (node['seasonYear'] as int?)?.toString() ?? '';
                final episodes = (node['episodes'] as int?)?.toString() ?? '?';
                final cover = (node['coverImage']?['large'] as String?) ?? '';
                final mediaId = (node['id'] as int?);

                return GestureDetector(
                  onTap: mediaId != null
                      ? () => context.push('/anime/anilist-$mediaId')
                      : null,
                  child: Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: OtadexImage(
                              imagePath: cover,
                              fit: BoxFit.cover,
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
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$format · $year · $episodes éps',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.statBlue
                                      .withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  role,
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 10,
                                    color: AppColors.statBluePastel,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 16),

              // Sous-section B — Staff/Mangaka
              Text(
                '✍️ Auteurs',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ...edges.expand((edge) {
                final edgeMap = edge as Map<String, dynamic>;
                final node = (edgeMap['node'] as Map<String, dynamic>?) ?? {};
                final staffList =
                    (node['staff']?['nodes'] as List<dynamic>?) ?? [];
                return staffList.map((staff) {
                  final staffMap = staff as Map<String, dynamic>;
                  final name = (staffMap['name']?['full'] as String?) ?? '—';
                  final img = (staffMap['image']?['large'] as String?) ?? '';
                  final occupations =
                      (staffMap['primaryOccupations'] as List<dynamic>?)
                              ?.cast<String>() ??
                          [];
                  final occupation =
                      occupations.isNotEmpty ? occupations.first : '';
                  final staffId = (staffMap['id'] as int?);
                  return GestureDetector(
                    onTap: staffId != null
                        ? () => context.push('/creator/anilist-$staffId')
                        : null,
                    child: Container(
                      height: 72,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          ClipOval(
                            child: SizedBox(
                              width: 52,
                              height: 52,
                              child: OtadexImage(
                                imagePath: img,
                                fit: BoxFit.cover,
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
                                  name,
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  occupation,
                                  style: GoogleFonts.nunitoSans(
                                    fontSize: 12,
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
                });
              }),
              const SizedBox(height: 16),

              // Sous-section C — Studios
              Text(
                '🎬 Studios',
                style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              ...edges.expand((edge) {
                final edgeMap = edge as Map<String, dynamic>;
                final node = (edgeMap['node'] as Map<String, dynamic>?) ?? {};
                final studios =
                    (node['studios']?['nodes'] as List<dynamic>?) ?? [];
                return studios.map((studio) {
                  final studioMap = studio as Map<String, dynamic>;
                  final name = (studioMap['name'] as String?) ?? '—';
                  final studioId = (studioMap['id'] as int?);
                  return GestureDetector(
                    onTap: studioId != null
                        ? () => context.push('/studio/$studioId')
                        : null,
                    child: Container(
                      height: 64,
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.backgroundCard,
                            ),
                            child: const Center(
                              child: Text(
                                '🎬',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              name,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              }),
              _buildSameAnimeSection(theme),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMockMedias(RankTheme theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Apparitions animé/manga
          Text(
            '📺 Apparitions',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...c.mediaAppearances.map((m) {
            return Container(
              height: 80,
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: OtadexImage(
                        imagePath: m.coverUrl,
                        fit: BoxFit.cover,
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
                          m.titre,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${m.format} · ${m.annee} · ${m.episodes} éps',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.statBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            m.role,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10,
                              color: AppColors.statBluePastel,
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
          }),
          const SizedBox(height: 16),

          // Auteurs/Mangakas
          Text(
            '✍️ Auteurs',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...c.mediaAppearances.map((m) {
            return GestureDetector(
              onTap: () => context.push('/creator/${m.mangakaId}'),
              child: Container(
                height: 72,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundCard,
                      ),
                      child: Center(
                        child: Text(
                          m.mangakaNom.isNotEmpty
                              ? m.mangakaNom[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.rajdhani(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
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
                            m.mangakaNom,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Auteur',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 16),

          // Studios
          Text(
            '🎬 Studios',
            style: GoogleFonts.nunitoSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          ...c.mediaAppearances.map((m) {
            return GestureDetector(
              onTap: () => context.push('/studio/${m.studioId}'),
              child: Container(
                height: 64,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.backgroundCard,
                      ),
                      child: const Center(
                        child: Text('🎬', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        m.studioNom,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  // ── EXCLUSIF TAB ──────────────────────────────────────────────────

  Widget _buildExclusifTab(RankTheme theme, String rank) {
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
            _exclusifFeatureRow(
                Icons.quiz_rounded, 'Quiz & scoring Fan du Mois', 'Jonin+'),
            const SizedBox(height: 8),
            _exclusifFeatureRow(
                Icons.smart_toy_rounded, 'Chatbot IA personnage', 'Kage'),
            const SizedBox(height: 8),
            _exclusifFeatureRow(Icons.auto_awesome_rounded,
                'Génération d\'image citation', 'Kage'),
            const SizedBox(height: 8),
            _exclusifFeatureRow(
                Icons.bolt_rounded, 'Anecdotes exclusives', 'Kage'),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.statPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => context.push('/subscription'),
                child: Text(
                  'Obtenir Kage Pass 👑',
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ── Jonin : quiz accessible, chatbot+image verrouillés ───────────
    if (isJonin) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Column(
          children: [
            _buildQuizCard(),
            const SizedBox(height: 4),
            _buildUpsellBanner(
              feature: 'Discuter avec ${c.name} via IA',
              tierLabel: 'Kage Pass ($kageMonthly)',
              tierColor: AppColors.statPurple,
              onTap: () => context.push('/subscription'),
            ),
            _buildUpsellBanner(
              feature: 'Créer une image citation stylisée',
              tierLabel: 'Kage Pass',
              tierColor: AppColors.statPurple,
              onTap: () => context.push('/subscription'),
            ),
            _buildUpsellBanner(
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
          // Card 1 — Chatbot
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
                              ? OtadexImage(
                                  imagePath: c.imagePath!, fit: BoxFit.cover)
                              : Container(
                                  color: AppColors.backgroundElevated,
                                  child: Center(
                                    child: Text(
                                      c.name.isNotEmpty
                                          ? c.name[0].toUpperCase()
                                          : '?',
                                      style: GoogleFonts.rajdhani(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
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
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Assistant local · Sans Cloud Function',
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
                  const SizedBox(height: 16),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.statPurple, Color(0xFF6D28D9)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Démarrer la conversation 💬',
                        style: GoogleFonts.nunitoSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Card 2 — Génération image
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
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Génère une image stylisée avec une citation de ${c.name}',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _showLocalQuoteImage,
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
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Card 3 — Quiz
          _buildQuizCard(),
        ],
      ),
    );
  }

  Widget _exclusifFeatureRow(IconData icon, String label, String tier) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: (tier == 'Kage' ? AppColors.statPurple : AppColors.statBlue)
                .withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            tier,
            style: GoogleFonts.nunitoSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: tier == 'Kage' ? AppColors.statPurple : AppColors.statBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizCard() {
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
          border: Border.all(color: AppColors.statBlue.withValues(alpha: 0.4)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🧠 Quiz personnage',
              style: GoogleFonts.dmSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Teste tes connaissances sur ${c.name} — 5 questions',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
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
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── UPSELL BANNER ────────────────────────────────────────────────

  Widget _buildUpsellBanner({
    required String feature,
    required String tierLabel,
    required Color tierColor,
    required VoidCallback onTap,
  }) {
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
                  Text(
                    feature,
                    style: GoogleFonts.nunitoSans(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Disponible avec $tierLabel',
                    style: GoogleFonts.nunitoSans(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: tierColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Débloquer',
                style: GoogleFonts.nunitoSans(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
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
    final currency = ref.read(currencyProvider);
    final joninMonthly = PlanPrices.jonin(false, currency);
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
                child: Text(
                  'Devenir Jonin — $joninMonthly',
                  style: const TextStyle(
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
    (_Tab.infos, 'Infos'),
    (_Tab.galerie, 'Galerie'),
    (_Tab.relations, 'Relations'),
    (_Tab.medias, 'Médias'),
    (_Tab.exclusif, 'Exclusif 👑'),
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
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 11,
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
                            left: 4,
                            right: 4,
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
