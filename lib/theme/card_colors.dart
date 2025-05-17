import 'package:flutter/material.dart';

class CardColors {
  static List<Color> lightThemeColors = [
    const Color(0xFFD48B84), // Pastel Red
    const Color(0xFFE5A063), // Pastel Orange
    const Color(0xFFC0D188), // Pastel Yellow-Green
    const Color(0xFF8BB8D8), // Pastel Blue
    const Color(0xFFC4A0C0), // Pastel Purple
    const Color(0xFFD4C38A), // Pastel Yellow
  ];

  static List<Color> darkThemeColors = [
    const Color(0xFFD98880), // Darker Pastel Red
    const Color(0xFFEB984E), // Darker Pastel Orange
    const Color(0xFFB9D18A), // Darker Pastel Yellow-Green
    const Color(0xFF7FB3D5), // Darker Pastel Blue
    const Color(0xFFC39BD3), // Darker Pastel Purple
    const Color(0xFFD5B162), // Darker Pastel Yellow
  ];

  static List<Color> get cardsColor {
    return _isDarkMode ? darkThemeColors : lightThemeColors;
  }

  static bool _isDarkMode = false;

  static void setTheme(Brightness brightness) {
    _isDarkMode = brightness == Brightness.dark;
  }
}
