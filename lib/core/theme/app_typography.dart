import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  // === TAILLES ===
  static const double displayLarge = 40.0;
  static const double displayMedium = 32.0;
  static const double headlineLarge = 28.0;
  static const double headlineMedium = 22.0;
  static const double titleLarge = 18.0;
  static const double titleMedium = 16.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double labelLarge = 16.0;
  static const double labelMedium = 14.0;
  static const double captionText = 12.0;

  // === LETTER SPACING ===
  static const double spacingTight = -0.3;
  static const double spacingNormal = 0.0;
  static const double spacingWide = 0.5;
  static const double spacingExtraWide = 1.5;

  // === STYLES DE TEXTE ===
  static TextStyle displayLargeStyle() => GoogleFonts.rajdhani(
        fontSize: displayLarge,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: spacingTight,
      );

  static TextStyle displayMediumStyle() => GoogleFonts.rajdhani(
        fontSize: displayMedium,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: spacingTight,
      );

  static TextStyle headlineLargeStyle() => GoogleFonts.rajdhani(
        fontSize: headlineLarge,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: spacingTight,
      );

  static TextStyle headlineMediumStyle() => GoogleFonts.rajdhani(
        fontSize: headlineMedium,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle titleLargeStyle() => GoogleFonts.rajdhani(
        fontSize: titleLarge,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle titleMediumStyle() => GoogleFonts.rajdhani(
        fontSize: titleMedium,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle bodyLargeStyle() => GoogleFonts.nunitoSans(
        fontSize: bodyLarge,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle bodyMediumStyle() => GoogleFonts.nunitoSans(
        fontSize: bodyMedium,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle bodyBoldStyle() => GoogleFonts.nunitoSans(
        fontSize: bodyMedium,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle buttonStyle() => GoogleFonts.rajdhani(
        fontSize: labelLarge,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: spacingWide,
      );

  static TextStyle logoStyle() => GoogleFonts.rajdhani(
        fontSize: displayMedium,
        fontWeight: FontWeight.w800,
        color: AppColors.accent,
        letterSpacing: spacingTight,
      );

  static TextStyle captionStyle() => GoogleFonts.nunitoSans(
        fontSize: captionText,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        letterSpacing: spacingWide,
      );

  static TextStyle labelStyle() => GoogleFonts.nunitoSans(
        fontSize: labelMedium,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );

  static TextTheme buildTextTheme() {
    return TextTheme(
      displayLarge: displayLargeStyle(),
      displayMedium: displayMediumStyle(),
      headlineLarge: headlineLargeStyle(),
      headlineMedium: headlineMediumStyle(),
      titleLarge: titleLargeStyle(),
      titleMedium: titleMediumStyle(),
      bodyLarge: bodyLargeStyle(),
      bodyMedium: bodyMediumStyle(),
      labelLarge: buttonStyle(),
      labelMedium: labelStyle(),
      bodySmall: captionStyle(),
    );
  }
}
