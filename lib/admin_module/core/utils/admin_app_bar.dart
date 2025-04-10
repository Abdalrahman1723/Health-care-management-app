import 'package:flutter/material.dart';
import 'package:health_care_app/admin_module/core/utils/admin_app_colors.dart';

AppBar adminAppBar({required BuildContext context, required String title}) {
  return AppBar(
      // the back button
      // leading: IconButton(
      //   style: ButtonStyle(
      //     backgroundColor: WidgetStateProperty.all(Colors.transparent),
      //   ),
      //   onPressed: () => Navigator.pop(context),
      //   icon: const Icon(
      //     size: 25,
      //     Icons.arrow_back_ios_new_rounded,
      //     color: Colors.white,
      //   ),
      // ),
      automaticallyImplyLeading: false, //to remove the default back button
      flexibleSpace: Container(
        padding: const EdgeInsets.only(top: 8),
        // for gradient color background
        decoration: BoxDecoration(gradient: AdminAppColors.containerBackground),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: [
              // notification icon
              SizedBox(
                width: 35,
                height: 35,
                child: IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    //todo add notification screen
                    // Navigator.pushNamed(
                    //     context, Routes.notificationsScreen);
                  },
                ),
              ),
              const SizedBox(width: 4),
              // settings icon
              SizedBox(
                width: 35,
                height: 35,
                child: IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () {
                    //todo add settings screen
                    // Navigator.pushNamed(context, Routes.settingsScreen);
                  },
                ),
              ),
            ],
          ),
        )
      ]);
}
