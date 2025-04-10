//to handel the colors of the app
import 'package:flutter/material.dart';

class AdminAppColors {
  static Color primary = Colors.purple;
  static Color hint = Colors.grey;
  static Color container = Colors.deepPurple;
  static Color gradientColor1 = Colors.deepPurple;
  static Color gradientColor2 = Colors.purpleAccent;
  static Color iconBackground = Colors.grey.shade300;
  static var containerBackground = LinearGradient(
    colors: [AdminAppColors.gradientColor1, AdminAppColors.gradientColor2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
