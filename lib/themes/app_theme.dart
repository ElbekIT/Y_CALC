import 'package:flutter/material.dart';

class AppColors {
  // Background shades
  static const Color bgPrimary = Color(0xFF0A0A0F);
  static const Color bgSecondary = Color(0xFF12121A);
  static const Color bgCard = Color(0xFF1A1A28);
  static const Color bgButton = Color(0xFF1E1E2E);

  // Accent colors - neon style
  static const Color accentCyan = Color(0xFF00D4FF);
  static const Color accentPurple = Color(0xFF9B59FF);
  static const Color accentPink = Color(0xFFFF3CAC);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentGreen = Color(0xFF39FF14);

  // Operator button colors
  static const Color operatorBg = Color(0xFF2A1A3E);
  static const Color operatorText = Color(0xFF9B59FF);

  // Equal button gradient
  static const Color equalStart = Color(0xFF7B2FF7);
  static const Color equalEnd = Color(0xFF00D4FF);

  // Number button
  static const Color numberBg = Color(0xFF1E1E2E);
  static const Color numberText = Color(0xFFEEEEFF);

  // Special buttons (AC, +/-, %)
  static const Color specialBg = Color(0xFF252538);
  static const Color specialText = Color(0xFF00D4FF);

  // Display
  static const Color displayText = Color(0xFFFFFFFF);
  static const Color displaySubText = Color(0xFF7A7A9A);

  // Dividers & borders
  static const Color border = Color(0xFF2A2A40);
  static const Color glow = Color(0xFF9B59FF);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accentPurple,
        secondary: AppColors.accentCyan,
        background: AppColors.bgPrimary,
        surface: AppColors.bgCard,
      ),
      fontFamily: 'Roboto',
    );
  }
}
