import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_strings.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/url_launcher_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/otadex_button.dart';
import '../../../core/widgets/otadex_text_field.dart';
import 'widgets/rank_selector.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  SelectedRank _selectedRank = SelectedRank.genin;
  bool _acceptTerms = false;
  bool _isLoading = false;
  String? _authError;

  @override
  void dispose() {
    _pseudoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _openTerms() => UrlLauncherService.openTerms();

  Future<void> _openPrivacyPolicy() => UrlLauncherService.openPrivacyPolicy();

  Future<void> _registerWithGoogle() async {
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
      await prefs.setString(AppConstants.keyUserRank, AppConstants.rankGenin);
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

  Future<void> _register() async {
    if (!mounted) return;
    final s = AppStrings.of(context);
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            s.acceptTermsError,
            style: GoogleFonts.nunitoSans(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _authError = null;
        _isLoading = true;
      });
      try {
        await FirebaseAuthService().signUpWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          pseudo: _pseudoController.text.trim(),
        );
        if (!mounted) return;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.keyIsLoggedIn, true);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString(
          AppConstants.keyUserPseudo,
          _pseudoController.text.trim(),
        );
        await prefs.setString(
          AppConstants.keyUserRank,
          AppConstants.rankGenin,
        );
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

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.go(AppRouter.login),
        ),
      ),
      body: Stack(
        children: [
          // Purple radial glow
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
                    AppColors.primary.withValues(alpha: 0.12),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      s.createAccount,
                      style: GoogleFonts.rajdhani(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: 0.15, end: 0, duration: 500.ms),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      s.joinFansSubtitle,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(
                        begin: 0.15, end: 0, duration: 500.ms, delay: 100.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // Google button
                    SizedBox(
                      width: double.infinity,
                      height: AppSpacing.buttonHeight,
                      child: OutlinedButton.icon(
                        onPressed: _isLoading ? null : _registerWithGoogle,
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
                    ).animate().fadeIn(duration: 400.ms, delay: 150.ms).slideY(
                        begin: 0.1, end: 0, duration: 400.ms, delay: 150.ms),

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
                    ).animate().fadeIn(duration: 300.ms, delay: 200.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // Pseudo
                    OtadexTextField(
                      label: s.pseudoLabel,
                      prefixIcon: Icons.person_outline,
                      controller: _pseudoController,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return s.pseudoRequired;
                        if (v.length < 3) return s.pseudoMinLength;
                        return null;
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideX(
                        begin: -0.08, end: 0, duration: 400.ms, delay: 200.ms),

                    const SizedBox(height: AppSpacing.md),

                    // Email
                    OtadexTextField(
                      label: s.emailAddressLabel,
                      prefixIcon: Icons.mail_outline,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return s.emailRequired;
                        if (!v.contains('@')) return s.emailInvalid;
                        return null;
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 290.ms).slideX(
                        begin: -0.08, end: 0, duration: 400.ms, delay: 290.ms),

                    const SizedBox(height: AppSpacing.md),

                    // Password
                    OtadexPasswordField(
                      label: s.passwordLabel,
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return s.passwordRequired;
                        if (v.length < 6) return s.passwordMinLength;
                        return null;
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 380.ms).slideX(
                        begin: -0.08, end: 0, duration: 400.ms, delay: 380.ms),

                    const SizedBox(height: AppSpacing.md),

                    // Confirm password
                    OtadexPasswordField(
                      label: s.confirmPasswordLabel,
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        if (v != _passwordController.text) {
                          return s.passwordsMismatch;
                        }
                        return null;
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 460.ms).slideX(
                        begin: -0.08, end: 0, duration: 400.ms, delay: 460.ms),

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

                    const SizedBox(height: AppSpacing.xl),

                    // Rank section title
                    Text(
                      s.chooseStartingRank,
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 550.ms),

                    const SizedBox(height: 4),

                    Text(
                      s.canChangeLater,
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 600.ms),

                    const SizedBox(height: AppSpacing.md),

                    RankSelector(
                      initialRank: _selectedRank,
                      onRankChanged: (r) => setState(() => _selectedRank = r),
                    ).animate().fadeIn(duration: 500.ms, delay: 650.ms).slideY(
                        begin: 0.1, end: 0, duration: 500.ms, delay: 650.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // Terms checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: (v) =>
                              setState(() => _acceptTerms = v ?? false),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: GoogleFonts.nunitoSans(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                TextSpan(text: s.acceptTermsPrefix),
                                TextSpan(
                                  text: s.termsWord,
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.accent,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _openTerms,
                                ),
                                TextSpan(text: s.acceptTermsConjunction),
                                TextSpan(
                                  text: s.privacyWord,
                                  style: const TextStyle(
                                    color: AppColors.accent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.accent,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = _openPrivacyPolicy,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 760.ms),

                    const SizedBox(height: AppSpacing.xl),

                    // Create account button
                    OtadexButton(
                      label: s.createAccountButton,
                      onPressed: _isLoading ? null : _register,
                      isLoading: _isLoading,
                    ).animate().fadeIn(duration: 500.ms, delay: 850.ms).slideY(
                        begin: 0.12, end: 0, duration: 500.ms, delay: 850.ms),

                    const SizedBox(height: AppSpacing.xl),

                    // Footer
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${s.alreadyHaveAccount} ',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go(AppRouter.login),
                            child: Text(
                              s.login,
                              style: GoogleFonts.nunitoSans(
                                fontSize: 15,
                                color: AppColors.accent,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 950.ms),

                    const SizedBox(height: AppSpacing.xl),
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
