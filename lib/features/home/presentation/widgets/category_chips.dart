import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/providers/otadex_providers.dart';
import '../../../../../core/theme/otadex_theme.dart';

/// Filtres de l'Accueil, sur deux rangées distinctes :
///   1. « Tous » + démographie (Shōnen, Seinen, Shōjo, Josei, Isekai) — pastilles pleines
///   2. genres principaux (Action, Aventure, …) — pastilles contour, plus petites
///
/// Le catalogue est fixe (`genre_catalog.dart`) ; seules les puces qui ramènent
/// au moins un personnage sont affichées (`genreChipsProvider`).
class CategoryChips extends ConsumerWidget {
  const CategoryChips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chips = ref.watch(genreChipsProvider).valueOrNull;
    final active = ref.watch(activeGenreProvider);
    void select(String? genre) =>
        ref.read(selectedGenreProvider.notifier).state = genre;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ChipRow(
          children: [
            _DemographicChip(
              label: 'Tous',
              selected: active == null,
              onTap: () => select(null),
            ),
            for (final g in chips?.demographics ?? const <String>[])
              _DemographicChip(
                label: g,
                selected: active == g,
                onTap: () => select(g),
              ),
          ],
        ),
        if (chips != null && chips.genres.isNotEmpty) ...[
          const SizedBox(height: 8),
          _ChipRow(
            children: [
              for (final g in chips.genres)
                _GenreChip(
                  label: g,
                  selected: active == g,
                  onTap: () => select(g),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Rangée défilante horizontalement, sans hauteur fixe : elle suit la police
/// système (voir textScaler borné dans app.dart).
class _ChipRow extends StatelessWidget {
  final List<Widget> children;
  const _ChipRow({required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: children),
    );
  }
}

class _DemographicChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DemographicChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? theme.accentColor : theme.backgroundCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: selected ? theme.accentColor : theme.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? Colors.white : theme.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _GenreChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _GenreChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? theme.accentColor.withValues(alpha: 0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? theme.accentColor : theme.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunitoSans(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? theme.accentColor : theme.textSecondary,
          ),
        ),
      ),
    );
  }
}
