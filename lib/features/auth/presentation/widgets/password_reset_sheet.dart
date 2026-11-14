import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/otadex_button.dart';
import '../../../../core/widgets/otadex_text_field.dart';

/// Feuille « mot de passe oublié ».
///
/// Parcours en deux temps, tout simple :
/// 1. l'utilisateur saisit son email et on demande à Firebase de lui écrire ;
/// 2. on lui explique quoi faire : ouvrir l'email, cliquer sur le lien (une
///    page Firebase s'ouvre pour choisir le nouveau mot de passe), puis revenir
///    se connecter. Plus aucun code à recopier dans l'application.
class PasswordResetSheet extends ConsumerStatefulWidget {
  const PasswordResetSheet({super.key});

  @override
  ConsumerState<PasswordResetSheet> createState() => _PasswordResetSheetState();
}

class _PasswordResetSheetState extends ConsumerState<PasswordResetSheet> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false; // true après l'envoi : on affiche les consignes
  String? _emailError;
  String? _generalError;

  @override
  void dispose() {
    _emailController.dispose();
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
        _emailSent = true;
        _isLoading = false;
      });
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
              'Réinitialiser le mot de passe',
              style: GoogleFonts.rajdhani(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _emailSent
                ? 'Email envoyé à ${_emailController.text.trim()}.\n\n'
                    '1. Ouvre l\'email (regarde aussi dans les spams).\n'
                    '2. Clique sur le lien : une page s\'ouvre pour choisir ton nouveau mot de passe.\n'
                    '3. Reviens dans OTADEX et connecte-toi avec ce nouveau mot de passe.\n\n'
                    'Si tu as créé ton compte avec Google, tu n\'as pas de mot de passe : utilise « Continuer avec Google ».'
                : 'Entre l\'email de ton compte. Nous t\'enverrons un lien pour choisir un nouveau mot de passe.',
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          if (!_emailSent) ...[
            const SizedBox(height: 20),
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
          ],
          if (_generalError != null) ...[
            const SizedBox(height: 16),
            Text(_generalError!, style: const TextStyle(color: AppColors.error)),
          ],
          const SizedBox(height: 24),
          if (_emailSent)
            SizedBox(
              width: double.infinity,
              child: OtadexButton(
                label: 'Fermer',
                onPressed: () => Navigator.pop(context),
              ),
            )
          else
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
                        style: GoogleFonts.nunitoSans(
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OtadexButton(
                    label: 'Envoyer le lien',
                    onPressed: _isLoading ? null : _sendResetEmail,
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
