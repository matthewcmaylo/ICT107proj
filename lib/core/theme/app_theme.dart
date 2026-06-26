import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Seed color — drives the full Material 3 color scheme
  static const Color _seed = Color(0xFF1A6BC4);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.light,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seed,
          brightness: Brightness.dark,
        ),
      );
}
