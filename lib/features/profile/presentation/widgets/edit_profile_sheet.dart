import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/providers/user_profile_provider.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';
import '../../../../core/widgets/skeleton_loader.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key});

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late final TextEditingController _pseudoCtrl;
  late final TextEditingController _bioCtrl;
  String? _pseudoError;
  String? _authError;
  String? _pendingAvatarPath;
  bool _isLoading = false;

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

  Future<void> _save() async {
    final pseudo = _pseudoCtrl.text.trim();
    final s = AppStrings.of(context);
    setState(() {
      _pseudoError = null;
      _authError = null;
    });
    if (pseudo.length < 3) {
      setState(() => _pseudoError = s.pseudoMinLength);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuthService().updateUserProfile(
        pseudo: pseudo,
        bio: _bioCtrl.text.trim(),
        avatarUrl: _pendingAvatarPath,
      );
      ref.read(userProfileProvider.notifier).updateProfile(
            pseudo: pseudo,
            bio: _bioCtrl.text.trim(),
          );
      if (_pendingAvatarPath != null) {
        ref.read(userProfileProvider.notifier).updateAvatar(_pendingAvatarPath);
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserPseudo, pseudo);
      await prefs.setString(AppConstants.keyUserDisplayName, pseudo);
      if (_pendingAvatarPath != null) {
        await prefs.setString(
            AppConstants.keyUserAvatarUrl, _pendingAvatarPath!);
      }
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(s.profileUpdated)));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _authError = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    ref.watch(userProfileProvider);

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
          Center(
              child: _AvatarSection(
            avatarPath: _pendingAvatarPath,
            onTap: _pickAvatar,
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
          if (_authError != null) ...[
            const SizedBox(height: 14),
            Text(_authError!,
                style: GoogleFonts.nunitoSans(
                    fontSize: 13, color: AppColors.error)),
          ],
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
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.accentColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isLoading
                    ? shimmerBox(width: 18, height: 18, radius: 9)
                    : Text(s.saveChanges,
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w700)),
              ),
            ),
          ]),
        ],
      ),
    );
  }

}

class _AvatarSection extends StatelessWidget {
  final String? avatarPath;
  final VoidCallback onTap;
  final dynamic theme;

  const _AvatarSection({
    required this.avatarPath,
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
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: t.accentColor,
              shape: BoxShape.circle,
              border: Border.all(color: t.backgroundCard, width: 2),
            ),
            child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
          ),
        ],
      ),
    );
  }
}
