import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/locale_provider.dart';
import '../../../core/providers/currency_provider.dart';
import '../../../core/providers/otadex_providers.dart';
import '../../../core/providers/user_profile_provider.dart';
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
          ProfileHero(
            username: profile.pseudo,
            bio: profile.bio.isEmpty ? 'Nouveau Genin' : profile.bio,
            avatarPath: profile.avatarUrl,
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
