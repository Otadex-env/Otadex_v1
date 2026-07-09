import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/providers/otadex_providers.dart';
import '../../../core/models/user_rank.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/otadex_theme_wrapper.dart';
import '../../../core/theme/theme_mode_provider.dart';
import 'widgets/avatar_picker.dart';
import 'widgets/change_password_sheet.dart';
import 'widgets/edit_profile_sheet.dart';
import 'widgets/kage_banner.dart';
import 'widgets/plan_section.dart';
import 'widgets/profile_hero.dart';
import 'widgets/profile_logout_footer.dart';
import 'widgets/profile_stat_row.dart';
import 'widgets/profile_tab_bar.dart';
import 'widgets/profile_tab_content.dart';
import 'widgets/settings_section.dart';
import 'widgets/subscription_card.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _selectedTab = 0;
  bool _notificationsEnabled = true;
  bool _showKageBanner = true;
  String _billingCycle = 'mensuel';
  int _devTapCount = 0;

  void _showEditProfile() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditProfileSheet(),
    );
  }

  void _showChangePassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChangePasswordSheet(),
    );
  }

  Future<void> _selectCurrency(String currency) async {
    ref.read(currencyProvider.notifier).state = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyUserCurrency, currency);
  }

  // ── Menu développeur (kDebugMode + UID créateur uniquement) ───────────────

  void _onHeroTap() {
    if (!kDebugMode) return;
    final profile = ref.read(userProfileProvider);
    final uid = profile.id;
    final email = profile.email;
    if (!kDeveloperUids.contains(uid) && !kDeveloperEmails.contains(email)) return;
    _devTapCount++;
    if (_devTapCount >= 7) {
      _devTapCount = 0;
      _showDevMenu();
    }
  }

  void _showDevMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => Consumer(
        builder: (_, ref, __) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSubtle,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '🛠 Mode Développeur',
                  style: GoogleFonts.rajdhani(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tester l'UI selon le rang",
                  style: GoogleFonts.nunitoSans(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _devRankButton(ref, sheetCtx,
                        rank: UserRank.genin,
                        label: 'Genin',
                        color: AppColors.rankGenin,
                        bg: AppColors.rankGeninBg),
                    const SizedBox(width: 12),
                    _devRankButton(ref, sheetCtx,
                        rank: UserRank.jonin,
                        label: 'Jonin',
                        color: AppColors.rankJonin,
                        bg: AppColors.rankJoninBg),
                    const SizedBox(width: 12),
                    _devRankButton(ref, sheetCtx,
                        rank: UserRank.kage,
                        label: 'Kage',
                        color: AppColors.rankKage,
                        bg: AppColors.rankKageBg),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(devOverrideRankProvider.notifier).state = null;
                      ref
                          .read(userProfileProvider.notifier)
                          .updateIdentity(rank: UserRank.kage.name);
                      OtadexThemeWrapper.of(context)?.updateRank(UserRank.kage);
                      Navigator.of(sheetCtx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Mode dev : Kage réel restauré')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.borderSubtle),
                      foregroundColor: AppColors.textSecondary,
                    ),
                    child: Text(
                      'Réinitialiser (Kage réel)',
                      style: GoogleFonts.nunitoSans(fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _devRankButton(
    WidgetRef ref,
    BuildContext sheetCtx, {
    required UserRank rank,
    required String label,
    required Color color,
    required Color bg,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(devOverrideRankProvider.notifier).state = rank;
          ref
              .read(userProfileProvider.notifier)
              .updateIdentity(rank: rank.name);
          OtadexThemeWrapper.of(context)?.updateRank(rank);
          Navigator.of(sheetCtx).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Mode dev : affichage en ${rank.label}')),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.6), width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final currency = ref.watch(currencyProvider);
    final profile = ref.watch(userProfileProvider);
    final collectedIds = profile.collectedCharacterIds;
    final allCharsAsync = ref.watch(allCharactersProvider);
    final collectionItems = allCharsAsync.valueOrNull
            ?.where((c) => collectedIds.contains(c.id))
            .map((c) => (c.name, c.cardColor, c.accentColor, true))
            .toList() ??
        [];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: _onHeroTap,
            child: ProfileHero(
              username: profile.pseudo,
              bio: profile.bio.isEmpty ? 'Nouveau Genin' : profile.bio,
              avatarPath: profile.avatarUrl,
            ),
          ),
          const SizedBox(height: 20),
          ProfileStatRow(
            collectCount: collectedIds.length,
            fanScore: profile.fanScore,
            rankCount: profile.rankCount,
          ),
          const SizedBox(height: 20),
          ProfileTabBar(
            selectedTab: _selectedTab,
            onTabChanged: (i) => setState(() => _selectedTab = i),
          ),
          ProfileTabContent(
            selectedTab: _selectedTab,
            progressPct: profile.progressPct,
            currentPts: profile.currentPts,
            maxPts: profile.maxPts,
            collectCount: collectedIds.length,
            collectionItems: collectionItems,
            fanLevel: profile.fanLevel,
            fanLevelName: profile.fanLevelName,
          ),
          const SizedBox(height: 28),
          const AvatarPicker(),
          if (_showKageBanner) ...[
            const SizedBox(height: 20),
            KageBanner(
                onDismiss: () => setState(() => _showKageBanner = false)),
          ],
          const SizedBox(height: 24),
          const SubscriptionCard(),
          const SizedBox(height: 20),
          PlanSection(
            billingCycle: _billingCycle,
            onBillingChanged: (v) => setState(() => _billingCycle = v),
          ),
          const SizedBox(height: 28),
          SettingsSection(
            notificationsEnabled: _notificationsEnabled,
            onNotificationsChanged: (v) =>
                setState(() => _notificationsEnabled = v),
            currentLanguage: locale,
            onLanguageSelect: (lang) =>
                ref.read(localeProvider.notifier).state = lang,
            currentCurrency: currency,
            onCurrencySelect: _selectCurrency,
            isDarkMode: ref.watch(themeModeProvider) == ThemeMode.dark,
            onThemeToggle: () {
              final current = ref.read(themeModeProvider);
              ref.read(themeModeProvider.notifier).state =
                  current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
            },
            onEditProfile: _showEditProfile,
            onChangePassword: _showChangePassword,
            email: profile.email,
          ),
          const SizedBox(height: 28),
          const ProfileLogoutFooter(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
