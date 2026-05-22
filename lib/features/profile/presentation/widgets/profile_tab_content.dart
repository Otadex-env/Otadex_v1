import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/otadex_theme.dart';

class ProfileTabContent extends StatelessWidget {
  final int selectedTab;
  final double progressPct;
  final int currentPts;
  final int maxPts;
  final int collectCount;
  final List<(String, Color, Color, bool)> collectionItems;
  final int fanLevel;
  final String fanLevelName;

  const ProfileTabContent({
    super.key,
    required this.selectedTab,
    required this.progressPct,
    required this.currentPts,
    required this.maxPts,
    required this.collectCount,
    required this.collectionItems,
    required this.fanLevel,
    required this.fanLevelName,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    if (selectedTab == 1) {
      return _EmptyTabContent(message: s.noBadgesYet);
    }
    if (selectedTab == 2) {
      return _EmptyTabContent(message: s.recentActivityHere);
    }
    return _CollectionTab(
      progressPct: progressPct,
      currentPts: currentPts,
      maxPts: maxPts,
      collectCount: collectCount,
      collectionItems: collectionItems,
      fanLevel: fanLevel,
      fanLevelName: fanLevelName,
    );
  }
}

class _CollectionTab extends StatelessWidget {
  final double progressPct;
  final int currentPts;
  final int maxPts;
  final int collectCount;
  final List<(String, Color, Color, bool)> collectionItems;
  final int fanLevel;
  final String fanLevelName;

  const _CollectionTab({
    required this.progressPct,
    required this.currentPts,
    required this.maxPts,
    required this.collectCount,
    required this.collectionItems,
    required this.fanLevel,
    required this.fanLevelName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ProgressCard(
          progressPct: progressPct,
          currentPts: currentPts,
          maxPts: maxPts,
          fanLevel: fanLevel,
          fanLevelName: fanLevelName,
        ),
        _CollectionHeader(collectCount: collectCount),
        _CollectionGrid(items: collectionItems),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final double progressPct;
  final int currentPts;
  final int maxPts;
  final int fanLevel;
  final String fanLevelName;

  const _ProgressCard({
    required this.progressPct,
    required this.currentPts,
    required this.maxPts,
    required this.fanLevel,
    required this.fanLevelName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$fanLevelName — ${s.level} $fanLevel 🔥',
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.textPrimary,
                ),
              ),
              Text(
                '${(progressPct * 100).toInt()}%',
                style: GoogleFonts.rajdhani(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: theme.accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progressPct,
              backgroundColor: theme.borderSubtle,
              valueColor: AlwaysStoppedAnimation(theme.accentColor),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$currentPts / $maxPts ${s.ptsForKageSupreme}',
            style:
                GoogleFonts.nunitoSans(fontSize: 11, color: theme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _CollectionHeader extends StatelessWidget {
  final int collectCount;
  const _CollectionHeader({required this.collectCount});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${s.myCollection} ($collectCount)',
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: [
                Icon(Icons.add_circle_outline_rounded,
                    color: theme.accentColor, size: 14),
                const SizedBox(width: 4),
                Text(
                  s.manage,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: theme.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  final List<(String, Color, Color, bool)> items;
  const _CollectionGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 12,
      crossAxisSpacing: 10,
      childAspectRatio: 0.74,
      children: items
          .map((item) => _CollectionCard(
                theme: theme,
                name: item.$1,
                c1: item.$2,
                c2: item.$3,
                selected: item.$4,
              ))
          .toList(),
    );
  }
}

class _CollectionCard extends StatelessWidget {
  final dynamic theme;
  final String name;
  final Color c1;
  final Color c2;
  final bool selected;

  const _CollectionCard({
    required this.theme,
    required this.name,
    required this.c1,
    required this.c2,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final t = OtadexTheme.of(context);
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c1, c2],
              ),
              border: selected ? Border.all(color: t.accentColor, width: 2) : null,
            ),
            child: selected
                ? Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          color: t.accentColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded,
                            color: Colors.white, size: 11),
                      ),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(fontSize: 10, color: t.textPrimary),
        ),
      ],
    );
  }
}

class _EmptyTabContent extends StatelessWidget {
  final String message;
  const _EmptyTabContent({required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Center(
        child: Text(
          message,
          style:
              GoogleFonts.nunitoSans(fontSize: 13, color: theme.textSecondary),
        ),
      ),
    );
  }
}
