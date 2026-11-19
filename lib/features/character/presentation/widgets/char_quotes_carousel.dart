import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/models/character.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/otadex_image.dart';
import 'char_section_header.dart';

/// Citations du personnage en carrousel : une carte à la fois, avec le portrait
/// en filigrane, plutôt qu'une pile de blocs de texte.
class CharQuotesCarousel extends StatefulWidget {
  final Character character;
  const CharQuotesCarousel({super.key, required this.character});

  @override
  State<CharQuotesCarousel> createState() => _CharQuotesCarouselState();
}

class _CharQuotesCarouselState extends State<CharQuotesCarousel> {
  late final PageController _controller;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    final single = widget.character.quotes.length <= 1;
    _controller = PageController(viewportFraction: single ? 1.0 : 0.9);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.character;
    final quotes = c.quotes;
    if (quotes.isEmpty) return const SizedBox.shrink();

    // Hauteur fixe (exigée par PageView) qui grandit avec la police système.
    final scale = math.min(1.4, MediaQuery.textScalerOf(context).scale(1.0));
    final height = 190.0 * math.max(1.0, scale);

    return Padding(
      padding: const EdgeInsets.only(top: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CharSectionHeader(
              icon: Icons.format_quote_rounded,
              title: 'Citations',
              accent: c.accentColor,
              count: quotes.length,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: height,
            child: PageView.builder(
              controller: _controller,
              itemCount: quotes.length,
              onPageChanged: (i) => setState(() => _page = i),
              padEnds: quotes.length <= 1,
              itemBuilder: (_, i) => Padding(
                padding: EdgeInsets.only(
                  left: quotes.length <= 1 ? 16 : (i == 0 ? 16 : 5),
                  right: quotes.length <= 1 ? 16 : 5,
                ),
                child: _QuoteCard(quote: quotes[i], character: c),
              ),
            ),
          ),
          if (quotes.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < quotes.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _page ? 18 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? c.accentColor
                            : AppColors.borderDefault,
                        borderRadius: BorderRadius.circular(3),
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

class _QuoteCard extends StatelessWidget {
  final String quote;
  final Character character;
  const _QuoteCard({required this.quote, required this.character});

  @override
  Widget build(BuildContext context) {
    final accent = character.accentColor;
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.30),
                  AppColors.backgroundElevated,
                ],
              ),
            ),
          ),
          // Portrait en filigrane, à droite.
          if (character.imagePath != null && character.imagePath!.isNotEmpty)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 150,
              child: ShaderMask(
                shaderCallback: (r) => const LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Colors.white, Colors.transparent],
                ).createShader(r),
                blendMode: BlendMode.dstIn,
                child: Opacity(
                  opacity: 0.35,
                  child: OtadexImage(
                    imagePath: character.imagePath!,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.format_quote_rounded,
                    size: 34, color: accent.withValues(alpha: 0.85)),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    quote,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunitoSans(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '— ${character.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rajdhani(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    color: accent,
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
