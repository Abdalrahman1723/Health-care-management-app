import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';

Widget notificationDate(String sinceWhen) {
  return Container(
    width: 150,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      gradient: AppColors.containerBackground,
      border: Border.all(color: Colors.white, width: 2),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Text(
      sinceWhen,
      style: const TextStyle(
          fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    ),
  );
}
