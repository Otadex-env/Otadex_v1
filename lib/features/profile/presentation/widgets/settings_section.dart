import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/services/url_launcher_service.dart';
import '../../../../core/theme/otadex_theme.dart';

class SettingsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final String currentLanguage;
  final ValueChanged<String> onLanguageSelect;
  final String currentCurrency;
  final ValueChanged<String> onCurrencySelect;
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final String email;

  const SettingsSection({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.currentLanguage,
    required this.onLanguageSelect,
    required this.currentCurrency,
    required this.onCurrencySelect,
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.email,
  });

  String _languageLabel(String currentLanguage) {
    return switch (currentLanguage) {
      'en' => 'English',
      'ja' => '日本語',
      'zh' => '中文',
      _ => 'Français',
    };
  }

  String _currencyLabel(String currency) {
    return switch (currency) {
      'USD' => 'USD · Dollar',
      'EUR' => 'EUR · Euro',
      'GBP' => 'GBP · Livre',
      'CAD' => 'CAD · Dollar canadien',
      'NGN' => 'NGN · Naira',
      _ => 'FCFA · XAF',
    };
  }

  Future<void> _copyEmail(BuildContext context, String email) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: email));
    messenger.showSnackBar(
      const SnackBar(content: Text('Email copié dans le presse-papiers')),
    );
  }

  Future<void> _showFeatureSheet(
    BuildContext context,
    String title,
    String description,
  ) async {
    final theme = OtadexTheme.of(context);
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: theme.backgroundCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: theme.borderSubtle)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.rajdhani(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: GoogleFonts.nunitoSans(
                fontSize: 14,
                color: theme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text('Fermer',
                    style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPrivacyPolicy() => UrlLauncherService.openPrivacyPolicy();

  Future<void> _openDeveloper() =>
      UrlLauncherService.openUrl('https://tilstack.me');

  Future<void> _openGithub() =>
      UrlLauncherService.openUrl('https://github.com/TilStack');

  Future<void> _openSupportPage() =>
      UrlLauncherService.openUrl('https://store.tilstack.me/');

  Future<void> _openKageTheme(BuildContext context, AppStrings s) async {
    await _showFeatureSheet(
      context,
      s.kageTheme,
      'Le thème Kage sera bientôt disponible pour les membres Premium. Restez à l’affût des prochaines mises à jour.',
    );
  }

  Future<void> _openHiddenCategories(BuildContext context, AppStrings s) async {
    await _showFeatureSheet(
      context,
      s.hiddenCategories,
      'Gérez bientôt vos catégories masquées directement depuis cette section.',
    );
  }

  Future<void> _openMyHistory(BuildContext context, AppStrings s) async {
    await _showFeatureSheet(
      context,
      s.myHistory,
      'Votre historique de progression sera bientôt visible ici.',
    );
  }

  Future<void> _openRateApp(BuildContext context, AppStrings s) =>
      UrlLauncherService.openUrl('https://store.tilstack.me/');

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'Support'),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            _SettingsRow(
              icon: '⭐',
              label: 'Noter l\'application',
              hasArrow: true,
              onTap: () => _openRateApp(context, s),
            ),
            const _SettingsDivider(),
            _SettingsRow(
              icon: '💛',
              label: 'Me soutenir',
              hasArrow: true,
              onTap: _openSupportPage,
            ),
          ]),
          const SizedBox(height: 24),
          _SectionLabel(label: s.accountSection),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            _SettingsRow(
                icon: '👤',
                label: s.editProfile,
                hasArrow: true,
                onTap: onEditProfile),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '🔒',
                label: s.changePassword,
                hasArrow: true,
                onTap: onChangePassword),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '✉️',
                label: s.emailLabel,
                value: email,
                hasArrow: true,
                onTap: () => _copyEmail(context, email)),
          ]),
          const SizedBox(height: 24),
          _SectionLabel(label: s.preferencesSection),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            _SettingsRow(
              icon: isDarkMode ? '🌙' : '☀️',
              label: s.theme,
              value: isDarkMode ? s.darkTheme : s.lightTheme,
              hasArrow: false,
              onTap: onThemeToggle,
            ),
            const _SettingsDivider(),
            _ToggleRow(
              icon: '🔔',
              label: s.notifications,
              value: notificationsEnabled,
              onChanged: onNotificationsChanged,
            ),
            const _SettingsDivider(),
            _SettingsRow(
              icon: '🌐',
              label: s.language,
              value: _languageLabel(currentLanguage),
              hasArrow: true,
              onTap: () => _showLanguageSheet(context, s),
            ),
            const _SettingsDivider(),
            _SettingsRow(
              icon: '💱',
              label: 'Monnaie',
              value: _currencyLabel(currentCurrency),
              hasArrow: true,
              onTap: () => _showCurrencySheet(context),
            ),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '🎨',
                label: s.kageTheme,
                value: s.locked,
                hasArrow: true,
                onTap: () => _openKageTheme(context, s)),
          ]),
          const SizedBox(height: 24),
          _SectionLabel(label: s.contentSection),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            _SettingsRow(
              icon: '📋',
              label: s.hiddenCategories,
              value: s.hiddenCount,
              hasArrow: true,
              onTap: () => _openHiddenCategories(context, s),
            ),
            const _SettingsDivider(),
            _SettingsRow(
              icon: '📊',
              label: s.myHistory,
              hasArrow: true,
              onTap: () => _openMyHistory(context, s),
            ),
          ]),
          const SizedBox(height: 24),
          _SectionLabel(label: s.aboutSection),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            const _SettingsRow(
                icon: 'ℹ️',
                label: 'Version',
                value: AppConstants.appVersion,
                hasArrow: false),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '👨‍💻',
                label: 'Développeur',
                value: 'TilStack',
                hasArrow: true,
                onTap: _openDeveloper),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '🐙',
                label: 'GitHub',
                value: 'TilStack',
                hasArrow: true,
                onTap: _openGithub),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '🔐',
                label: s.privacyPolicy,
                hasArrow: true,
                onTap: _openPrivacyPolicy),
          ]),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Fait avec ❤️ au Cameroun',
              style: GoogleFonts.nunitoSans(
                fontSize: 12,
                color: OtadexTheme.of(context).textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context, AppStrings s) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _LanguageSheet(
        currentLanguage: currentLanguage,
        onLanguageSelect: onLanguageSelect,
      ),
    );
  }

  void _showCurrencySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CurrencySheet(
        currentCurrency: currentCurrency,
        onCurrencySelect: onCurrencySelect,
      ),
    );
  }
}

class _LanguageSheet extends StatefulWidget {
  final String currentLanguage;
  final ValueChanged<String> onLanguageSelect;

  const _LanguageSheet({
    required this.currentLanguage,
    required this.onLanguageSelect,
  });

  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet> {
  late String _pending;

  static const _languages = [
    ('fr', 'Français', '🇫🇷'),
    ('en', 'English', '🇬🇧'),
    ('ja', '日本語', '🇯🇵'),
    ('zh', '中文', '🇨🇳'),
  ];

  @override
  void initState() {
    super.initState();
    _pending = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: theme.borderSubtle)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            s.selectLanguage,
            style: GoogleFonts.rajdhani(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ..._languages.map((lang) {
            final (code, name, flag) = lang;
            final isSelected = _pending == code;
            return GestureDetector(
              onTap: () => setState(() => _pending = code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.accentColor.withValues(alpha: 0.12)
                      : theme.backgroundElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? theme.accentColor : theme.borderSubtle,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? theme.accentColor
                              : theme.textPrimary,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle_rounded,
                          color: theme.accentColor, size: 20),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.textSecondary,
                    side: BorderSide(color: theme.borderDefault),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(s.cancel,
                      style:
                          GoogleFonts.nunitoSans(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onLanguageSelect(_pending);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(s.apply,
                      style:
                          GoogleFonts.nunitoSans(fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrencySheet extends StatefulWidget {
  final String currentCurrency;
  final ValueChanged<String> onCurrencySelect;

  const _CurrencySheet({
    required this.currentCurrency,
    required this.onCurrencySelect,
  });

  @override
  State<_CurrencySheet> createState() => _CurrencySheetState();
}

class _CurrencySheetState extends State<_CurrencySheet> {
  late String _pending;

  static const _currencies = [
    ('XAF', 'FCFA', 'Afrique centrale'),
    ('USD', 'Dollar américain', 'International'),
    ('EUR', 'Euro', 'Europe'),
    ('GBP', 'Livre sterling', 'Royaume-Uni'),
    ('CAD', 'Dollar canadien', 'Canada'),
    ('NGN', 'Naira', 'Nigeria'),
  ];

  @override
  void initState() {
    super.initState();
    _pending = widget.currentCurrency;
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: theme.borderSubtle)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.borderDefault,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Choisir la monnaie',
            style: GoogleFonts.rajdhani(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          ..._currencies.map((currency) {
            final (code, name, region) = currency;
            final isSelected = _pending == code;
            return GestureDetector(
              onTap: () => setState(() => _pending = code),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.accentColor.withValues(alpha: 0.12)
                      : theme.backgroundElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? theme.accentColor : theme.borderSubtle,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 44,
                      child: Text(
                        code,
                        style: GoogleFonts.rajdhani(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected
                              ? theme.accentColor
                              : theme.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? theme.accentColor
                                  : theme.textPrimary,
                            ),
                          ),
                          Text(
                            region,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 12,
                              color: theme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: theme.accentColor,
                        size: 20,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.textSecondary,
                    side: BorderSide(color: theme.borderDefault),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    s.cancel,
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onCurrencySelect(_pending);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.accentColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    s.apply,
                    style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Text(
      label,
      style: GoogleFonts.nunitoSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: theme.textSecondary,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.borderSubtle),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String icon;
  final String label;
  final String? value;
  final bool hasArrow;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    required this.hasArrow,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return InkWell(
      onTap: onTap ?? (hasArrow ? () {} : null),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.nunitoSans(
                    fontSize: 14, color: theme.textPrimary),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: GoogleFonts.nunitoSans(
                    fontSize: 13, color: theme.textSecondary),
              ),
              const SizedBox(width: 4),
            ],
            if (hasArrow)
              Icon(Icons.chevron_right_rounded,
                  color: theme.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.nunitoSans(
                  fontSize: 14, color: theme.textPrimary),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.white,
            activeTrackColor: theme.accentColor,
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: theme.borderDefault,
          ),
        ],
      ),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Divider(
        height: 1, thickness: 1, indent: 44, color: theme.borderSubtle);
  }
}
