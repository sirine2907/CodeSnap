import 'package:flutter/material.dart';

// Colors and theme for the app itself (not the code themes).
class AppTheme {
  static const Color primary = Color(0xFF7C5CFF);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    );
    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFFF6F5FB),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF6F5FB),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    );
    return ThemeData(
      colorScheme: colorScheme,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: const Color(0xFF14131A),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF14131A),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1F1D27),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1F1D27),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
