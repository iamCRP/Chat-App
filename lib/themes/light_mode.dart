import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  colorScheme: ColorScheme.light(
    background: const Color(0xFFF0F4FF),
    primary: const Color(0xFF6C63FF),       // vivid violet
    secondary: const Color(0xFFFFFFFF),
    tertiary: const Color(0xFFE8E4FF),
    inversePrimary: const Color(0xFF1A1A2E),
  ),
);
