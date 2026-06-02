import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/providers/otadex_providers.dart';
import '../../../../../core/theme/otadex_theme.dart';

const _kDefaultCategories = [
  'Tous', 'Shōnen', 'Seinen', 'Sport',
];

class CategoryChips extends ConsumerWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const CategoryChips({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = OtadexTheme.of(context);
    final categories =
        ref.watch(categoriesProvider).valueOrNull ?? _kDefaultCategories;

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (_, i) {
          final isSelected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.accentColor
                    : theme.backgroundCard,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isSelected ? theme.accentColor : theme.borderSubtle,
                  width: 1,
                ),
              ),
              child: Text(
                categories[i],
                style: GoogleFonts.nunitoSans(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : theme.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
