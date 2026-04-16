import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/otadex_button.dart';
import '../../../core/widgets/otadex_text_field.dart';
import 'widgets/rank_selector.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pseudoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  SelectedRank _selectedRank = SelectedRank.genin;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _pseudoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Accepte les conditions pour continuer',
            style: GoogleFonts.nunitoSans(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // Task 02 : implémenter auth réelle
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          context.go(AppRouter.home);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
          // Dégradé radial violet en haut
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
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),

                    // Titre
                    Text(
                      'Crée ton compte',
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

                    // Sous-titre
                    Text(
                      'Rejoins des milliers de fans otaku',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 100.ms)
                        .slideY(
                            begin: 0.15,
                            end: 0,
                            duration: 500.ms,
                            delay: 100.ms),

                    const SizedBox(height: AppSpacing.xl),

                    // Pseudo
                    OtadexTextField(
                      label: 'Pseudo / Nom de ninja',
                      prefixIcon: Icons.person_outline,
                      controller: _pseudoController,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Pseudo requis';
                        if (v.length < 3) return 'Minimum 3 caractères';
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideX(
                            begin: -0.08,
                            end: 0,
                            duration: 400.ms,
                            delay: 200.ms),

                    const SizedBox(height: AppSpacing.md),

                    // Email
                    OtadexTextField(
                      label: 'Adresse e-mail',
                      prefixIcon: Icons.mail_outline,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email requis';
                        if (!v.contains('@')) return 'Email invalide';
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 290.ms)
                        .slideX(
                            begin: -0.08,
                            end: 0,
                            duration: 400.ms,
                            delay: 290.ms),

                    const SizedBox(height: AppSpacing.md),

                    // Mot de passe
                    OtadexPasswordField(
                      label: 'Mot de passe',
                      controller: _passwordController,
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Mot de passe requis';
                        if (v.length < 6) return 'Minimum 6 caractères';
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 380.ms)
                        .slideX(
                            begin: -0.08,
                            end: 0,
                            duration: 400.ms,
                            delay: 380.ms),

                    const SizedBox(height: AppSpacing.md),

                    // Confirmer mot de passe
                    OtadexPasswordField(
                      label: 'Confirmer mot de passe',
                      controller: _confirmPasswordController,
                      textInputAction: TextInputAction.done,
                      validator: (v) {
                        if (v != _passwordController.text) {
                          return 'Les mots de passe ne correspondent pas';
                        }
                        return null;
                      },
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 460.ms)
                        .slideX(
                            begin: -0.08,
                            end: 0,
                            duration: 400.ms,
                            delay: 460.ms),

                    const SizedBox(height: AppSpacing.xl),

                    // Section rang — titre
                    Text(
                      'Choisis ton rang de départ',
                      style: GoogleFonts.rajdhani(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 550.ms),

                    const SizedBox(height: 4),

                    Text(
                      'Tu pourras changer plus tard',
                      style: GoogleFonts.nunitoSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 600.ms),

                    const SizedBox(height: AppSpacing.md),

                    // RankSelector
                    RankSelector(
                      initialRank: _selectedRank,
                      onRankChanged: (r) =>
                          setState(() => _selectedRank = r),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 650.ms)
                        .slideY(
                            begin: 0.1,
                            end: 0,
                            duration: 500.ms,
                            delay: 650.ms),

                    const SizedBox(height: AppSpacing.lg),

                    // Checkbox CGU
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
                              children: const [
                                TextSpan(text: "J'accepte les "),
                                TextSpan(
                                  text: 'Conditions',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.accent,
                                  ),
                                ),
                                TextSpan(text: ' et la '),
                                TextSpan(
                                  text: 'Confidentialité',
                                  style: TextStyle(
                                    color: AppColors.accent,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.accent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(duration: 400.ms, delay: 760.ms),

                    const SizedBox(height: AppSpacing.xl),

                    // Bouton créer compte
                    OtadexButton(
                      label: 'Créer mon compte →',
                      onPressed: _isLoading ? null : _register,
                      isLoading: _isLoading,
                    )
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 850.ms)
                        .slideY(
                            begin: 0.12,
                            end: 0,
                            duration: 500.ms,
                            delay: 850.ms),

                    const SizedBox(height: AppSpacing.xl),

                    // Footer
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Déjà un compte ? ',
                            style: GoogleFonts.nunitoSans(
                              fontSize: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go(AppRouter.login),
                            child: Text(
                              'Se connecter',
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
