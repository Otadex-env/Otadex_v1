import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/models/character.dart';
import '../../../../core/providers/anilist_providers.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';
import '../../../../core/widgets/otadex_image.dart';
import '../../../../core/widgets/skeleton_loader.dart';

class CharDetailRelationsTab extends ConsumerWidget {
  final Character character;
  final int? anilistId;

  const CharDetailRelationsTab({
    super.key,
    required this.character,
    required this.anilistId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = OtadexTheme.of(context);

    if (character.relations.isNotEmpty) {
      return _buildMockRelations(context, theme);
    }

    if (anilistId == null) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Text(
            'Aucune relation disponible pour ce personnage',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunitoSans(
                fontSize: 14, color: AppColors.textSecondary),
          ),
        ),
      );
    }

    final dataAsync = ref.watch(charFullDataProvider(anilistId!));

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
            loading: () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: shimmerBox(height: 80, radius: 12),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Aucune relation connue',
                  style: GoogleFonts.nunitoSans(
                      fontSize: 14, color: AppColors.textSecondary)),
            ),
            data: (data) {
              if (data == null) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Aucune relation connue',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 14, color: AppColors.textSecondary)),
                );
              }
              final edges =
                  (data['relations']?['edges'] as List<dynamic>?) ?? [];
              if (edges.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Aucune relation connue',
                      style: GoogleFonts.nunitoSans(
                          fontSize: 14, color: AppColors.textSecondary)),
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
                    final node =
                        (edge['node'] as Map<String, dynamic>?) ?? {};
                    final relType =
                        (edge['relationType'] as String?) ?? 'ALLY';
                    final name =
                        (node['name']?['full'] as String?) ?? '—';
                    final img =
                        (node['image']?['large'] as String?) ?? '';

                    final (badgeLabel, badgeColor) = switch (relType) {
                      'FRIEND' => ('Ami', AppColors.statGreen),
                      'RIVAL' => ('Rival', AppColors.warning),
                      'ENEMY' => ('Ennemi', AppColors.error),
                      'FAMILY' => ('Famille', AppColors.statBlue),
                      _ => ('Allié', AppColors.textSecondary),
                    };

                    return _RelationCard(
                      name: name,
                      imageUrl: img,
                      badgeLabel: badgeLabel,
                      badgeColor: badgeColor,
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

  Widget _buildMockRelations(BuildContext context, dynamic theme) {
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
              itemCount: character.relations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final rel = character.relations[i];
                final badgeColor = switch (rel.relationColor) {
                  'green' => AppColors.statGreen,
                  'blue' => AppColors.statBlue,
                  'red' => AppColors.error,
                  'amber' => AppColors.warning,
                  _ => AppColors.textSecondary,
                };
                final relLocalImgs = AppAssets.getByCharacterId(rel.id);
                final relImgPath =
                    relLocalImgs.isNotEmpty ? relLocalImgs.first : rel.imageUrl;

                return _RelationCard(
                  name: rel.nom,
                  imageUrl: relImgPath,
                  badgeLabel: rel.relationType,
                  badgeColor: badgeColor,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(dynamic theme, String text) {
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

class _RelationCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String badgeLabel;
  final Color badgeColor;

  const _RelationCard({
    required this.name,
    required this.imageUrl,
    required this.badgeLabel,
    required this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
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
                child: OtadexImage(imagePath: imageUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.nunitoSans(
                  fontSize: 11, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: badgeColor.withValues(alpha: 0.4), width: 0.8),
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
  }
}
