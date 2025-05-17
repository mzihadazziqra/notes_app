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
  appBarTheme: AppBarTheme(titleTextStyle: TextStyle(color: Color(0xFF4c4f69))),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFF4c4f69)), // Text (Latte)
    bodyMedium: TextStyle(color: Color(0xFF575268)), // Overlay 1 (Latte)
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.grey.shade600),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Color(0xFF4c4f69), // warna teks
      shadowColor: Colors.transparent, // hilangkan shadow
      side: const BorderSide(color: Colors.grey, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
      textStyle: const TextStyle(fontSize: 16),
    ),
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
  appBarTheme: AppBarTheme(titleTextStyle: TextStyle(color: Color(0xFFcdd6f4))),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Color(0xFFcdd6f4)), // Text (Mocha)
    bodyMedium: TextStyle(color: Color(0xFFbac2de)), // Overlay 1 (Mocha)
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.grey.shade400),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.redAccent),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      shadowColor: Colors.transparent,
      side: const BorderSide(color: Colors.white, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      textStyle: const TextStyle(fontSize: 16),
    ),
  ),
);
