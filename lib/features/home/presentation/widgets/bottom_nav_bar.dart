import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/otadex_theme.dart';

class OtadexBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const OtadexBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  // Icône contour au repos, icône pleine quand l'onglet est actif.
  static const _items = [
    (icon: Icons.home_outlined, active: Icons.home_rounded, label: 'Accueil'),
    (
      icon: Icons.search_rounded,
      active: Icons.manage_search_rounded,
      label: 'Recherche'
    ),
    (
      icon: Icons.collections_bookmark_outlined,
      active: Icons.collections_bookmark_rounded,
      label: 'Collection'
    ),
    (
      icon: Icons.person_outline_rounded,
      active: Icons.person_rounded,
      label: 'Profil'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: theme.borderSubtle, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 60),
          child: Row(
            children: List.generate(_items.length, (i) {
              final isActive = i == currentIndex;
              final color = isActive ? theme.accentColor : theme.textSecondary;
              return Expanded(
                child: Semantics(
                  button: true,
                  selected: isActive,
                  label: _items[i].label,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!isActive) HapticFeedback.selectionClick();
                      onTap(i);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Pastille qui s'étire derrière l'icône active.
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            width: isActive ? 52 : 32,
                            height: 30,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? theme.accentColor.withValues(alpha: 0.16)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: AnimatedScale(
                                scale: isActive ? 1.12 : 1.0,
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOutBack,
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 180),
                                  transitionBuilder: (child, anim) =>
                                      FadeTransition(
                                          opacity: anim, child: child),
                                  child: Icon(
                                    isActive
                                        ? _items[i].active
                                        : _items[i].icon,
                                    key: ValueKey(isActive),
                                    color: color,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.nunitoSans(
                              fontSize: 11,
                              fontWeight:
                                  isActive ? FontWeight.w800 : FontWeight.w500,
                              color: color,
                            ),
                            child: Text(
                              _items[i].label,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
