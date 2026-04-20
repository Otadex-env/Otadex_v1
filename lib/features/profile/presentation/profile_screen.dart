import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/l10n/locale_provider.dart';
import 'widgets/avatar_picker.dart';
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

  static const _username = 'Jean-Paul_Otaku';
  static const _bio = 'Fan de Shonen depuis 2010 🏴';
  static const _collectCount = 67;
  static const _fanScore = 3847;
  static const _rankCount = 12;
  static const _progressPct = 0.78;
  static const _currentPts = 3847;
  static const _maxPts = 5000;

  static const _collectionItems = [
    ('Ronin Kage', Color(0xFF1565C0), Color(0xFF0D47A1), true),
    ('Sora Ken', Color(0xFF7B1FA2), Color(0xFF4A148C), false),
    ('Akira Void', Color(0xFF00695C), Color(0xFF004D40), false),
    ('Kira Sun', Color(0xFFE65100), Color(0xFFBF360C), false),
    ('Mika Rose', Color(0xFFAD1457), Color(0xFF880E4F), false),
    ('Zeno', Color(0xFF00838F), Color(0xFF006064), false),
  ];

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileHero(username: _username, bio: _bio),
          const SizedBox(height: 20),
          const ProfileStatRow(
            collectCount: _collectCount,
            fanScore: _fanScore,
            rankCount: _rankCount,
          ),
          const SizedBox(height: 20),
          ProfileTabBar(
            selectedTab: _selectedTab,
            onTabChanged: (i) => setState(() => _selectedTab = i),
          ),
          ProfileTabContent(
            selectedTab: _selectedTab,
            progressPct: _progressPct,
            currentPts: _currentPts,
            maxPts: _maxPts,
            collectCount: _collectCount,
            collectionItems: _collectionItems,
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
            onLanguageToggle: () {
              const langs = ['fr', 'en', 'ja', 'zh'];
              final idx = langs.indexOf(locale);
              ref.read(localeProvider.notifier).state =
                  langs[(idx + 1) % langs.length];
            },
          ),
          const SizedBox(height: 28),
          const ProfileLogoutFooter(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
