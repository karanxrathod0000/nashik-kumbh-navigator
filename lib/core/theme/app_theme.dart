import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

enum AppThemeMode { light, dark, accessibility }

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => getTheme(AppThemeMode.light);
  static ThemeData get darkTheme => getTheme(AppThemeMode.dark);
  static ThemeData get accessibilityTheme => getTheme(AppThemeMode.accessibility);

  static ThemeData getTheme(AppThemeMode mode) {
    final bool isDark = mode == AppThemeMode.dark || mode == AppThemeMode.accessibility;
    final bool isHC = mode == AppThemeMode.accessibility;

    final Color bgColor = isHC
        ? AppColors.hcBackground
        : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight);
    
    final Color surfaceColor = isHC
        ? AppColors.hcSurface
        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);

    final Color primaryText = isHC
        ? AppColors.hcText
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: bgColor,
      primaryColor: AppColors.primaryViolet,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: AppColors.primaryViolet,
        onPrimary: Colors.white,
        secondary: AppColors.secondarySaffron,
        onSecondary: Colors.white,
        error: AppColors.alertHeavy,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: primaryText,
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: isHC ? 4 : 0.0,
        shadowColor: isDark ? Colors.black45 : const Color(0x0F000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
          side: isHC ? const BorderSide(color: AppColors.hcAccent, width: 2) : BorderSide.none,
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryText),
        titleTextStyle: AppTypography.headingMedium(isDark, isHighContrast: isHC),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryViolet,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0), // Pill shaped
          ),
          textStyle: AppTypography.buttonText(isHighContrast: isHC),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: isHC ? const BorderSide(color: AppColors.hcText, width: 1.5) : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.0),
          borderSide: const BorderSide(color: AppColors.primaryViolet, width: 2),
        ),
        hintStyle: AppTypography.bodyRegular(isDark, isHighContrast: isHC).copyWith(
          color: isHC ? AppColors.hcText.withValues(alpha: 0.7) : AppColors.textSecondary,
        ),
      ),
    );
  }
}
