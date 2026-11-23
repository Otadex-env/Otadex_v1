import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../../core/theme/otadex_theme.dart';

/// Barre de navigation flottante : une pilule arrondie détachée des bords,
/// dont l'onglet actif est signalé par un hexagone plein (clin d'œil à la
/// forme du logo), l'icône devenant pleine et le libellé restant visible.
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
    (icon: LucideIcons.house, active: LucideIcons.house, label: 'Accueil'),
    (icon: LucideIcons.search, active: LucideIcons.search, label: 'Recherche'),
    (
      icon: LucideIcons.libraryBig,
      active: LucideIcons.libraryBig,
      label: 'Collection'
    ),
    (icon: LucideIcons.user, active: LucideIcons.user, label: 'Profil'),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final scale = math.min(MediaQuery.textScalerOf(context).scale(1.0), 1.3);
    // Collée au bas de l'écran comme avant : seule la forme change (coins du
    // haut très arrondis, petite marge sur les côtés).
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border(top: BorderSide(color: theme.borderSubtle)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.45),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 70 * scale,
            child: Row(
              children: List.generate(_items.length, (i) {
                final isActive = i == currentIndex;
                final color = isActive ? Colors.white : theme.textSecondary;
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 46,
                            height: 46,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Hexagone : grossit depuis le centre quand
                                // l'onglet devient actif.
                                AnimatedScale(
                                  scale: isActive ? 1.0 : 0.4,
                                  duration: const Duration(milliseconds: 320),
                                  curve: Curves.easeOutBack,
                                  child: AnimatedOpacity(
                                    opacity: isActive ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: CustomPaint(
                                      size: const Size(46, 46),
                                      painter:
                                          _HexagonPainter(theme.accentColor),
                                    ),
                                  ),
                                ),
                                AnimatedScale(
                                  scale: isActive ? 1.0 : 0.92,
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOut,
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
                                      size: 25,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            style: GoogleFonts.nunitoSans(
                              fontSize: 10.5,
                              fontWeight:
                                  isActive ? FontWeight.w800 : FontWeight.w500,
                              color: isActive
                                  ? theme.accentColor
                                  : theme.textSecondary,
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
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

/// Hexagone régulier (pointe en haut) aux angles légèrement arrondis, avec une
/// lueur douce de la couleur d'accent.
class _HexagonPainter extends CustomPainter {
  final Color color;
  const _HexagonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    const round = 3.0; // épaisseur du trait qui arrondit les angles
    final c = Offset(size.width / 2, size.height / 2);
    final r = math.min(size.width, size.height) / 2 - round - 1;
    final path = Path();
    for (var k = 0; k < 6; k++) {
      final a = (-90 + 60 * k) * math.pi / 180;
      final p = Offset(c.dx + r * math.cos(a), c.dy + r * math.sin(a));
      k == 0 ? path.moveTo(p.dx, p.dy) : path.lineTo(p.dx, p.dy);
    }
    path.close();

    // Lueur
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withValues(alpha: 0.45)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    // Remplissage + contour arrondi
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = round * 2
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_HexagonPainter old) => old.color != color;
}
