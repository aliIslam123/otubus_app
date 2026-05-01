import 'package:flutter/material.dart';

class AppTheme {
  // ---------------- COLORS (Constants) ----------------
  static const Color primaryBlue = Color(0xFF000080); // Navy
  static const Color accentGold = Color(0xFFD4AF37); // Gold

  static const Color backgroundLight = Color(0xFFE2E8F0);
  static const Color backgroundDark = Color(0xFF1A1A1E);

  static const Color surfaceLight = Color(0xFFF5F5F8);
  static const Color surfaceDark = Color(0xFF1E293B);

  static const Color textDark = Color(0xFF0F172A);
  static const Color textLight = Colors.white;

  static const Color borderLight = Color(0xFFCBD5E1);
  static const Color borderDark = Color(0xFF334155);

  static const double radius = 14;

  // ---------------- LIGHT THEME ----------------
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      scaffoldBackgroundColor: backgroundLight,

      colorScheme:
          ColorScheme.fromSeed(
            seedColor: primaryBlue,
            brightness: Brightness.light,
          ).copyWith(
            primary: primaryBlue,
            secondary: accentGold,
            background: backgroundLight,
            surface: surfaceLight,
            onBackground: textDark,
            onSurface: textDark,
          ),

      // ---------------- APP BAR ----------------
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundLight,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryBlue),
        titleTextStyle: TextStyle(
          color: primaryBlue,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // ---------------- TEXT THEME ----------------
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textDark, fontSize: 16),
        bodyMedium: TextStyle(color: textDark, fontSize: 14),
        bodySmall: TextStyle(color: textDark, fontSize: 12),
        titleLarge: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),

      // ---------------- ICON THEME ----------------
      iconTheme: const IconThemeData(color: primaryBlue, size: 24),

      // ---------------- CARD THEME ----------------
      cardTheme: CardThemeData(
        color: surfaceLight,
        elevation: 3,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),

      // ---------------- DIVIDER ----------------
      dividerTheme: const DividerThemeData(color: borderLight, thickness: 1),

      // ---------------- INPUT DECORATION ----------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: primaryBlue),
        prefixIconColor: primaryBlue,
        suffixIconColor: primaryBlue,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),

      // ---------------- ELEVATED BUTTON ----------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      // ---------------- OUTLINED BUTTON ----------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryBlue,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: primaryBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      // ---------------- TEXT BUTTON ----------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),

      // ---------------- FLOATING ACTION BUTTON ----------------
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentGold,
        foregroundColor: Colors.black,
      ),

      // ---------------- BOTTOM NAV BAR ----------------
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      // ---------------- CHIP THEME ----------------
      chipTheme: ChipThemeData(
        backgroundColor: surfaceLight,
        selectedColor: accentGold.withOpacity(0.8),
        labelStyle: const TextStyle(color: textDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: borderLight),
        ),
      ),

      // ---------------- DIALOG THEME ----------------
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        titleTextStyle: const TextStyle(
          color: primaryBlue,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: textDark, fontSize: 14),
      ),
    );
  }

  // ---------------- DARK THEME ----------------
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      scaffoldBackgroundColor: backgroundDark,

      colorScheme:
          ColorScheme.fromSeed(
            seedColor: primaryBlue,
            brightness: Brightness.dark,
          ).copyWith(
            primary: primaryBlue,
            secondary: accentGold,
            background: backgroundDark,
            surface: surfaceDark,
            onBackground: textLight,
            onSurface: textLight,
          ),

      // ---------------- APP BAR ----------------
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // ---------------- TEXT THEME ----------------
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textLight, fontSize: 16),
        bodyMedium: TextStyle(color: textLight, fontSize: 14),
        bodySmall: TextStyle(color: textLight, fontSize: 12),
        titleLarge: TextStyle(
          color: accentGold,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        titleMedium: TextStyle(
          color: accentGold,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),

      // ---------------- ICON THEME ----------------
      iconTheme: const IconThemeData(color: Colors.white, size: 24),

      // ---------------- CARD THEME ----------------
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 2,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),

      // ---------------- DIVIDER ----------------
      dividerTheme: const DividerThemeData(color: borderDark, thickness: 1),

      // ---------------- INPUT DECORATION ----------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF111827),
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: const TextStyle(color: accentGold),
        prefixIconColor: accentGold,
        suffixIconColor: accentGold,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: accentGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),

      // ---------------- ELEVATED BUTTON ----------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentGold,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      // ---------------- OUTLINED BUTTON ----------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentGold,
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: accentGold, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),

      // ---------------- TEXT BUTTON ----------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentGold,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ),

      // ---------------- FLOATING ACTION BUTTON ----------------
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accentGold,
        foregroundColor: Colors.black,
      ),

      // ---------------- BOTTOM NAV BAR ----------------
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF111827),
        selectedItemColor: accentGold,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),

      // ---------------- CHIP THEME ----------------
      chipTheme: ChipThemeData(
        backgroundColor: surfaceDark,
        selectedColor: accentGold.withOpacity(0.8),
        labelStyle: const TextStyle(color: textLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: borderDark),
        ),
      ),

      // ---------------- DIALOG THEME ----------------
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        titleTextStyle: const TextStyle(
          color: accentGold,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(color: textLight, fontSize: 14),
      ),
    );
  }
}
