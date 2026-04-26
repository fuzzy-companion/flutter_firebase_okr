import 'package:flutter/material.dart';

class LightTheme {
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary → buttons, active states
    primary: Color(0xFF4C6FFF),

    // Secondary → like, success actions
    secondary: Color(0xFF22C55E),

    // Surface → cards, containers
    surface: Color(0xFFFFFFFF),

    // OnSurface → text, icons
    onSurface: Color(0xFF1F2937),

    // Error → error states
    error: Colors.red,
    onError: Colors.white,

    // Text on buttons
    onPrimary: Colors.white,
    onSecondary: Colors.white,
  );

  static final ThemeData lightThemeConfig = ThemeData(
    brightness: Brightness.light,
    colorScheme: colorScheme,

    // App background
    scaffoldBackgroundColor: const Color(0xFFF7F8FA),
  );
}