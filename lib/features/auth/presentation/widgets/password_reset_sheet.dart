import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/otadex_button.dart';
import '../../../../core/widgets/otadex_text_field.dart';

enum _ResetPasswordStep { enterEmail, enterCode }

class PasswordResetSheet extends ConsumerStatefulWidget {
  const PasswordResetSheet({super.key});

  @override
  ConsumerState<PasswordResetSheet> createState() => _PasswordResetSheetState();
}

class _PasswordResetSheetState extends ConsumerState<PasswordResetSheet> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  _ResetPasswordStep _step = _ResetPasswordStep.enterEmail;
  bool _isLoading = false;
  String? _emailError;
  String? _codeError;
  String? _newError;
  String? _confirmError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();
    setState(() {
      _emailError = null;
      _generalError = null;
    });
    if (email.isEmpty) {
      setState(() => _emailError = AppStrings.of(context).emailRequired);
      return;
    }
    if (!email.contains('@')) {
      setState(() => _emailError = AppStrings.of(context).emailInvalid);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuthService().sendPasswordReset(email);
      if (!mounted) return;
      setState(() {
        _step = _ResetPasswordStep.enterCode;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email envoyé ! Vérifie les spams. Clique sur le lien reçu ou copie le code oobCode présent dans le lien.',
            style: GoogleFonts.nunitoSans(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _generalError = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _confirmReset() async {
    final code = _codeController.text.trim();
    final newPassword = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _codeError = null;
      _newError = null;
      _confirmError = null;
      _generalError = null;
    });

    bool valid = true;
    if (code.isEmpty) {
      setState(() => _codeError = 'Code de validation requis.');
      valid = false;
    }
    if (newPassword.length < 6) {
      setState(() => _newError = AppStrings.of(context).passwordMinLength);
      valid = false;
    }
    if (newPassword != confirmPassword) {
      setState(() => _confirmError = AppStrings.of(context).passwordsMismatch);
      valid = false;
    }
    if (!valid) return;

    setState(() => _isLoading = true);
    try {
      await FirebaseAuthService().confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mot de passe réinitialisé. Tu peux maintenant te connecter.',
            style: GoogleFonts.nunitoSans(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
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
    final s = AppStrings.of(context);
    final title = _step == _ResetPasswordStep.enterEmail
        ? 'Réinitialiser le mot de passe'
        : 'Valider le code de réinitialisation';
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              title,
              style: GoogleFonts.rajdhani(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _step == _ResetPasswordStep.enterEmail
                ? 'Un email de Firebase va être envoyé. Il contient un lien de réinitialisation. Clique sur le lien ou copie le code oobCode depuis l’URL si tu veux continuer dans l’application.'
                : 'Colle le code oobCode reçu dans le lien par email puis choisis un nouveau mot de passe.',
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          if (_step == _ResetPasswordStep.enterEmail) ...[
            OtadexTextField(
              label: s.emailLabel,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (_) => null,
            ),
            if (_emailError != null) ...[
              const SizedBox(height: 8),
              Text(_emailError!,
                  style: const TextStyle(color: AppColors.error)),
            ],
          ] else ...[
            OtadexTextField(
              label: 'Code de vérification',
              controller: _codeController,
              keyboardType: TextInputType.text,
            ),
            if (_codeError != null) ...[
              const SizedBox(height: 8),
              Text(_codeError!, style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 16),
            OtadexPasswordField(
              label: s.passwordLabel,
              controller: _newPasswordController,
              validator: (_) => null,
            ),
            if (_newError != null) ...[
              const SizedBox(height: 8),
              Text(_newError!, style: const TextStyle(color: AppColors.error)),
            ],
            const SizedBox(height: 16),
            OtadexPasswordField(
              label: s.confirmPasswordLabel,
              controller: _confirmPasswordController,
              validator: (_) => null,
            ),
            if (_confirmError != null) ...[
              const SizedBox(height: 8),
              Text(_confirmError!,
                  style: const TextStyle(color: AppColors.error)),
            ],
          ],
          if (_generalError != null) ...[
            const SizedBox(height: 16),
            Text(_generalError!,
                style: const TextStyle(color: AppColors.error)),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.borderDefault),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text('Annuler',
                      style:
                          GoogleFonts.nunitoSans(fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OtadexButton(
                  label: _step == _ResetPasswordStep.enterEmail
                      ? 'Envoyer le lien'
                      : 'Valider le code',
                  onPressed: _isLoading
                      ? null
                      : _step == _ResetPasswordStep.enterEmail
                          ? _sendResetEmail
                          : _confirmReset,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
