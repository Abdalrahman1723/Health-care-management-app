//to handel the colors of the app
import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/hex_colors.dart';

class AppColors {
  static Color primary = Colors.lightBlue;
  static Color hint = Colors.grey;
  static Color container = Colors.blue;
  static Color gradientColor1 = HexColor("#33E4DB");
  static Color gradientColor2 = HexColor("#00BBD3");
  static Color iconBackground = Colors.grey.shade300;
  static var containerBackground = LinearGradient(
    colors: [AppColors.gradientColor1, AppColors.gradientColor2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
