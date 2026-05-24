import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/anilist_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/skeleton_loader.dart';
import '../../../core/widgets/otadex_image.dart';

final _studioDataProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>?, String>((ref, id) async {
  final studioId = int.tryParse(id);
  if (studioId == null) return null;
  return AniListService().getStudioById(studioId);
});

class StudioScreen extends ConsumerWidget {
  final String studioId;
  const StudioScreen({super.key, required this.studioId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncData = ref.watch(_studioDataProvider(studioId));

    return asyncData.when(
      loading: () => Scaffold(
        backgroundColor: AppColors.backgroundDeep,
        body: SafeArea(
          child: Column(
            children: [
              _backButton(context),
              const Expanded(child: SkeletonScreen()),
            ],
          ),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: AppColors.backgroundDeep,
        body: SafeArea(
          child: Column(
            children: [
              _backButton(context),
              Expanded(
                child: Center(
                  child: Text(
                    'Studio introuvable',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 16, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (data) {
        if (data == null) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDeep,
            body: SafeArea(
              child: Column(
                children: [
                  _backButton(context),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Studio introuvable',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return _StudioContent(data: data);
      },
    );
  }

  static Widget _backButton(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: SafeArea(
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }
}

class _StudioContent extends StatelessWidget {
  final Map<String, dynamic> data;
  const _StudioContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final name = data['name'] as String? ?? 'Studio';
    final siteUrl = data['siteUrl'] as String?;
    final isAnim = data['isAnimationStudio'] as bool? ?? false;
    final mediaNodes =
        ((data['media']?['nodes']) as List<dynamic>?) ?? [];

    final initials = name.trim().split(' ').length >= 2
        ? '${name.trim().split(' ').first[0]}${name.trim().split(' ').last[0]}'.toUpperCase()
        : name.substring(0, name.length.clamp(0, 2)).toUpperCase();

    double avgScore = 0;
    int scoredCount = 0;
    for (final m in mediaNodes) {
      final s = (m as Map<String, dynamic>)['averageScore'] as int?;
      if (s != null && s > 0) {
        avgScore += s;
        scoredCount++;
      }
    }
    final displayScore = scoredCount > 0
        ? (avgScore / scoredCount / 10).toStringAsFixed(1)
        : '—';

    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: CustomScrollView(
        slivers: [
          // ── HEADER ───────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.backgroundCard, AppColors.backgroundDeep],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new,
                              color: AppColors.textPrimary, size: 20),
                          onPressed: () => context.pop(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withValues(alpha: 0.15),
                          border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              width: 2),
                        ),
                        child: Center(
                          child: Text(
                            initials,
                            style: GoogleFonts.rajdhani(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (isAnim) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.12),
                            border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.5)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Studio d'animation",
                            style: GoogleFonts.nunitoSans(
                                fontSize: 12, color: AppColors.accent),
                          ),
                        ),
                      ],
                      if (siteUrl != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          siteUrl,
                          style: GoogleFonts.nunitoSans(
                              fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── STATS ────────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _statCell('${mediaNodes.length}', 'Productions'),
                    _divider(),
                    _statCell('—', 'Fondé en'),
                    _divider(),
                    _statCell(displayScore, 'Score moyen'),
                  ],
                ),
              ),
            ),
          ),

          // ── SECTION HEADER ────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Filmographie complète',
                style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),

          // ── GRID ANIME ────────────────────────────────────────────────────────
          if (mediaNodes.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text('Aucune production disponible',
                    style: TextStyle(color: AppColors.textSecondary)),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) {
                    final m = mediaNodes[i] as Map<String, dynamic>;
                    final title =
                        m['title'] as Map<String, dynamic>?;
                    final displayTitle = (title?['french'] ??
                            title?['romaji'] ??
                            title?['english'] ??
                            'Inconnu') as String;
                    final cover =
                        m['coverImage']?['large'] as String?;
                    final year = m['seasonYear'] as int?;
                    final format = m['format'] as String?;
                    final score = m['averageScore'] as int?;
                    final animeId = m['id'] as int?;

                    return GestureDetector(
                      onTap: animeId != null
                          ? () => ctx.push('/anime/anilist-$animeId')
                          : null,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (cover != null)
                              OtadexImage(imagePath: cover, fit: BoxFit.cover)
                            else
                              Container(color: AppColors.backgroundCard),
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
                                    stops: [0.45, 1.0],
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
                                    displayTitle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.nunitoSans(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  if (year != null || format != null)
                                    Text(
                                      [
                                        if (year != null) '$year',
                                        if (format != null) format,
                                      ].join(' · '),
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  if (score != null && score > 0)
                                    Text(
                                      '⭐ ${(score / 10).toStringAsFixed(1)}',
                                      style: GoogleFonts.nunitoSans(
                                        fontSize: 11,
                                        color: AppColors.warning,
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
                  childCount: mediaNodes.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _statCell(String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.rajdhani(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 11, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: AppColors.borderSubtle,
    );
  }
}
