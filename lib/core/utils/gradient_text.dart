import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';

class GradientBackground {
  static gradientText(String text, {TextStyle? style}) {
    return ShaderMask(
      // Gradient title
      shaderCallback: (bounds) => LinearGradient(
        colors: [AppColors.gradientColor1, AppColors.gradientColor2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: style,
      ),
    );
  }

  //gradient icon
  static gradientIcon(IconData icon) {
    return ShaderMask(
        // Gradient title
        shaderCallback: (bounds) => LinearGradient(
              colors: [AppColors.gradientColor1, AppColors.gradientColor2],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
        child: Icon(icon, color: Colors.white));
  }
}
