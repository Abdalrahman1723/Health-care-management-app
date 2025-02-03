import 'package:flutter/material.dart';
import 'package:quotes/core/utils/app_colors.dart';
import 'package:quotes/core/utils/app_strings.dart';

ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
    hintColor: AppColors.hint,
    //
    scaffoldBackgroundColor: Colors.black54,
    //
    fontFamily: AppStrings.fontFamilyCairo,
    //AppBarTheme
    appBarTheme: AppBarTheme(
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColors.container,
    ),
    //
    textTheme: const TextTheme(
      //
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
      //
      headlineLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      //
      bodyMedium: TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
      ),
      //
      titleMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    //
  );
}
