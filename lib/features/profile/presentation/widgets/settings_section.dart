import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/theme/otadex_theme.dart';

class SettingsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;
  final String currentLanguage;
  final VoidCallback onLanguageToggle;

  const SettingsSection({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
    required this.currentLanguage,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel(label: s.accountSection),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            _SettingsRow(icon: '👤', label: s.editProfile, hasArrow: true),
            const _SettingsDivider(),
            _SettingsRow(icon: '🔒', label: s.changePassword, hasArrow: true),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '✉️',
                label: s.email,
                value: 'jean@mail.com',
                hasArrow: true),
          ]),
          const SizedBox(height: 24),
          _SectionLabel(label: s.preferencesSection),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            _SettingsRow(
                icon: '🌙',
                label: s.theme,
                value: s.darkTheme,
                hasArrow: true),
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
              value: s.languageValue,
              hasArrow: true,
              onTap: onLanguageToggle,
            ),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '🎨',
                label: s.kageTheme,
                value: s.locked,
                hasArrow: true),
          ]),
          const SizedBox(height: 24),
          _SectionLabel(label: s.contentSection),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            _SettingsRow(
                icon: '📋',
                label: s.hiddenCategories,
                value: s.hiddenCount,
                hasArrow: true),
            const _SettingsDivider(),
            _SettingsRow(icon: '📊', label: s.myHistory, hasArrow: true),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '🧹',
                label: s.clearCache,
                value: s.cacheSize,
                hasArrow: true),
          ]),
          const SizedBox(height: 24),
          _SectionLabel(label: s.aboutSection),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            _SettingsRow(
                icon: 'ℹ️',
                label: s.otadexVersion,
                value: '1.0.0',
                hasArrow: false),
            const _SettingsDivider(),
            _SettingsRow(
                icon: '📄', label: s.termsOfService, hasArrow: true),
            const _SettingsDivider(),
            _SettingsRow(icon: '🔐', label: s.privacyPolicy, hasArrow: true),
            const _SettingsDivider(),
            _SettingsRow(icon: '⭐', label: s.rateApp, hasArrow: true),
          ]),
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
                style:
                    GoogleFonts.nunitoSans(fontSize: 14, color: theme.textPrimary),
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
              style:
                  GoogleFonts.nunitoSans(fontSize: 14, color: theme.textPrimary),
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
