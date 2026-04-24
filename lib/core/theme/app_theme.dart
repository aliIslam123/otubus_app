import 'package:flutter/material.dart';

class AppTheme {
  // ---------------- LIGHT THEME ----------------
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFE2E8F0),

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF000080),
          brightness: Brightness.light,
        ).copyWith(
          primary: const Color(0xFF000080), // Navy
          secondary: const Color(0xFFD4AF37), // Gold
          background: const Color(0xFFE2E8F0),
          surface: const Color(0xFFF5F5F8),
          onBackground: const Color(0xFF0F172A),
        ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF0F172A)),
      bodyMedium: TextStyle(color: Color(0xFF0F172A)),
      titleLarge: TextStyle(
        color: Color(0xFF000080),
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // ---------------- DARK THEME ----------------
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF1A1A1E),

    colorScheme:
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF4A6CF7),
          brightness: Brightness.dark,
        ).copyWith(
          primary: const Color(0xFF4A6CF7), // Blue
          secondary: const Color(0xFFE5B97F), // Gold
          background: const Color(0xFF1A1A1E),
          surface: const Color(0xFF1E293B),
          onBackground: Colors.white,
        ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(
        color: Color(0xFF4A6CF7),
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
