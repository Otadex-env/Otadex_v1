import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/otadex_theme.dart';

class CharTabDelegate extends SliverPersistentHeaderDelegate {
  final int activeTab;
  final ValueChanged<int> onTap;

  const CharTabDelegate({required this.activeTab, required this.onTap});

  static const _tabs = ['Infos', 'Galerie', 'Citations', 'Commentaires', 'IA'];

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = OtadexTheme.of(context);
    return Container(
      color: theme.backgroundCard,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final active = i == activeTab;
                final isAI = _tabs[i] == 'IA';
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            _tabs[i],
                            style: GoogleFonts.nunitoSans(
                              fontSize: 13,
                              fontWeight:
                                  active ? FontWeight.w600 : FontWeight.w500,
                              color: active
                                  ? theme.accentColor
                                  : theme.textSecondary,
                            ),
                          ),
                        ),
                        if (isAI)
                          Positioned(
                            top: 6,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3B82F6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Jonin+',
                                style: GoogleFonts.nunitoSans(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        if (active)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              height: 2,
                              color: theme.accentColor,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
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
  bool shouldRebuild(CharTabDelegate old) =>
      old.activeTab != activeTab || old.onTap != onTap;
}
