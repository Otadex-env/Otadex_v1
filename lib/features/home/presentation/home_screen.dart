import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/models/user_rank.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/theme/otadex_theme_wrapper.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/category_chips.dart';
import 'widgets/character_grid_section.dart';
import 'widgets/hero_featured_slider.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/trending_section.dart';
import 'widgets/upsell_banner.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../search/presentation/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  int _selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final rank = OtadexTheme.rankOf(context);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              IndexedStack(
                index: _navIndex,
                children: [
                  // Tab 0 — Accueil
                  CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(child: HomeAppBar(rank: rank)),
                      const SliverPersistentHeader(
                        delegate: SearchBarSliverDelegate(),
                        pinned: true,
                      ),
                      const SliverToBoxAdapter(child: HeroFeaturedSlider()),
                      const SliverToBoxAdapter(child: TrendingSection()),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: CategoryChips(
                            selectedIndex: _selectedCategory,
                            onChanged: (i) =>
                                setState(() => _selectedCategory = i),
                          ),
                        ),
                      ),
                      if (rank == UserRank.genin)
                        const SliverToBoxAdapter(child: UpsellBanner()),
                      SliverToBoxAdapter(
                        child: CharacterGridSection(
                          selectedCategoryIndex: _selectedCategory,
                        ),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 100)),
                    ],
                  ),
                  // Tab 1 — Recherche
                  const RechercheScreen(),
                  // Tab 2 — Collection (placeholder)
                  const Center(child: SizedBox.shrink()),
                  // Tab 3 — Profil
                  const ProfileScreen(),
                ],
              ),
              // Debug rank switcher (kDebugMode only)
              if (kDebugMode) _buildDebugRankButtons(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: OtadexBottomNavBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }

  Widget _buildDebugRankButtons(BuildContext context) {
    return const Positioned(
      bottom: 80,
      right: 16,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DebugRankButton(
            label: 'G',
            rank: UserRank.genin,
            color: AppColors.rankGenin,
          ),
          SizedBox(height: 8),
          _DebugRankButton(
            label: 'J',
            rank: UserRank.jonin,
            color: AppColors.rankJonin,
          ),
          SizedBox(height: 8),
          _DebugRankButton(
            label: 'K',
            rank: UserRank.kage,
            color: AppColors.rankKage,
          ),
        ],
      ),
    );
  }
}

class _DebugRankButton extends StatelessWidget {
  final String label;
  final UserRank rank;
  final Color color;

  const _DebugRankButton({
    required this.label,
    required this.rank,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => OtadexThemeWrapper.of(context)?.updateRank(rank),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
