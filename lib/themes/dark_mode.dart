import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Poppins',
  colorScheme: ColorScheme.dark(
    background: const Color(0xFF0D0D1A),     // deep space
    primary: const Color(0xFF8B5CF6),         // neon purple
    secondary: const Color(0xFF1A1A2E),
    tertiary: const Color(0xFF16213E),
    inversePrimary: const Color(0xFFF0F4FF),
  ),
);