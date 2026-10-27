import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LioraTheme {
  // Light glass system built on the Liora logo colors: gold and black.
  static const primary = Color(0xFF9A6508);
  static const primaryDark = Color(0xFF6E4605);
  static const primaryMid = Color(0xFFC9890F);
  static const electric = Color(0xFFE0A21A);
  static const violet = Color(0xFFF5D547);
  static const primaryLight = Color(0xFFFFF4D6);
  static const background = Color(0xFFFBF9F4);
  static const surface = Colors.white;
  static const glass = Color(0xDFFFFFFF);
  static const glassStrong = Color(0xEEFDFEFF);
  static const text = Color(0xFF0A0A0B);
  static const muted = Color(0xFF6B6B73);
  static const ink = Color(0xFF0A0A0B);
  static const border = Color(0xB8FFFFFF);
  static const divider = Color(0xFFECE7E2);

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
    colors: [primary, primaryMid, electric],
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
    colors: [Color(0xFFFFF4D6), Color(0xFFFFFAEB)],
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
