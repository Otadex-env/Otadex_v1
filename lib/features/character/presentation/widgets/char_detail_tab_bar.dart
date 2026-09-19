import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/rank_theme.dart';

enum CharDetailTab { infos, galerie, relations, medias, exclusif }

class CharDetailTabBar extends SliverPersistentHeaderDelegate {
  final CharDetailTab activeTab;
  final ValueChanged<CharDetailTab> onTap;
  final RankTheme theme;

  /// Hauteur de la barre d'état : la barre est épinglée en haut de l'écran
  /// (`pinned: true`), donc sans cet inset elle passe sous l'horloge / l'encoche
  /// dès que la page défile.
  final double topInset;

  const CharDetailTabBar({
    required this.activeTab,
    required this.onTap,
    required this.theme,
    this.topInset = 0,
  });

  static const double _barHeight = 48;

  static const _tabs = [
    (CharDetailTab.infos, 'Infos'),
    (CharDetailTab.galerie, 'Galerie'),
    (CharDetailTab.relations, 'Relations'),
    (CharDetailTab.medias, 'Médias'),
    (CharDetailTab.exclusif, 'Exclusif 👑'),
  ];

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: theme.backgroundPrimary,
      padding: EdgeInsets.only(top: topInset),
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
                          // scaleDown : un libellé plus large que son cinquième
                          // d'écran (petit écran + police agrandie) rétrécit au
                          // lieu de passer sur 2 lignes et de déborder.
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              label,
                              maxLines: 1,
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
  double get maxExtent => _barHeight + topInset;

  @override
  double get minExtent => _barHeight + topInset;

  @override
  bool shouldRebuild(CharDetailTabBar old) =>
      old.activeTab != activeTab ||
      old.onTap != onTap ||
      old.theme != theme ||
      old.topInset != topInset;
}
