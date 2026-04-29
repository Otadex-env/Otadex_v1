import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otadex/core/l10n/app_strings.dart';
import '../../../../../core/theme/otadex_theme.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  const SearchBarWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        color: theme.backgroundPrimary,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: theme.backgroundCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.borderSubtle),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.search_rounded, color: theme.textSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  s.placeholdertext1,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    color: theme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchBarSliverDelegate extends SliverPersistentHeaderDelegate {
  final double height;
  final VoidCallback? onTap;

  const SearchBarSliverDelegate({this.height = 64, this.onTap});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SearchBarWidget(onTap: onTap);
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SearchBarSliverDelegate oldDelegate) =>
      oldDelegate.onTap != onTap || oldDelegate.height != height;
}
