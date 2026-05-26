import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/user_rank.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
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
import '../../collection/presentation/collection_screen.dart';
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
  late Stream<int> _unreadCountStream;

  @override
  void initState() {
    super.initState();
    _syncAuthState();
    _initUnreadStream();
  }

  void _initUnreadStream() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      _unreadCountStream = Stream.value(0);
      return;
    }
    _unreadCountStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  Future<void> _syncAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.keyIsLoggedIn) ?? false;
    if (mounted) {
      ref.read(isLoggedInProvider.notifier).state = isLoggedIn;
      if (isLoggedIn) {
        ref.read(userProfileProvider.notifier).updateIdentity(
              id: prefs.getString(AppConstants.keyUserId),
              pseudo: prefs.getString(AppConstants.keyUserPseudo),
              email: prefs.getString(AppConstants.keyUserEmail),
              rank: prefs.getString(AppConstants.keyUserRank),
            );
      }
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
    final profile = ref.watch(userProfileProvider);

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
                    child: StreamBuilder<int>(
                      stream: _unreadCountStream,
                      initialData: 0,
                      builder: (_, snap) => HomeAppBar(
                        rank: rank,
                        isLoggedIn: isLoggedIn,
                        pseudo: profile.pseudo,
                        unreadCount: isLoggedIn ? (snap.data ?? 0) : 0,
                        onLoginTap: () => showAuthGateModal(context),
                        onNotificationTap: () {
                          if (isLoggedIn) {
                            context.push('/notifications');
                          } else {
                            showAuthGateModal(context);
                          }
                        },
                        onProfileTap: () => setState(() => _navIndex = 3),
                      ),
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
              // Tab 2 — Collection
              const CollectionScreen(),
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
