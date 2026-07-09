import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle get _baseStyle => GoogleFonts.sora();

  // Big headline (onboarding): 28–32px, Bold
  static TextStyle onboardingHeadline(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 34.0 : 30.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  // Screen titles ("Travel & Hike" style): 24px, Semi-bold
  static TextStyle screenTitle(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 28.0 : 24.0,
    fontWeight: FontWeight.w600,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  // Headings: Semi-bold, 18–24px
  static TextStyle headingLarge(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 28.0 : 24.0,
    fontWeight: FontWeight.w600,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  static TextStyle headingMedium(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 22.0 : 18.0,
    fontWeight: FontWeight.w600,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  // Section headers ("Browse by activity", "Recommended"): 16px, Semi-bold
  static TextStyle sectionHeader(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 18.0 : 16.0,
    fontWeight: FontWeight.w600,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  // Card titles: 15px Semi-bold
  static TextStyle headingSmall(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 17.0 : 15.0,
    fontWeight: FontWeight.w600,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  // Body: Regular, 14px
  static TextStyle bodyRegular(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 16.0 : 14.0,
    fontWeight: FontWeight.w400,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  static TextStyle bodyMedium(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 16.0 : 14.0,
    fontWeight: FontWeight.w500,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  static TextStyle bodyBold(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 16.0 : 14.0,
    fontWeight: FontWeight.w600,
    color: isHighContrast
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );

  // Captions / meta text (location, distance, weather): 12–13px, gray
  static TextStyle caption(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 14.0 : 12.5,
    fontWeight: FontWeight.w400,
    color: isHighContrast
        ? AppColors.hcAccent
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
  );

  static TextStyle captionBold(bool isDark, {bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 14.0 : 12.5,
    fontWeight: FontWeight.w600,
    color: isHighContrast
        ? AppColors.hcAccent
        : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
  );

  // Button text
  static TextStyle buttonText({bool isHighContrast = false}) => _baseStyle.copyWith(
    fontSize: isHighContrast ? 18.0 : 15.0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
