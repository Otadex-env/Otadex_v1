import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/otadex_theme.dart';

class SettingsSection extends StatelessWidget {
  final bool notificationsEnabled;
  final ValueChanged<bool> onNotificationsChanged;

  const SettingsSection({
    super.key,
    required this.notificationsEnabled,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionLabel(label: 'COMPTE'),
          const SizedBox(height: 8),
          const _SettingsCard(children: [
            _SettingsRow(icon: '👤', label: 'Modifier le profil', hasArrow: true),
            _SettingsDivider(),
            _SettingsRow(icon: '🔒', label: 'Changer le mot de passe', hasArrow: true),
            _SettingsDivider(),
            _SettingsRow(icon: '✉️', label: 'Email', value: 'jean@mail.com', hasArrow: true),
          ]),
          const SizedBox(height: 24),
          const _SectionLabel(label: 'PRÉFÉRENCES'),
          const SizedBox(height: 8),
          _SettingsCard(children: [
            const _SettingsRow(icon: '🌙', label: 'Thème', value: 'Sombre', hasArrow: true),
            const _SettingsDivider(),
            _ToggleRow(
              icon: '🔔',
              label: 'Notifications',
              value: notificationsEnabled,
              onChanged: onNotificationsChanged,
            ),
            const _SettingsDivider(),
            const _SettingsRow(icon: '🌐', label: 'Langue', value: 'Français', hasArrow: true),
            const _SettingsDivider(),
            const _SettingsRow(icon: '🎨', label: 'Thème Kage', value: 'Verrouillé 🔒', hasArrow: true),
          ]),
          const SizedBox(height: 24),
          const _SectionLabel(label: 'CONTENU'),
          const SizedBox(height: 8),
          const _SettingsCard(children: [
            _SettingsRow(icon: '📋', label: 'Catégories masquées', value: '0 masquées', hasArrow: true),
            _SettingsDivider(),
            _SettingsRow(icon: '📊', label: 'Mon historique', hasArrow: true),
            _SettingsDivider(),
            _SettingsRow(icon: '🧹', label: 'Vider le cache', value: '24 MB', hasArrow: true),
          ]),
          const SizedBox(height: 24),
          const _SectionLabel(label: 'À PROPOS'),
          const SizedBox(height: 8),
          const _SettingsCard(children: [
            _SettingsRow(icon: 'ℹ️', label: 'Version OTADEX', value: '1.0.0', hasArrow: false),
            _SettingsDivider(),
            _SettingsRow(icon: '📄', label: "Conditions d'utilisation", hasArrow: true),
            _SettingsDivider(),
            _SettingsRow(icon: '🔐', label: 'Politique de confidentialité', hasArrow: true),
            _SettingsDivider(),
            _SettingsRow(icon: '⭐', label: "Noter l'app", hasArrow: true),
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

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    required this.hasArrow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return InkWell(
      onTap: hasArrow ? () {} : null,
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
                style: GoogleFonts.nunitoSans(fontSize: 14, color: theme.textPrimary),
              ),
            ),
            if (value != null) ...[
              Text(
                value!,
                style: GoogleFonts.nunitoSans(fontSize: 13, color: theme.textSecondary),
              ),
              const SizedBox(width: 4),
            ],
            if (hasArrow)
              Icon(Icons.chevron_right_rounded, color: theme.textSecondary, size: 20),
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
              style: GoogleFonts.nunitoSans(fontSize: 14, color: theme.textPrimary),
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
    return Divider(height: 1, thickness: 1, indent: 44, color: theme.borderSubtle);
  }
}
