import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_strings.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/firebase_auth_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/otadex_theme.dart';

class ProfileLogoutFooter extends ConsumerWidget {
  const ProfileLogoutFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = OtadexTheme.of(context);
    final s = AppStrings.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(
            onPressed: () async {
              await FirebaseAuthService().signOut();
              ref.read(isLoggedInProvider.notifier).state = false;
              if (context.mounted) context.go(AppRouter.splash);
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.borderSubtle),
              backgroundColor: theme.backgroundCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                s.logout,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunitoSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          s.appVersion,
          style: GoogleFonts.nunitoSans(
            fontSize: 11,
            color: theme.textSecondary.withValues(alpha: 0.5),
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}
