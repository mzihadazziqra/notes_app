import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    surface: Color(0xFFeff1f5), // Base (Latte)
    primary: Color(0xFF7287fd), // Peach (Latte)
    secondary: Color(0xFF8839ef), // Mauve (Latte)
    // inversePrimary: Color(0xFF4c4f69), // Text (Latte)
    inversePrimary: Colors.grey.shade800, // Text (Latte)
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF4c4f69)), // Text (Latte)
    bodyMedium: TextStyle(color: Color(0xFF575268)), // Overlay 1 (Latte)
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Color(0xFF1e1e2e), // Base (Mocha)
    primary: Color(0xFFcba6f7), // Mauve (Mocha)
    secondary: Color(0xFF89b4fa), // Blue (Mocha)
    inversePrimary: Colors.grey.shade300, // Rosewater (Mocha)
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFcdd6f4)), // Text (Mocha)
    bodyMedium: TextStyle(color: Color(0xFFbac2de)), // Overlay 1 (Mocha)
  ),
);
