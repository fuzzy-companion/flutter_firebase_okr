import 'package:flutter/material.dart';

class DarkTheme {
  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.dark,

    // Primary → buttons, active states
    primary: Color(0xFF7C9DFF),

    // Secondary → like, success actions
    secondary: Color(0xFF4ADE80),

    // Surface → cards, containers
    surface: Color(0xFF1E293B),

    // OnSurface → text, icons
    onSurface: Color(0xFFE5E7EB),

    // Error → error states
    error: Colors.red,
    onError: Colors.black,

    // Text on buttons
    onPrimary: Colors.black,
    onSecondary: Colors.black,
  );

  static final ThemeData darkThemeConfig = ThemeData(
    brightness: Brightness.dark,
    colorScheme: colorScheme,

    // App background
    scaffoldBackgroundColor: const Color(0xFF0F172A),
  );
}