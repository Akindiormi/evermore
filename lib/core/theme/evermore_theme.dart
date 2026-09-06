import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvermoreTheme {
  // Evermore brand system: dark navy base with a vivid green accent,
  // matching the "Ever AI" / "The Essence" brand artwork.
  static const primary = Color(0xFF1FE0A0); // core brand green
  static const primaryDark = Color(0xFF0FA872);
  static const primaryMid = Color(0xFF17C68A);
  static const electric = Color(0xFF34E8B0); // lighter green highlight
  static const violet = Color(0xFF2F6FED); // cool blue secondary accent
  static const gold = Color(0xFFF4C430); // premium / CTA accent

  // A pale, low-saturation tint of primary for badge backgrounds — kept
  // separate from the bright glow color used for button shadows below.
  static const primaryTint = Color(0xFF13291F);
  static const primaryLight = Color(0xFF17D6A0); // bright glow/shadow tint

  static const background = Color(0xFF070B14); // app background
  static const surface = Color(0xFF101827); // solid dark panel
  static const glass = Color(0xE6101827); // translucent dark "frosted" card
  static const glassStrong = Color(0xF2141D30); // more opaque dark panel (sheets)

  static const text = Color(0xFFF3F6FB); // primary text — near-white
  static const muted = Color(0xFF93A1BE); // secondary text
  static const ink = Color(0xFFF3F6FB);
  static const border = Color(0x33FFFFFF); // subtle hairline on dark cards
  static const divider = Color(0xFF232E45);

  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: .35),
      blurRadius: 32,
      offset: const Offset(0, 14),
      spreadRadius: -10,
    ),
    BoxShadow(
      color: primary.withValues(alpha: .05),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get floatingShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: .45),
      blurRadius: 30,
      offset: const Offset(0, 12),
      spreadRadius: -8,
    ),
    BoxShadow(
      color: primary.withValues(alpha: .10),
      blurRadius: 20,
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
    colors: [primaryDark, primaryMid, violet],
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
    colors: [Color(0xFF15233A), Color(0xFF11304A)],
  );

  static LinearGradient get goldGradient => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF4C430), Color(0xFFE08F1F)],
  );

  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
      ),
      splashFactory: InkSparkle.splashFactory,
    );

    return base.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).apply(
        bodyColor: text,
        displayColor: text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.manrope(
          color: text,
          fontWeight: FontWeight.w800,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: text),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: glass,
        hintStyle: const TextStyle(color: muted),
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
