import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/user_rank.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/theme/otadex_theme.dart';
import '../../../core/widgets/auth_gate_modal.dart';
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

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _navIndex = 0;
  int _selectedCategory = 0;

  @override
  void initState() {
    super.initState();
    _syncAuthState();
  }

  Future<void> _syncAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      ref.read(isLoggedInProvider.notifier).state =
          prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    }
  }

  Future<void> _onNavTap(int index) async {
    if (index == 2 || index == 3) {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
      if (!isLoggedIn) {
        if (mounted) showAuthGateModal(context);
        return;
      }
    }
    if (mounted) setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final rank = OtadexTheme.rankOf(context);
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Container(
        decoration: BoxDecoration(gradient: theme.backgroundGradient),
        child: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _navIndex,
            children: [
              // Tab 0 — Accueil
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: HomeAppBar(
                      rank: rank,
                      isLoggedIn: isLoggedIn,
                      onLoginTap: () => showAuthGateModal(context),
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate: SearchBarSliverDelegate(
                      onTap: () => _onNavTap(1),
                    ),
                    pinned: true,
                  ),
                  const SliverToBoxAdapter(child: HeroFeaturedSlider()),
                  const SliverToBoxAdapter(child: TrendingSection()),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: CategoryChips(
                        selectedIndex: _selectedCategory,
                        onChanged: (i) => setState(() => _selectedCategory = i),
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
        ),
      ),
      bottomNavigationBar: OtadexBottomNavBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
