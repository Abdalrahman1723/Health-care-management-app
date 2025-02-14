import 'package:flutter/material.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';
import 'package:health_care_app/features/main%20page/presentation/widgets/avatar.dart';

import '../widgets/icon_container.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //the title
                  Text(
                    "My profile",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //the user avatar
                      avatar(
                        context: context,
                        editIconSize: 18,
                        avatarSize: 60,
                      ),
                      const SizedBox(width: 12.0),
                      //the user name, phone number and email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //the user name
                          Text(
                            "Abdalrahman",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          //the user Phone number
                          const Text("+20123456789"),
                          //the user email
                          const Text("example@gmail.com"),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //the user profile details
              ListTile(
                leading: iconContainer(Icons.person_outline),
                trailing:
                    GradientBackground.gradientIcon(Icons.arrow_forward_ios),
                title: const Text("Personal Information"),
                subtitle: const Text("Name, Phone number, Email"),
                onTap: () {
                  Navigator.pushNamed(context, Routes.editProfileScreen);
                },
              ),
              const SizedBox(height: 10),
              //the user favorite doctors
              ListTile(
                leading: iconContainer(Icons.favorite_outline),
                trailing:
                    GradientBackground.gradientIcon(Icons.arrow_forward_ios),
                title: const Text("Favorite"),
                subtitle: const Text("your favorite doctors"),
                onTap: () {},
              ),
              const SizedBox(height: 10),
              //the user settings
              ListTile(
                leading: iconContainer(Icons.settings_outlined),
                trailing:
                    GradientBackground.gradientIcon(Icons.arrow_forward_ios),
                title: const Text("Settings"),
                subtitle: const Text("manage your settings"),
                onTap: () {
                  Navigator.pushNamed(context, Routes.settingsScreen);
                },
              ),
              const SizedBox(height: 10),
              //the user profile logout
              ListTile(
                leading: iconContainer(Icons.logout_outlined),
                title: const Text("Logout"),
                onTap: () {},
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
