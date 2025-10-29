import 'package:flutter/material.dart';

class GameOnColors {
  GameOnColors._();

  static const Color background = Color(0xFF121212); // Dark Pitch
  static const Color surface = Color(0xFF1A1A1A);
  static const Color primaryGreen = Color(0xFF00FF87); // GameOn Green
  static const Color accentGold = Color(0xFFFFC700); // Bright Gold
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3); // light gray
}

class GameOnDimens {
  GameOnDimens._();

  static const double radius = 16.0; // 16px rounded borders
  static const double fieldHeight = 56.0;
  static const double spacing = 16.0;
}

class GameOnTheme {
  GameOnTheme._();

  static ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: GameOnColors.background,
    primaryColor: GameOnColors.primaryGreen,
    colorScheme: const ColorScheme.dark(
      primary: GameOnColors.primaryGreen,
      secondary: GameOnColors.accentGold,
      background: GameOnColors.background,
      surface: GameOnColors.surface,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: GameOnColors.accentGold,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      labelLarge: TextStyle(
        color: GameOnColors.background,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: TextStyle(
        color: GameOnColors.textSecondary,
        fontSize: 14,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: GameOnColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GameOnDimens.radius),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GameOnDimens.radius),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(GameOnDimens.radius),
        borderSide: const BorderSide(color: GameOnColors.primaryGreen, width: 2),
      ),
      hintStyle: const TextStyle(color: GameOnColors.textSecondary),
    ),
  );

  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: GameOnColors.primaryGreen,
    foregroundColor: GameOnColors.background,
    minimumSize: const Size.fromHeight(56),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(GameOnDimens.radius),
    ),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  );
}


