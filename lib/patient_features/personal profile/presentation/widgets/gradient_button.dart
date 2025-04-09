import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';

Widget gradientButton = Container(
  width: 200,
  decoration: BoxDecoration(
    gradient: AppColors.containerBackground,
    borderRadius: BorderRadius.circular(30), // Rounded corners
  ),
  child: InkWell(
    onTap: () {
      // Add your action here
    },
    borderRadius: BorderRadius.circular(30), // Ripple effect follows the shape
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Center(
        child: Text(
          'Update profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  ),
);
