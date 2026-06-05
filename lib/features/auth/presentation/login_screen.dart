import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/otadex_button.dart';
import '../../../core/widgets/otadex_text_field.dart';
import 'widgets/password_reset_sheet.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _authError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _authError = null;
        _isLoading = true;
      });
      try {
        await FirebaseAuthService().signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        if (!mounted) return;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.keyIsLoggedIn, true);
        await prefs.setBool('isLoggedIn', true);
        ref.read(userProfileProvider.notifier).updateIdentity(
              id: prefs.getString(AppConstants.keyUserId),
              pseudo: prefs.getString(AppConstants.keyUserPseudo),
              email: prefs.getString(AppConstants.keyUserEmail),
              rank: prefs.getString(AppConstants.keyUserRank),
            );
        ref.read(isLoggedInProvider.notifier).state = true;
        if (!mounted) return;
        setState(() => _isLoading = false);
        context.pushReplacement(AppRouter.home);
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _authError = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _continueAsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyIsLoggedIn, false);
    if (mounted) context.go(AppRouter.home);
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      _authError = null;
      _isLoading = true;
    });
    try {
      await FirebaseAuthService().signInWithGoogle();
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.keyIsLoggedIn, true);
      await prefs.setBool('isLoggedIn', true);
      ref.read(userProfileProvider.notifier).updateIdentity(
            id: prefs.getString(AppConstants.keyUserId),
            pseudo: prefs.getString(AppConstants.keyUserPseudo),
            email: prefs.getString(AppConstants.keyUserEmail),
            rank: prefs.getString(AppConstants.keyUserRank),
          );
      ref.read(isLoggedInProvider.notifier).state = true;
      setState(() => _isLoading = false);
      if (!mounted) return;
      context.pushReplacement(AppRouter.home);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _authError = e.toString();
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: GoogleFonts.nunitoSans(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      body: Stack(
        children: [
          // ── Background illustration ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash/splash_illustration.png',
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              opacity: const AlwaysStoppedAnimation(0.22),
            ),
          ),

          // ── Dark gradient overlay ──
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.38, 0.65, 1.0],
                  colors: [
                    AppColors.backgroundDeep.withValues(alpha: 0.30),
                    AppColors.backgroundDeep.withValues(alpha: 0.65),
                    AppColors.backgroundDeep.withValues(alpha: 0.92),
                    AppColors.backgroundDeep,
                  ],
                ),
              ),
            ),
          ),

          // ── Purple radial glow ──
          Positioned(
            top: -100,
            left: -50,
            right: -50,
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.5),
                  radius: 0.7,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),

                    // Logo
                    Image.asset(
                      AppAssets.logoFull,
                      width: 160,
                      fit: BoxFit.contain,
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .slideY(begin: 0.12, end: 0, duration: 600.ms),

                    const SizedBox(height: AppSpacing.xl),

                    Text(
                      s.welcomeBack,
                      style: GoogleFonts.rajdhani(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(
                        begin: 0.15, end: 0, duration: 500.ms, delay: 100.ms),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      s.loginSubtitle,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(
                        begin: 0.15, end: 0, duration: 500.ms, delay: 200.ms),

                    const SizedBox(height: AppSpacing.xl + AppSpacing.sm),

                    // Email field
                    OtadexTextField(
                      label: s.emailLabel,
                      prefixIcon: Icons.mail_outline,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return s.emailRequired;
                        if (!v.contains('@')) return s.emailInvalid;
                        return null;
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideX(
                        begin: -0.08, end: 0, duration: 400.ms, delay: 300.ms),

                    const SizedBox(height: AppSpacing.md),

                    // Password field
                    OtadexPasswordField(
                      label: s.passwordLabel,
                      controller: _passwordController,
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        if (v == null || v.isEmpty) return s.passwordRequired;
                        if (v.length < 6) return s.passwordMinLength;
                        return null;
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 380.ms).slideX(
                        begin: -0.08, end: 0, duration: 400.ms, delay: 380.ms),

                    if (_authError != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        _authError!,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 13,
                          color: AppColors.error,
                        ),
                      ),
                    ],

                    const SizedBox(height: AppSpacing.sm),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const PasswordResetSheet(),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          s.forgotPassword,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 14,
                            color: AppColors.textLink,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 450.ms),

                    const SizedBox(height: AppSpacing.xl),

                    // Login button
                    OtadexButton(
                      label: s.login,
                      onPressed: _isLoading ? null : _login,
                      isLoading: _isLoading,
                    ).animate().fadeIn(duration: 500.ms, delay: 550.ms).slideY(
                        begin: 0.12, end: 0, duration: 500.ms, delay: 550.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // Separator
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              height: 1, color: AppColors.borderSubtle),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md),
                          child: Text(
                            s.orSeparator,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 14,
                              color: AppColors.textDisabled,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                              height: 1, color: AppColors.borderSubtle),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 650.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // Google button
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _loginWithGoogle,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.backgroundCard,
                          side: const BorderSide(
                            color: AppColors.borderDefault,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusLg),
                          ),
                        ),
                        icon: const Icon(Icons.g_mobiledata,
                            color: Colors.white, size: 24),
                        label: Text(
                          s.continueWithGoogle,
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 730.ms).slideY(
                        begin: 0.1, end: 0, duration: 400.ms, delay: 730.ms),

                    const SizedBox(height: AppSpacing.xxl),

                    // Footer — no account yet
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${s.noAccountYet} ',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRouter.register),
                          child: Text(
                            s.becomeGenin,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              color: AppColors.accent,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 820.ms),

                    const SizedBox(height: AppSpacing.sm),

                    // Continue as guest
                    TextButton(
                      onPressed: _continueAsGuest,
                      child: Text(
                        s.continueAsGuest,
                        style: GoogleFonts.nunitoSans(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 900.ms),

                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
