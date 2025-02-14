import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';

AppBar myAppBar({required BuildContext context, required String title}) {
  return AppBar(
    // the back button
    leading: IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
      ),
      onPressed: () => Navigator.pop(context),
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white,
      ),
    ),
    automaticallyImplyLeading: false,
    flexibleSpace: Container(
      padding: const EdgeInsets.only(top: 12),
      // for gradient color background
      decoration: BoxDecoration(gradient: AppColors.containerBackground),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ],
      ),
    ),
  );
}
