import 'package:flutter/material.dart';
import 'package:health_care_app/config/routes/routes.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/gradient_text.dart';
import '../../../personal profile/presentation/widgets/icon_container.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
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
                  'Settings',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: iconContainer(Icons.notifications_none),
            trailing: GradientBackground.gradientIcon(Icons.arrow_forward_ios),
            title: const Text("Notification settings"),
            onTap: () {
              Navigator.pushNamed(context, Routes.notificationSettingsScreen);
            },
          ),
          ListTile(
            leading: iconContainer(Icons.key_outlined),
            trailing: GradientBackground.gradientIcon(Icons.arrow_forward_ios),
            title: const Text("Password manager"),
            onTap: () {
              Navigator.pushNamed(context, Routes.passwordManager);
            },
          ),
          ListTile(
            leading: iconContainer(Icons.person_outline),
            trailing: GradientBackground.gradientIcon(Icons.arrow_forward_ios),
            title: const Text("Delete account"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
