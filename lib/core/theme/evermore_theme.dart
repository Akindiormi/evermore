import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvermoreTheme {
  // Evermore V2 — light glass system.
  static const primary = Color(0xFF315BFF);
  static const primaryDark = Color(0xFF2446D8);
  static const violet = Color(0xFF8B5CF6);
  static const primaryLight = Color(0xFFE8ECFF);
  static const background = Color(0xFFF6F7FB);
  static const surface = Colors.white;
  static const glass = Color(0xD9FFFFFF);
  static const text = Color(0xFF16213D);
  static const muted = Color(0xFF71809C);
  static const border = Color(0xB8FFFFFF);
  static const divider = Color(0xFFE8EBF3);

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF315BFF).withValues(alpha: .07),
      blurRadius: 28,
      offset: const Offset(0, 12),
      spreadRadius: -8,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: .045),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static BoxDecoration glassCard({
    double radius = 24,
    Color color = glass,
    bool bordered = true,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: bordered ? Border.all(color: border, width: 1) : null,
      boxShadow: cardShadow,
    );
  }

  static BoxDecoration premiumCard({
    Color color = surface,
    double radius = 24,
    bool bordered = true,
  }) => glassCard(radius: radius, color: color, bordered: bordered);

  static LinearGradient get heroGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF315BFF), Color(0xFF7654F6)],
  );

  static LinearGradient get softGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEAF0FF), Color(0xFFF7F1FF)],
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
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: text,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glass,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
      ),
    );
  }
}
