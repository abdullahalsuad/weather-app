import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette - Stunning Dark Blue Gradient
  static const Color deepNavy = Color(0xFF0A1128);
  static const Color darkBlue = Color(0xFF1C2951);
  static const Color richBlue = Color(0xFF2F4B8F);
  static const Color accentBlue = Color(0xFF4A73E8);
  static const Color lightAccent = Color(0xFF6B9AFF);

  // Gradient Colors - Beautiful Blue Dark Gradient
  static const List<Color> backgroundGradient = [
    Color(0xFF0A1128), // Deep Navy Blue
    Color(0xFF1C2951), // Dark Blue
    Color(0xFF2F4B8F), // Rich Blue
    Color(0xFF1E3A6F), // Medium Blue
  ];

  static const List<Color> cardGradient = [
    Color(0xFF2F4B8F),
    Color(0xFF1C2951),
  ];

  // Text Colors
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color secondaryText = Color(0xFFD4E2FF);
  static const Color tertiaryText = Color(0xFFA8BFEC);

  // Functional Colors - Increased opacity for better visibility
  static const Color cardBackground = Color(
    0x4DFFFFFF,
  ); // Increased from 0x33 to 0x4D
  static const Color cardBorder = Color(
    0x33FFFFFF,
  ); // Increased from 0x1A to 0x33
  static const Color iconColor = Color(0xFFFFFFFF);

  // Typography
  static const String fontFamily = 'Inter';

  static TextTheme textTheme = const TextTheme(
    // Display - Large Temperature
    displayLarge: TextStyle(
      fontSize: 120,
      fontWeight: FontWeight.w300,
      letterSpacing: -4,
      color: primaryText,
      height: 1.0,
    ),
    displayMedium: TextStyle(
      fontSize: 80,
      fontWeight: FontWeight.w300,
      letterSpacing: -2,
      color: primaryText,
    ),
    displaySmall: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w400,
      color: primaryText,
    ),

    // Headline - Section Headers
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: primaryText,
    ),

    // Title - Card Titles
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: primaryText,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: primaryText,
    ),

    // Body - Regular Text
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: primaryText,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: secondaryText,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: tertiaryText,
    ),

    // Label - Buttons and Labels
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: secondaryText,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: tertiaryText,
    ),
  );

  // Spacing System
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // Theme Data
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBlue,
      colorScheme: const ColorScheme.dark(
        primary: accentBlue,
        secondary: richBlue,
        surface: darkBlue,
        background: deepNavy,
        onPrimary: primaryText,
        onSecondary: primaryText,
        onSurface: primaryText,
        onBackground: primaryText,
      ),
      textTheme: textTheme,
      iconTheme: const IconThemeData(color: iconColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: iconColor),
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
      ),
    );
  }
}
