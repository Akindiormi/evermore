import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvermoreTheme {
  static const primary = Color(0xFF02349E);
  static const primaryDark = Color(0xFF01266F);
  static const primaryLight = Color(0xFF3D5FC4);
  static const background = Color(0xFFF7F9FC);
  static const surface = Colors.white;
  static const text = Color(0xFF111827);
  static const muted = Color(0xFF667085);
  static const border = Color(0xFFE5E7EB);
  static const gold = Color(0xFFE8B84B);

  /// Soft, low-elevation shadow used on premium surface cards.
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withValues(alpha: .05),
      blurRadius: 20,
      offset: const Offset(0, 8),
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: .03),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static BoxDecoration premiumCard({
    Color color = surface,
    double radius = 22,
    bool bordered = true,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: bordered ? Border.all(color: border) : null,
      boxShadow: cardShadow,
    );
  }

  static LinearGradient get heroGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
        bodyColor: text,
        displayColor: text,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: border),
        ),
      ),
    );
  }
}
