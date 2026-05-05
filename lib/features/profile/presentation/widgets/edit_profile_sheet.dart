import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/providers/user_profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key});

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late final TextEditingController _pseudoCtrl;
  late final TextEditingController _bioCtrl;
  String? _pseudoError;
  String? _pendingAvatarPath;

  @override
  void initState() {
    super.initState();
    final p = ref.read(userProfileProvider);
    _pseudoCtrl = TextEditingController(text: p.pseudo);
    _bioCtrl = TextEditingController(text: p.bio);
    _pendingAvatarPath = p.avatarUrl;
  }

  @override
  void dispose() {
    _pseudoCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  bool get _isJonin {
    final plan = ref.read(userProfileProvider).subscriptionPlan;
    return plan == AppConstants.planJonin || plan == AppConstants.planKage;
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked != null && mounted) {
      setState(() => _pendingAvatarPath = picked.path);
    }
  }

  void _save() {
    final pseudo = _pseudoCtrl.text.trim();
    final s = AppStrings.of(context);
    if (pseudo.length < 3) {
      setState(() => _pseudoError = s.pseudoMinLength);
      return;
    }
    ref.read(userProfileProvider.notifier).updateProfile(
          pseudo: pseudo,
          bio: _bioCtrl.text.trim(),
        );
    if (_isJonin && _pendingAvatarPath != null) {
      ref.read(userProfileProvider.notifier).updateAvatar(_pendingAvatarPath);
    }
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(s.profileUpdated)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    final profile = ref.watch(userProfileProvider);

    InputDecoration inputDeco({String? errorText}) => InputDecoration(
          filled: true,
          fillColor: theme.backgroundElevated,
          errorText: errorText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.borderSubtle),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.borderSubtle),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.accentColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error),
          ),
        );

    return Container(
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: theme.borderSubtle)),
      ),
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, MediaQuery.of(context).viewInsets.bottom + 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.borderDefault,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              s.editProfile,
              style: GoogleFonts.rajdhani(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Avatar section ──────────────────────────────────────────────
          Center(child: _AvatarSection(
            avatarPath: _pendingAvatarPath,
            isJonin: _isJonin,
            subscriptionPlan: profile.subscriptionPlan,
            onTap: _isJonin ? _pickAvatar : _showJoninGate,
            theme: theme,
          )),
          const SizedBox(height: 20),

          // ── Pseudo ──────────────────────────────────────────────────────
          Text(s.pseudoLabel,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12, color: theme.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _pseudoCtrl,
            style: GoogleFonts.nunitoSans(color: theme.textPrimary),
            decoration: inputDeco(errorText: _pseudoError),
            onChanged: (_) {
              if (_pseudoError != null) setState(() => _pseudoError = null);
            },
          ),
          const SizedBox(height: 16),

          // ── Bio ─────────────────────────────────────────────────────────
          Text(s.bioLabel,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12, color: theme.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _bioCtrl,
            maxLines: 3,
            style: GoogleFonts.nunitoSans(color: theme.textPrimary),
            decoration: inputDeco(),
          ),
          const SizedBox(height: 24),

          // ── Actions ─────────────────────────────────────────────────────
          Row(children: [
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
                    style: GoogleFonts.nunitoSans(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(s.saveChanges,
                    style:
                        GoogleFonts.nunitoSans(fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  void _showJoninGate() {
    final theme = OtadexTheme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        decoration: BoxDecoration(
          color: theme.backgroundCard,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
            const SizedBox(height: 24),
            const Text('🦊', style: TextStyle(fontSize: 44)),
            const SizedBox(height: 16),
            Text(
              'Fonctionnalité Jonin',
              style: GoogleFonts.rajdhani(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Les avatars personnalisés sont réservés aux membres Jonin et Kage. Passez au rang supérieur pour débloquer cette fonctionnalité.',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text('Voir les plans',
                    style:
                        GoogleFonts.rajdhani(fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final String? avatarPath;
  final bool isJonin;
  final String subscriptionPlan;
  final VoidCallback onTap;
  final dynamic theme;

  const _AvatarSection({
    required this.avatarPath,
    required this.isJonin,
    required this.subscriptionPlan,
    required this.onTap,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final t = OtadexTheme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(44),
              gradient: avatarPath == null
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFD4621A), Color(0xFF5A1A00)],
                    )
                  : null,
              image: avatarPath != null
                  ? DecorationImage(
                      image: FileImage(File(avatarPath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
              border: Border.all(
                color: t.accentColor.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: avatarPath == null
                ? Icon(Icons.person_rounded,
                    color: Colors.white.withValues(alpha: 0.6), size: 36)
                : null,
          ),
          // Badge edit / lock
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: isJonin ? t.accentColor : t.backgroundElevated,
              shape: BoxShape.circle,
              border: Border.all(color: t.backgroundCard, width: 2),
            ),
            child: Icon(
              isJonin ? Icons.edit_rounded : Icons.lock_rounded,
              color: isJonin ? Colors.white : t.textSecondary,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
