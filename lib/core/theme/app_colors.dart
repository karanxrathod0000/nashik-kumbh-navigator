import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Role Color Hex (approx)
  // Primary Background Soft pale sky blue
  static const Color backgroundLight = Color(0xFFEAF3FB);
  
  // Card / Surface Pure white
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  // Primary Accent / CTA buttons Saffron (#FF7A33 for Kumbh branding)
  static const Color primaryViolet = Color(0xFFFF7A33); // Aliased as primary for existing code
  static const Color primaryIndigo = Color(0xFFE65C00);
  
  // Vivid blue for water/river-themed accents
  static const Color riverBlue = Color(0xFF2E7CF6);
  static const Color secondarySaffron = Color(0xFFFF7A33);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFF8C42), Color(0xFFFF6B1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient saffronGradient = LinearGradient(
    colors: [Color(0xFFFF8C42), Color(0xFFFF6B1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Illustration accent colors (Sky blue, forest green, warm sand, soft coral)
  static const Color pastelSkyBlue = Color(0xFF8FC1E3);
  static const Color pastelForestGreen = Color(0xFF4C8C6B);
  static const Color pastelWarmSand = Color(0xFFEFC98A);
  static const Color pastelSoftCoral = Color(0xFFF2A38A);

  // Rating/Favorite heart accent Coral red
  static const Color coralHeart = Color(0xFFF0563D);

  // Success / Verified Green
  static const Color successGreen = Color(0xFF2ECC71);
  
  // Info Tag / Pills Sky blue
  static const Color infoSkyBlue = Color(0xFF2E7CF6);
  
  // Bottom Nav Bar Near-black navy
  static const Color navBarNavy = Color(0xFF1B1F27);
  
  // Text Primary Deep navy/black
  static const Color textPrimary = Color(0xFF1B1F27);
  
  // Text Secondary Slate gray
  static const Color textSecondary = Color(0xFF7A8494);

  // Severity / Status Alerts
  static const Color alertModerate = Color(0xFFF39C12); // Yellow/Orange for moderate crowd/warnings
  static const Color alertHeavy = Color(0xFFE74C3C); // Red for heavy crowd/closures
  static const Color alertLight = Color(0xFF2ECC71); // Green for light crowd/clear

  // Dark Mode colors (for night navigation comfort)
  static const Color backgroundDark = Color(0xFF14171F);
  static const Color surfaceDark = Color(0xFF212633);
  static const Color textPrimaryDark = Color(0xFFF5F5F7);
  static const Color textSecondaryDark = Color(0xFFA0A0A6);

  // High Contrast Mode (Accessibility)
  static const Color hcBackground = Color(0xFF000000);
  static const Color hcSurface = Color(0xFF1A1A1A);
  static const Color hcText = Color(0xFFFFFFFF);
  static const Color hcAccent = Color(0xFFFFD700); // High visibility Gold/Yellow

  // Aliases for compatibility
  static const Color darkCard = surfaceDark;
  static const Color darkBackground = backgroundDark;
  static const Color lightBackground = backgroundLight;
  static const Color saffron = secondarySaffron;
  static const Color lightTextSecondary = textSecondary;
  static const Color lightTextPrimary = textPrimary;
  static const Color alertRed = alertHeavy;
}
