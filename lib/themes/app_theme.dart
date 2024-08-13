import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  // Tema Claro
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.imperialRed,
    scaffoldBackgroundColor: AppColors.seashell,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.imperialRed,
      titleTextStyle: TextStyle(color: AppColors.seashell, fontSize: 20),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.jet),
      bodyMedium: TextStyle(color: AppColors.jet),
      displayLarge: TextStyle(
          color: AppColors.jet, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.imperialRed,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.imperialRed,
      textTheme: ButtonTextTheme.primary,
    ),
    cardColor: AppColors.seashell,
  );

  // Tema Escuro
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.imperialRed,
    scaffoldBackgroundColor: AppColors.darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.imperialRed,
      titleTextStyle: TextStyle(color: AppColors.darkText, fontSize: 20),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkText),
      displayLarge: TextStyle(
          color: AppColors.darkText, fontSize: 24, fontWeight: FontWeight.bold),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.imperialRed,
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.imperialRed,
      textTheme: ButtonTextTheme.primary,
    ),
    cardColor: AppColors.darkBackground,
  );
}
