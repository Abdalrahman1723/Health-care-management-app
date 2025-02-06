import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/app_strings.dart';

ThemeData appTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
    hintColor: AppColors.hint,
    //
    scaffoldBackgroundColor: Colors.white,
    //
    fontFamily: AppStrings.fontFamilyCairo,
    //AppBarTheme
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    //
    textTheme: const TextTheme(
      //
      bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
      // headline large
      headlineLarge: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
      // body medium
      bodyMedium: TextStyle(
        //!
        color: Colors.white,
        fontSize: 16,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w500,
      ),
      // title medium
      titleMedium: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
    ),
    //
    //IconButtonTheme
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.iconBackground),
        iconSize: WidgetStateProperty.all(18),
        foregroundColor: WidgetStateProperty.all(Colors.black),
      ),
    ),
  );
}
