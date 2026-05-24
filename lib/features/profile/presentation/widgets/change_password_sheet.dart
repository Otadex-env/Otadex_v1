import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';
import '../../../../core/widgets/skeleton_loader.dart';

class ChangePasswordSheet extends StatefulWidget {
  const ChangePasswordSheet({super.key});

  @override
  State<ChangePasswordSheet> createState() => _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends State<ChangePasswordSheet> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _currentError;
  String? _newError;
  String? _confirmError;
  String? _generalError;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s = AppStrings.of(context);
    bool valid = true;
    setState(() {
      _currentError = null;
      _newError = null;
      _confirmError = null;
      _generalError = null;
    });

    if (_currentCtrl.text.isEmpty) {
      setState(() => _currentError = s.passwordRequired);
      valid = false;
    }
    if (_newCtrl.text.length < 6) {
      setState(() => _newError = s.passwordMinLength);
      valid = false;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      setState(() => _confirmError = s.passwordsMismatch);
      valid = false;
    }
    if (!valid) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuthService().reauthenticateAndUpdatePassword(
        currentPassword: _currentCtrl.text,
        newPassword: _newCtrl.text,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(s.passwordChanged)));
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _generalError = error.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);

    InputDecoration inputDeco({
      String? hint,
      String? errorText,
      bool obscure = false,
      VoidCallback? onToggle,
    }) =>
        InputDecoration(
          hintText: hint,
          hintStyle:
              GoogleFonts.nunitoSans(fontSize: 14, color: theme.textSecondary),
          errorText: errorText,
          filled: true,
          fillColor: theme.backgroundElevated,
          suffixIcon: onToggle != null
              ? IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    color: theme.textSecondary,
                    size: 18,
                  ),
                  onPressed: onToggle,
                )
              : null,
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
              s.changePassword,
              style: GoogleFonts.rajdhani(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(s.currentPassword,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12, color: theme.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _currentCtrl,
            obscureText: _obscureCurrent,
            style: GoogleFonts.nunitoSans(color: theme.textPrimary),
            decoration: inputDeco(
              errorText: _currentError,
              obscure: _obscureCurrent,
              onToggle: () =>
                  setState(() => _obscureCurrent = !_obscureCurrent),
            ),
          ),
          const SizedBox(height: 14),
          Text(s.passwordLabel,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12, color: theme.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _newCtrl,
            obscureText: _obscureNew,
            style: GoogleFonts.nunitoSans(color: theme.textPrimary),
            decoration: inputDeco(
              errorText: _newError,
              obscure: _obscureNew,
              onToggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ),
          const SizedBox(height: 14),
          Text(s.confirmPasswordLabel,
              style: GoogleFonts.nunitoSans(
                  fontSize: 12, color: theme.textSecondary)),
          const SizedBox(height: 6),
          TextField(
            controller: _confirmCtrl,
            obscureText: _obscureConfirm,
            style: GoogleFonts.nunitoSans(color: theme.textPrimary),
            decoration: inputDeco(
              errorText: _confirmError,
              obscure: _obscureConfirm,
              onToggle: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
          if (_generalError != null) ...[
            const SizedBox(height: 14),
            Text(_generalError!,
                style: GoogleFonts.nunitoSans(
                    fontSize: 13, color: AppColors.error)),
          ],
          const SizedBox(height: 24),
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
