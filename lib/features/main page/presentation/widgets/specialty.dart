import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/constants.dart';

Widget specilaty(String icon, String title) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    splashColor: Colors.green,
    onTap: () {},
    // splashColor: Colors.green,
    child: Container(
      height: Constants.containerWidthHight,
      width: Constants.containerWidthHight,
      decoration: BoxDecoration(
        gradient: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            // color: Colors.white,
            height: 60,
            width: 60,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
