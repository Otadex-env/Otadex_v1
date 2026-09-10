import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/character.dart';
import '../../../core/providers/anilist_providers.dart';
import '../../../core/subscription/rank_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/image_prefetcher.dart';
import '../../../core/widgets/otadex_image.dart';
import '../../../core/widgets/skeleton_loader.dart';

class CollectionScreen extends ConsumerWidget {
  const CollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionStreamProvider);
    // SOURCE UNIQUE du compteur (titre, bandeau, tout).
    final count = ref.watch(collectionCountProvider);
    final collectionLimit = ref.watch(effectiveRankProvider).collectionLimit;

    return collectionAsync.when(
      loading: () => const SkeletonList(count: 4),
      error: (_, __) => const Center(
        child: Text(
          'Erreur de chargement',
          style: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      data: (collectedIds) {
        if (collectedIds.isEmpty) {
          return const CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(),
              ),
            ],
          );
        }

        // Personnages résolus PAR ID — `charsAsync.length == count`.
        final charsAsync = ref.watch(collectedCharactersProvider);
        final showLimitBanner =
            collectionLimit != null && count >= collectionLimit - 2;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Ma Collection',
                  style: GoogleFonts.dmSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            if (showLimitBanner)
              SliverToBoxAdapter(
                child: _LimitBanner(count: count, limit: collectionLimit),
              ),
            SliverToBoxAdapter(child: _CollectionHeader(count: count)),
            charsAsync.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: SkeletonList(count: 3),
                ),
              ),
              error: (_, __) => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text('Erreur de chargement',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
              ),
              data: (characters) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) => _CharCard(character: characters[i]),
                    childCount: characters.length,
                  ),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 112 / 170,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bookmark_border_rounded,
              size: 64,
              color: AppColors.accent.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Ta collection est vide',
              style: GoogleFonts.dmSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore des personnages et collecte tes favoris !',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () => context.push('/search'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                ),
                child: Text(
                  'Explorer',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bandeau de limite — trois états distincts pilotés par le compteur unique :
///   • `count < limit - 2`   → non affiché (le parent ne le construit pas)
///   • `limit - 2 ≤ count < limit` → « Plus que X place(s) »
///   • `count >= limit`      → « Collection pleine (N/limit) » + comment débloquer
class _LimitBanner extends StatelessWidget {
  final int count;
  final int limit;
  const _LimitBanner({required this.count, required this.limit});

  @override
  Widget build(BuildContext context) {
    final full = count >= limit;
    final remaining = limit - count;
    final message = full
        ? '🔒 Collection pleine ($count/$limit) · passe Jonin pour une collection illimitée'
        : '⚠️ Plus que $remaining place${remaining > 1 ? 's' : ''} dans ta collection';
    final accent = full ? AppColors.error : AppColors.warning;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 4),
          TextButton(
            onPressed: () => context.push('/subscription'),
            style: TextButton.styleFrom(
              minimumSize: const Size(44, 44),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              foregroundColor: AppColors.accent,
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Voir',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionHeader extends StatelessWidget {
  final int count;
  const _CollectionHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        'Ma Collection ($count)',
        style: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _CharCard extends StatelessWidget {
  final Character character;
  const _CharCard({required this.character});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ImagePrefetcher.prefetchCharacterImages(context, character);
        context.push('/character/${character.id}', extra: character);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (character.imagePath != null)
              OtadexImage(
                imagePath: character.imagePath!,
                fit: BoxFit.cover,
              )
            else
              _GradientFallback(character: character),
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.cardShadowDeep,
                    ],
                    stops: [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 6,
              left: 6,
              right: 6,
              child: Text(
                character.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.nunitoSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientFallback extends StatelessWidget {
  final Character character;
  const _GradientFallback({required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [character.cardColor, character.accentColor],
        ),
      ),
      child: Center(
        child: Text(
          character.initials,
          style: GoogleFonts.rajdhani(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }
}
