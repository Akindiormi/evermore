import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvermoreTheme {
  // Blue system — anchored on the Evermore logo blue (#01339E).
  static const primary = Color(0xFF01339E);       // logo blue — button fill, headings accent
  static const primaryDark = Color(0xFF012572);    // darkest — gradients, pressed states
  static const primaryLight = Color(0xFF5274BD);   // mid blue — offset "shadow" layer on buttons
  static const primaryTint = Color(0xFFE6EBF5);    // pale blue — soft background tints, chips

  static const background = Color(0xFFF2EDE0);     // warm cream app background
  static const surface = Colors.white;
  static const text = Color(0xFF15181D);
  static const muted = Color(0xFF667085);
  static const border = Color(0xFFE5E1D3);         // soft border for regular content cards
  static const ink = Color(0xFF15181D);            // near-black used for bold outlines on CTAs

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
      textTheme: GoogleFonts.spaceGroteskTextTheme(base.textTheme).apply(
        bodyColor: text,
        displayColor: text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          color: text,
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.6),
        ),
      ),
    );
  }
}
