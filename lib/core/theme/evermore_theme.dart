import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EvermoreTheme {
  static const primary = Color(0xFF02349E);
  static const primaryDark = Color(0xFF01266F);
  static const background = Color(0xFFF7F9FC);
  static const surface = Colors.white;
  static const text = Color(0xFF111827);
  static const muted = Color(0xFF667085);
  static const border = Color(0xFFE5E7EB);

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
