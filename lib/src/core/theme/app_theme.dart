import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Color Constants
  static const Color primaryEmerald = Color(0xFF0D9F67); // Emerald Green
  static const Color accentGold = Color(0xFFF59E0B);    // Gold/Amber
  static const Color darkBg = Color(0xFF0B0F19);        // Deep Slate Dark
  static const Color darkSurface = Color(0xFF131C2E);   // Glass/Card Dark
  static const Color lightBg = Color(0xFFF8FAFC);       // Soft Ice White
  static const Color lightSurface = Color(0xFFFFFFFF);  // Pure White

  // Light Theme Color Scheme
  static final ColorScheme _lightColorScheme = ColorScheme.light(
    primary: primaryEmerald,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFD1FAE5),
    onPrimaryContainer: const Color(0xFF065F46),
    secondary: accentGold,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFFEF3C7),
    onSecondaryContainer: const Color(0xFF92400E),
    surface: lightSurface,
    onSurface: const Color(0xFF0F172A),
    background: lightBg,
    onBackground: const Color(0xFF0F172A),
    error: const Color(0xFFEF4444),
    onError: Colors.white,
    outline: const Color(0xFFCBD5E1),
  );

  // Dark Theme Color Scheme
  static final ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: primaryEmerald,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFF065F46),
    onPrimaryContainer: const Color(0xFFD1FAE5),
    secondary: accentGold,
    onSecondary: Colors.black,
    secondaryContainer: const Color(0xFF78350F),
    onSecondaryContainer: const Color(0xFFFEF3C7),
    surface: darkSurface,
    onSurface: const Color(0xFFF1F5F9),
    background: darkBg,
    onBackground: const Color(0xFFF1F5F9),
    error: const Color(0xFFF87171),
    onError: Colors.black,
    outline: const Color(0xFF334155),
  );

  // Text Theme Configuration using Google Fonts
  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: colorScheme.onBackground,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: colorScheme.onBackground,
      ),
      titleLarge: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colorScheme.onBackground,
      ),
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: colorScheme.onBackground,
      ),
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colorScheme.onBackground,
      ),
    );
  }

  // Get Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _lightColorScheme,
      textTheme: _buildTextTheme(_lightColorScheme),
      scaffoldBackgroundColor: lightBg,
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _lightColorScheme.outline.withOpacity(0.2)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: lightBg,
        elevation: 0,
        iconTheme: IconThemeData(color: _lightColorScheme.onBackground),
        titleTextStyle: GoogleFonts.outfit(
          color: _lightColorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryEmerald,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Get Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _darkColorScheme,
      textTheme: _buildTextTheme(_darkColorScheme),
      scaffoldBackgroundColor: darkBg,
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: _darkColorScheme.outline.withOpacity(0.3)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        elevation: 0,
        iconTheme: IconThemeData(color: _darkColorScheme.onBackground),
        titleTextStyle: GoogleFonts.outfit(
          color: _darkColorScheme.onBackground,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryEmerald,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
