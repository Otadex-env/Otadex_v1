import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/user_rank.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../core/services/chariow_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/skeleton_loader.dart';

class LicenseActivationScreen extends ConsumerStatefulWidget {
  const LicenseActivationScreen({super.key});

  @override
  ConsumerState<LicenseActivationScreen> createState() =>
      _LicenseActivationScreenState();
}

class _LicenseActivationScreenState
    extends ConsumerState<LicenseActivationScreen> {
  final _controller = TextEditingController();
  bool _isLoading = false;
  String? _errorText;

  static final _uuidRegex = RegExp(r'^[0-9a-fA-F-]{36}$');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _activate() async {
    final licenseKey = _controller.text.trim();

    if (!_uuidRegex.hasMatch(licenseKey)) {
      setState(() => _errorText = 'Format de clé incorrect (UUID attendu).');
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() =>
          _errorText = 'Connecte-toi pour activer une licence.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final result = await ChariowService().activateLicense(licenseKey, uid);

    if (!mounted) return;

    if (result.isActive) {
      final rank = ChariowService().detectPlan(result.productName);
      final expiresAt = result.expiresAt;

      // Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({
        'abonnement': rank.name,
        'licenseKey': licenseKey,
        'licenseExpiresAt':
            expiresAt?.toIso8601String() ?? '',
        'licenseActivatedAt': DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));

      // Providers
      ref
          .read(userProfileProvider.notifier)
          .updateIdentity(rank: rank.name);

      // SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyUserRank, rank.name);
      await prefs.setString(AppConstants.keySubscriptionPlan, rank.name);
      await prefs.setString(AppConstants.keyLicenseKey, licenseKey);
      if (expiresAt != null) {
        await prefs.setInt(AppConstants.keyLicenseExpires,
            expiresAt.millisecondsSinceEpoch);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Bienvenue chez les ${rank.label} !'),
        ),
      );
      context.go('/home');
    } else {
      setState(() {
        _isLoading = false;
        _errorText = result.errorMessage ?? 'Activation échouée.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDeep,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'Activer une licence',
          style: GoogleFonts.rajdhani(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entre ta clé de licence',
                style: GoogleFonts.rajdhani(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Achète une licence Jonin ou Kage sur le store OTADEX, puis colle ta clé ici pour débloquer les fonctionnalités premium.',
                style: GoogleFonts.nunitoSans(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _controller,
                style: GoogleFonts.nunitoSans(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx',
                  hintStyle: GoogleFonts.nunitoSans(
                    color: AppColors.textDisabled,
                    fontSize: 13,
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundElevated,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.borderSubtle),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: AppColors.borderSubtle),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                        color: AppColors.rankJonin, width: 1.5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.error),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() => _errorText = null);
                  }
                },
              ),
              if (_errorText != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorText!,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    color: AppColors.error,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _activate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.rankJonin,
                    disabledBackgroundColor:
                        AppColors.rankJonin.withValues(alpha: 0.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? shimmerBox(width: 22, height: 22, radius: 11)
                      : Text(
                          'Activer',
                          style: GoogleFonts.nunitoSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 40),
              _buildInfoCard(
                icon: Icons.security_rounded,
                title: 'Chaque clé est unique',
                body:
                    'Ta licence est liée à ton compte Firebase. Elle ne peut être utilisée que sur un seul appareil à la fois.',
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.help_outline_rounded,
                title: 'Tu n\'as pas encore de licence ?',
                body:
                    'Rends-toi sur la page Plans pour choisir Jonin ou Kage et obtenir ta clé depuis le store OTADEX.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      required String body}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.rankJonin),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: GoogleFonts.nunitoSans(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
