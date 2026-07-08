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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _sectionLabel(theme, 'RELATIONS'),
          ),
          dataAsync.when(
            loading: () => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: shimmerBox(height: 160, radius: 12),
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
                height: 175,
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _sectionLabel(theme, 'RELATIONS'),
          ),
          SizedBox(
            height: 175,
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

  String get _initials {
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return name.isEmpty ? '?' : name.substring(0, name.length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.isNotEmpty;

    return SizedBox(
      width: 110,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image pleine ou fond gradient avec initiales
            if (hasImage)
              OtadexImage(imagePath: imageUrl, fit: BoxFit.cover)
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      badgeColor.withValues(alpha: 0.45),
                      badgeColor.withValues(alpha: 0.15),
                    ],
                  ),
                ),
                child: Center(
                  child: Text(
                    _initials,
                    style: GoogleFonts.rajdhani(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: badgeColor.withValues(alpha: 0.85),
                    ),
                  ),
                ),
              ),

            // Gradient scrim bas pour lisibilité du texte
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 80,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundDeep,
                    ],
                    stops: [0.0, 0.85],
                  ),
                ),
              ),
            ),

            // Nom + badge en bas
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.15,
                      shadows: const [
                        Shadow(color: Colors.black54, blurRadius: 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: badgeColor.withValues(alpha: 0.55), width: 0.8),
                    ),
                    child: Text(
                      badgeLabel,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 9,
                        color: badgeColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
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
  }
}
