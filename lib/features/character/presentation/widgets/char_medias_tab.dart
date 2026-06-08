import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/models/character.dart';
import '../../../../core/providers/anilist_providers.dart';
import '../../../../core/providers/otadex_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/otadex_image.dart';
import '../../../../core/widgets/skeleton_loader.dart';

class CharDetailMediasTab extends ConsumerWidget {
  final Character character;
  final int? anilistId;

  const CharDetailMediasTab({
    super.key,
    required this.character,
    required this.anilistId,
  });

  Character get c => character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (c.mediaAppearances.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMockMedias(context),
          _buildSameAnimeSection(context, ref),
        ],
      );
    }

    if (anilistId == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFirestoreAnimeContent(context, ref),
          _buildSameAnimeSection(context, ref),
          const SizedBox(height: 16),
        ],
      );
    }

    final dataAsync = ref.watch(charFullDataProvider(anilistId!));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: dataAsync.when(
        loading: () => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: shimmerBox(height: 80, radius: 12),
        ),
        error: (_, __) => Text('Médias non disponibles',
            style: GoogleFonts.nunitoSans(
                fontSize: 14, color: AppColors.textSecondary)),
        data: (data) {
          if (data == null) {
            return Text('Médias non disponibles',
                style: GoogleFonts.nunitoSans(
                    fontSize: 14, color: AppColors.textSecondary));
          }
          final edges = (data['media']?['edges'] as List<dynamic>?) ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Apparitions
              Text('📺 Apparitions',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              ...edges.map((edge) {
                final edgeMap = edge as Map<String, dynamic>;
                final node =
                    (edgeMap['node'] as Map<String, dynamic>?) ?? {};
                final role =
                    (edgeMap['characterRole'] as String?) ?? '';
                final title =
                    (node['title']?['french'] as String?) ??
                        (node['title']?['romaji'] as String?) ??
                        '—';
                final format = (node['format'] as String?) ?? '';
                final year =
                    (node['seasonYear'] as int?)?.toString() ?? '';
                final episodes =
                    (node['episodes'] as int?)?.toString() ?? '?';
                final cover =
                    (node['coverImage']?['large'] as String?) ?? '';
                final mediaId = (node['id'] as int?);

                return GestureDetector(
                  onTap: mediaId != null
                      ? () => context.push('/anime/anilist-$mediaId')
                      : null,
                  child: _MediaRow(
                    imageUrl: cover,
                    title: title,
                    subtitle: '$format · $year · $episodes éps',
                    badgeText: role,
                    imageIsRound: false,
                    height: 80,
                    imageSize: 60,
                  ),
                );
              }),
              const SizedBox(height: 16),
              // Auteurs
              Text('✍️ Auteurs',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              ...edges.expand((edge) {
                final edgeMap = edge as Map<String, dynamic>;
                final node =
                    (edgeMap['node'] as Map<String, dynamic>?) ?? {};
                final staffList =
                    (node['staff']?['nodes'] as List<dynamic>?) ?? [];
                return staffList.map((staff) {
                  final staffMap = staff as Map<String, dynamic>;
                  final name =
                      (staffMap['name']?['full'] as String?) ?? '—';
                  final img =
                      (staffMap['image']?['large'] as String?) ?? '';
                  final occupations =
                      (staffMap['primaryOccupations'] as List<dynamic>?)
                              ?.cast<String>() ??
                          [];
                  final occupation =
                      occupations.isNotEmpty ? occupations.first : '';
                  final staffId = (staffMap['id'] as int?);
                  return GestureDetector(
                    onTap: staffId != null
                        ? () =>
                            context.push('/creator/anilist-$staffId')
                        : null,
                    child: _MediaRow(
                      imageUrl: img,
                      title: name,
                      subtitle: occupation,
                      imageIsRound: true,
                      height: 72,
                      imageSize: 52,
                    ),
                  );
                });
              }),
              const SizedBox(height: 16),
              // Studios
              Text('🎬 Studios',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              ...edges.expand((edge) {
                final edgeMap = edge as Map<String, dynamic>;
                final node =
                    (edgeMap['node'] as Map<String, dynamic>?) ?? {};
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
                    child: _StudioRow(name: name),
                  );
                });
              }),
              _buildSameAnimeSection(context, ref),
            ],
          );
        },
      ),
    );
  }

  // ── Section "Même anime" ──────────────────────────────────────────

  Widget _buildSameAnimeSection(BuildContext context, WidgetRef ref) {
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
                  final charLocalImgs =
                      AppAssets.getByCharacterId(char.id);
                  final imgPath = charLocalImgs.isNotEmpty
                      ? charLocalImgs.first
                      : char.images.isNotEmpty
                          ? char.images.first
                          : char.imagePath ?? '';
                  return GestureDetector(
                    onTap: () => context.push(
                        '/character/${char.id}',
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
                                color: AppColors.textSecondary),
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

  // ── Firestore anime + créateur (quand pas d'AniList) ─────────────

  Widget _buildFirestoreAnimeContent(BuildContext context, WidgetRef ref) {
    final animesAsync = ref.watch(allAnimesProvider);
    final creatorsAsync = ref.watch(allCreatorsProvider);

    return animesAsync.when(
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: shimmerBox(height: 80, radius: 12),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (animes) {
        final anime = animes
            .where((a) => a.id == c.animeId || a.name == c.animeName)
            .firstOrNull;

        if (anime == null) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Informations média non disponibles',
                style: GoogleFonts.nunitoSans(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
            ),
          );
        }

        final allCreators = creatorsAsync.valueOrNull ?? [];
        final creator = anime.creatorId != null
            ? allCreators
                .where((cr) => cr.id == anime.creatorId)
                .firstOrNull
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text('📺 Animé',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ),
            GestureDetector(
              onTap: () => context.push('/anime/${anime.id}'),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [anime.cardColor, anime.accentColor],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          anime.name.isNotEmpty
                              ? anime.name[0].toUpperCase()
                              : '?',
                          style: GoogleFonts.rajdhani(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(anime.name,
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          if (anime.year > 0 ||
                              anime.studio.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              [
                                if (anime.year > 0) '${anime.year}',
                                if (anime.studio.isNotEmpty) anime.studio,
                              ].join(' · '),
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 12,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                          if (anime.episodes > 0) ...[
                            const SizedBox(height: 2),
                            Text(
                              '${anime.episodes} épisodes · ${anime.status}',
                              style: GoogleFonts.nunitoSans(
                                  fontSize: 11,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                          if (anime.genres.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: anime.genres
                                  .take(4)
                                  .map((g) => Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: anime.accentColor
                                              .withValues(alpha: 0.15),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(g,
                                            style: GoogleFonts.nunitoSans(
                                                fontSize: 10,
                                                color: anime.accentColor,
                                                fontWeight:
                                                    FontWeight.w600)),
                                      ))
                                  .toList(),
                            ),
                          ],
                          if (anime.synopsis.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(anime.synopsis,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                    height: 1.4)),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right_rounded,
                        color: AppColors.textSecondary, size: 18),
                  ],
                ),
              ),
            ),
            if (creator != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Text('✍️ Créateur',
                    style: GoogleFonts.nunitoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ),
              GestureDetector(
                onTap: () => context.push('/creator/${creator.id}'),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundElevated,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color:
                              anime.accentColor.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            creator.initials.isNotEmpty
                                ? creator.initials
                                : creator.name[0].toUpperCase(),
                            style: GoogleFonts.rajdhani(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: anime.accentColor),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(creator.name,
                                style: GoogleFonts.nunitoSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary)),
                            if (creator.role.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(creator.role,
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 12,
                                      color: anime.accentColor)),
                            ],
                            if (creator.nationality != null &&
                                creator.nationality!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(creator.nationality!,
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                            ],
                            if (creator.bio != null &&
                                creator.bio!.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Text(creator.bio!,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.nunitoSans(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      height: 1.4)),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.textSecondary, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // ── Mock médias (données Firestore locales) ───────────────────────

  Widget _buildMockMedias(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('📺 Apparitions',
              style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...c.mediaAppearances.map((m) => _MediaRow(
                imageUrl: m.coverUrl,
                title: m.titre,
                subtitle: '${m.format} · ${m.annee} · ${m.episodes} éps',
                badgeText: m.role,
                imageIsRound: false,
                height: 80,
                imageSize: 60,
              )),
          const SizedBox(height: 16),
          Text('✍️ Auteurs',
              style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...c.mediaAppearances.map((m) => GestureDetector(
                onTap: () => context.push('/creator/${m.mangakaId}'),
                child: _MediaRow(
                  imageUrl: '',
                  title: m.mangakaNom,
                  subtitle: 'Auteur',
                  imageIsRound: true,
                  height: 72,
                  imageSize: 52,
                  showChevron: true,
                  fallbackInitial:
                      m.mangakaNom.isNotEmpty ? m.mangakaNom[0] : '?',
                ),
              )),
          const SizedBox(height: 16),
          Text('🎬 Studios',
              style: GoogleFonts.nunitoSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 10),
          ...c.mediaAppearances.map((m) => GestureDetector(
                onTap: () => context.push('/studio/${m.studioId}'),
                child: _StudioRow(name: m.studioNom),
              )),
        ],
      ),
    );
  }
}

// ── Sous-widgets partagés ─────────────────────────────────────────────────────

class _MediaRow extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String? badgeText;
  final bool imageIsRound;
  final double height;
  final double imageSize;
  final bool showChevron;
  final String? fallbackInitial;

  const _MediaRow({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.imageIsRound,
    required this.height,
    required this.imageSize,
    this.showChevron = false,
    this.fallbackInitial,
  });

  @override
  Widget build(BuildContext context) {
    final img = imageUrl.isNotEmpty
        ? OtadexImage(imagePath: imageUrl, fit: BoxFit.cover)
        : (fallbackInitial != null
            ? Container(
                color: AppColors.backgroundCard,
                child: Center(
                  child: Text(
                    fallbackInitial!.toUpperCase(),
                    style: GoogleFonts.rajdhani(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textSecondary),
                  ),
                ),
              )
            : const SizedBox.shrink());

    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          imageIsRound
              ? ClipOval(
                  child: SizedBox(
                      width: imageSize, height: imageSize, child: img))
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                      width: imageSize, height: imageSize, child: img)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: GoogleFonts.nunitoSans(
                        fontSize: 12, color: AppColors.textSecondary)),
                if (badgeText != null && badgeText!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.statBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badgeText!,
                      style: GoogleFonts.nunitoSans(
                          fontSize: 10,
                          color: AppColors.statBluePastel,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showChevron)
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }
}

class _StudioRow extends StatelessWidget {
  final String name;
  const _StudioRow({required this.name});

  @override
  Widget build(BuildContext context) {
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
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: AppColors.backgroundCard),
            child: const Center(
                child: Text('🎬', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name,
                style: GoogleFonts.nunitoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
