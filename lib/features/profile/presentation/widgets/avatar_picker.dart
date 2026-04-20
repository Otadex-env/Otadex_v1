import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/otadex_theme.dart';

class AvatarPicker extends StatelessWidget {
  static const _options = [
    ('Mel Shard', Color(0xFFD4621A), Color(0xFF8B3510)),
    ('Kiro Blaze', Color(0xFFE91E8C), Color(0xFF9B1465)),
    ('Yumi Frost', Color(0xFF00BCD4), Color(0xFF006064)),
    ('Draven', Color(0xFF4CAF50), Color(0xFF1B5E20)),
    ('Nox Ember', Color(0xFFFF5722), Color(0xFF8B1A00)),
  ];

  const AvatarPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 12,
      crossAxisSpacing: 10,
      childAspectRatio: 0.78,
      children: [
        ..._options.map((a) => _AvatarOption(name: a.$1, c1: a.$2, c2: a.$3)),
        _AddAvatarButton(theme: theme),
      ],
    );
  }
}

class _AvatarOption extends StatelessWidget {
  final String name;
  final Color c1;
  final Color c2;

  const _AvatarOption({required this.name, required this.c1, required this.c2});

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c1, c2],
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunitoSans(fontSize: 10, color: theme.textPrimary),
        ),
      ],
    );
  }
}

class _AddAvatarButton extends StatelessWidget {
  final dynamic theme;
  const _AddAvatarButton({required this.theme});

  @override
  Widget build(BuildContext context) {
    final t = OtadexTheme.of(context);
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: t.borderDefault, width: 1.5),
              color: t.backgroundCard,
            ),
            child: Center(
              child: Icon(Icons.add_rounded, color: t.textSecondary, size: 28),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Ajouter',
          style: GoogleFonts.nunitoSans(fontSize: 10, color: t.textSecondary),
        ),
      ],
    );
  }
}
