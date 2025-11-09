import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF6A11CB);
  static const Color secondary = Color(0xFF2575FC);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey.shade50,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
      );

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [primary, secondary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
