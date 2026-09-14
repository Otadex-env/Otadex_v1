import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/models/character.dart';
import '../../../core/providers/anilist_providers.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/utils/format_likes.dart';
import '../../../core/widgets/auth_gate_modal.dart';
import '../../../core/widgets/otadex_image.dart';
import '../../../core/widgets/skeleton_loader.dart';
import 'widgets/char_detail_tab_bar.dart';
import 'widgets/char_exclusif_tab.dart';
import 'widgets/char_fab.dart';
import 'widgets/char_galerie_tab.dart';
import 'widgets/char_hero.dart';
import 'widgets/char_infos_tab.dart';
import 'widgets/char_medias_tab.dart';
import 'widgets/char_relations_tab.dart';

class CharacterDetailScreen extends ConsumerStatefulWidget {
  final String characterId;
  const CharacterDetailScreen({super.key, required this.characterId});

  @override
  ConsumerState<CharacterDetailScreen> createState() =>
      _CharacterDetailScreenState();
}

class _CharacterDetailScreenState
    extends ConsumerState<CharacterDetailScreen> {
  CharDetailTab _activeTab = CharDetailTab.infos;
  Character? _character;

  // Overrides optimistes pour le like — actifs uniquement pendant l'écriture
  // Firestore, effacés dès qu'elle réussit pour laisser la main aux
  // providers (isLikedProvider / likeCountProvider), source de vérité.
  bool? _isLikedOverride;
  int? _likeCountOverride;

  Character get c => _character!;

  List<String> get _effectiveImages {
    final firestoreImages = c.images.where((url) => url.isNotEmpty).toList();
    if (firestoreImages.isNotEmpty) return firestoreImages;
    final localImages = AppAssets.getByCharacterId(c.id);
    if (localImages.isNotEmpty) return localImages;
    if (c.imagePath?.isNotEmpty == true) return [c.imagePath!];
    return [];
  }

  int? get _anilistId {
    if (c.id.startsWith('anilist-')) {
      return int.tryParse(c.id.replaceFirst('anilist-', ''));
    }
    return null;
  }

  void _guardAuth(VoidCallback action) {
    if (ref.read(isLoggedInProvider)) {
      action();
    } else {
      showAuthGateModal(context);
    }
  }

  Future<void> _toggleLike() async {
    final charId = widget.characterId;
    final wasLiked =
        _isLikedOverride ?? ref.read(isLikedProvider(charId)).valueOrNull ?? false;
    final priorCount =
        _likeCountOverride ?? ref.read(likeCountProvider(charId)).valueOrNull ?? 0;
    final nextLiked = !wasLiked;

    setState(() {
      _isLikedOverride = nextLiked;
      _likeCountOverride =
          nextLiked ? priorCount + 1 : (priorCount - 1).clamp(0, 1 << 31);
    });

    try {
      final service = ref.read(likeServiceProvider);
      if (nextLiked) {
        await service.like(charId);
      } else {
        await service.unlike(charId);
      }
      ref.invalidate(isLikedProvider(charId));
      ref.invalidate(likeCountProvider(charId));
      if (mounted) {
        setState(() {
          _isLikedOverride = null;
          _likeCountOverride = null;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLikedOverride = wasLiked;
        _likeCountOverride = priorCount;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de liker ce personnage. Réessaie.'),
        ),
      );
    }
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
            border:
                Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
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
                        OtadexImage(
                            imagePath: c.imagePath!, fit: BoxFit.cover)
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
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Terminer',
                    style: GoogleFonts.nunitoSans(
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final characterAsync =
        ref.watch(characterDetailProvider(widget.characterId));
    return characterAsync.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.backgroundDeep,
        body: SkeletonScreen(),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: AppColors.backgroundDeep,
        body: Center(
          child: Text('Erreur de chargement',
              style: GoogleFonts.nunitoSans(
                  color: AppColors.textSecondary)),
        ),
      ),
      data: (character) {
        if (character == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDeep,
            body: Center(
              child: Text('Personnage introuvable',
                  style: GoogleFonts.nunitoSans(
                      color: AppColors.textSecondary)),
            ),
          );
        }
        _character = character;
        return _buildScaffold(context);
      },
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final mq = MediaQuery.of(context);

    final isLiked = _isLikedOverride ??
        ref.watch(isLikedProvider(widget.characterId)).valueOrNull ??
        false;
    final likeCount = _likeCountOverride ??
        ref.watch(likeCountProvider(widget.characterId)).valueOrNull ??
        0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: CharDetailHero(
                    character: c,
                    isLiked: isLiked,
                    images: _effectiveImages,
                    formattedLikes: formatLikes(likeCount),
                    onBack: () => context.pop(),
                    onToggleLike: () => _guardAuth(_toggleLike),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CharDetailTabBar(
                    activeTab: _activeTab,
                    onTap: (t) => setState(() => _activeTab = t),
                    theme: theme,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.only(bottom: mq.padding.bottom + 80),
                    child: _buildTabContent(theme, mq),
                  ),
                ),
              ],
            ),
            CharDetailFab(
              character: c,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(dynamic theme, MediaQueryData mq) {
    return switch (_activeTab) {
      CharDetailTab.infos => CharDetailInfosTab(
          character: c,
          anilistId: _anilistId,
        ),
      CharDetailTab.galerie => CharDetailGalerieTab(
          character: c,
          images: _effectiveImages,
        ),
      CharDetailTab.relations => CharDetailRelationsTab(
          character: c,
          anilistId: _anilistId,
        ),
      CharDetailTab.medias => CharDetailMediasTab(
          character: c,
          anilistId: _anilistId,
        ),
      CharDetailTab.exclusif => CharDetailExclusifTab(
          character: c,
          onShowQuoteImage: _showLocalQuoteImage,
        ),
    };
  }
}
