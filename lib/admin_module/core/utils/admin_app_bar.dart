import 'package:flutter/material.dart';
import 'package:health_care_app/admin_module/core/utils/admin_app_colors.dart';

AppBar adminAppBar({required BuildContext context, required String title}) {
  return AppBar(
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
              // logout icon
              SizedBox(
                width: 35,
                height: 35,
                child: IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Clear any stored credentials/tokens here
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  '/LoginScreen', // Replace with your login route
                                  (route) => false,
                                );
                              },
                              child: const Text('Logout'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ]);
}
