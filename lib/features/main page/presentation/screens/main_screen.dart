import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
            children: [
              ShaderMask(
                // Gradient title
                shaderCallback: (bounds) => LinearGradient(
                  colors: [AppColors.gradientColor1, AppColors.gradientColor2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                child: const Text(
                  'Hi, Welcome back!',
                ),
              ),
              const Text(
                'Abdalrahman',
                style: TextStyle(color: Colors.black),
              ), //later will be replaced with the user name
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                // Handle user profile icon press
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/man.png'),
              ),
            ),
          ),
          // settings and notification icons
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
                        // Handle notification icon press
                      },
                    ),
                  ),
                  const SizedBox(width: 3),
                  // settings icon
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        // Handle settings icon press
                      },
                    ),
                  ),
                  const SizedBox(width: 3),
                  // search icon
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Handle search icon press
                      },
                    ),
                  ),
                ],
              ),
            )
          ]),
      body: SafeArea(
        child: Column(
          children: [
            //------------ Categories and see all button section
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GradientBackground.gradientText("Categories",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {},
                    child: GradientBackground.gradientText(
                      "see all",
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            //------------ divider
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 15,
              endIndent: 15,
            ),
            //------------ favorite & doctors & specialties section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // favorite icon
                InkWell(
                  onTap: () {
                    // Handle favorite icon press
                  },
                  child: Column(
                    children: [
                      GradientBackground.gradientIcon(
                          Icons.favorite_border_outlined),
                      GradientBackground.gradientText("Favorite"),
                    ],
                  ),
                ),
                // doctors icon
                InkWell(
                  onTap: () {
                    // Handle doctors icon press
                  },
                  child: Column(
                    children: [
                      GradientBackground.gradientIcon(
                          Icons.medical_services_outlined),
                      GradientBackground.gradientText("Doctors"),
                    ],
                  ),
                ),
                // specialties icon
                InkWell(
                  onTap: () {
                    // Handle specialties icon press
                  },
                  child: Column(
                    children: [
                      GradientBackground.gradientIcon(
                        Icons.workspace_premium_outlined,
                      ),
                      GradientBackground.gradientText("Specialties"),
                    ],
                  ),
                ),
              ],
            ),

            //------------ divider
            const SizedBox(
              height: 12,
            ),
            //------------ information section
            Container(
              decoration: BoxDecoration(
                gradient: AppColors.containerBackground,
              ),
              height: 200,
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}
