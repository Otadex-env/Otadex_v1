import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../router/app_router.dart';
import '../theme/otadex_theme.dart';

Future<void> showAuthGateModal(BuildContext context, {String? message}) {
  final router = GoRouter.of(context);
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (sheetCtx) => _AuthGateModal(
      message: message,
      onLogin: () {
        Navigator.pop(sheetCtx);
        router.push(AppRouter.login);
      },
      onRegister: () {
        Navigator.pop(sheetCtx);
        router.push(AppRouter.register);
      },
      onDismiss: () => Navigator.pop(sheetCtx),
    ),
  );
}

class _AuthGateModal extends StatelessWidget {
  final String? message;
  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final VoidCallback onDismiss;

  const _AuthGateModal({
    this.message,
    required this.onLogin,
    required this.onRegister,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = OtadexTheme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        20,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.backgroundCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: theme.borderSubtle)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Text('🔐', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 16),
          Text(
            'Connecte-toi pour continuer',
            style: GoogleFonts.rajdhani(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: theme.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message ??
                'Crée un compte gratuit pour accéder au profil,\nta collection et bien plus.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunitoSans(
              fontSize: 13,
              color: theme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                'Se connecter',
                style: GoogleFonts.rajdhani(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onRegister,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: theme.borderSubtle),
                foregroundColor: theme.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "S'inscrire gratuitement",
                style: GoogleFonts.rajdhani(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          TextButton(
            onPressed: onDismiss,
            child: Text(
              'Continuer sans compte',
              style: GoogleFonts.nunitoSans(
                fontSize: 13,
                color: theme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
