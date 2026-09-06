import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light(Color seed) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
        scaffoldBackgroundColor: const Color(0xFFF7F7F4),
        cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      );

  static ThemeData dark(Color seed) => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark),
      );
}
