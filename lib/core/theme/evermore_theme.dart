import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvermoreTheme {
  // Brand-led light glass system, built around the Evermore logo blue.
  static const primary = Color(0xFF00339E);
  static const primaryDark = Color(0xFF00256F);
  static const primaryMid = Color(0xFF0B4BC4);
  static const electric = Color(0xFF2D6BFF);
  static const violet = Color(0xFF7357F6);
  static const primaryLight = Color(0xFFE7EEFF);
  static const background = Color(0xFFF5F7FC);
  static const surface = Colors.white;
  static const glass = Color(0xDFFFFFFF);
  static const glassStrong = Color(0xEEFDFEFF);
  static const text = Color(0xFF10203D);
  static const muted = Color(0xFF71809C);
  static const ink = Color(0xFF12203A);
  static const border = Color(0xB8FFFFFF);
  static const divider = Color(0xFFE5EAF4);

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withValues(alpha: .09),
      blurRadius: 32,
      offset: const Offset(0, 14),
      spreadRadius: -10,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: .045),
      blurRadius: 12,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> get floatingShadow => [
    BoxShadow(
      color: primary.withValues(alpha: .18),
      blurRadius: 30,
      offset: const Offset(0, 12),
      spreadRadius: -8,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: .08),
      blurRadius: 16,
      offset: const Offset(0, 7),
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
    colors: [primary, primaryMid, violet],
    stops: [0.0, 0.58, 1.0],
  );

  static LinearGradient get logoGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, electric],
  );

  static LinearGradient get softGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEAF0FF), Color(0xFFF4F1FF)],
  );

  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      splashFactory: InkSparkle.splashFactory,
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
        iconTheme: const IconThemeData(color: text),
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
