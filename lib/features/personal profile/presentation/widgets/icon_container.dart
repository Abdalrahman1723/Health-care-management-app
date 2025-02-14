import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';

Widget iconContainer(IconData icon) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(
            50,
          ),
        ),
        gradient: AppColors.containerBackground,
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 4),
            color: Colors.black.withOpacity(
              0.3,
            ),
            blurRadius: 3,
          ),
        ]),
    child: Padding(
      padding: const EdgeInsets.all(4.0),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    ),
  );
}
