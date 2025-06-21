import 'package:flutter/material.dart';

class AppTheme {
  static const Color warmYellow = Color(0xFFFBF0D9);
  static const Color primaryBackground = Color(0xFFFBF0D9);
  static const Color darkYellow = Color(0xFFE6B357);
  static const Color primaryText = Color(0xFF333333);
  static const Color secondaryText = Color(0xFF575757);
  static const Color accentColor = Color(0xFF007AFF);
  static const Color disabledColor = Color(0xFFBDBDBD);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: accentColor,
      scaffoldBackgroundColor: Colors.white,
      fontFamily: 'SFPro',

      // color theme
      colorScheme: const ColorScheme.light(
        primary: accentColor,
        secondary: darkYellow,
        surface: Colors.white,
        onSurface: primaryText,
      ),

      // navbar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryText,
        unselectedItemColor: secondaryText.withValues(alpha: 0.7),
        showUnselectedLabels: true,
        showSelectedLabels: true,

        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
      ),

      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryText),
        titleTextStyle: TextStyle(
          fontFamily: 'SFPro',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
      ),

      cardTheme: CardThemeData(
        color: warmYellow,
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryText,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
        bodyLarge: TextStyle(fontSize: 17, color: primaryText),
        bodyMedium: TextStyle(fontSize: 15, color: secondaryText),
        labelLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: 'SFPro',
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            fontFamily: 'SFPro',
          ),
        ),
      ),
    );
  }
}
