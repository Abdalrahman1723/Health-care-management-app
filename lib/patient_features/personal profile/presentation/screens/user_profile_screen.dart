import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/avatar.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_cubit.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_state.dart';

import '../widgets/icon_container.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String patientID =
      "3"; //! this is a temp (later should be actorId) with shared pref
  //logout function
  void _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      // ✅ Check if the widget is still in the tree
      Navigator.pushNamed(context, Routes.loginAndSignup);
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().fetchUserData(patientID);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        // ==========loading state =============//
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );

          // ==========error state =============//
        } else if (state is ProfileError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                      onPressed: () {
                        context
                            .read<UserProfileCubit>()
                            .fetchUserData(patientID);
                      },
                      child: const Text("restart connection"))
                ],
              ),
            ),
          );
          // ==========success state =============//
        } else if (state is ProfileLoaded) {
          //good to go
          // Log the patient data
          log('patient Data: ${state.userData.toString()}');
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(250),
              child: AppBar(
                // the back button
                leading: IconButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.transparent),
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
                  decoration:
                      BoxDecoration(gradient: AppColors.containerBackground),
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
                                  state.userData.name,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                //the user Phone number
                                Text(state.userData.phoneNumber ?? ""),
                                //  Text(${state.userData.phoneNumber}),
                                //the user email
                                Text(state.userData.email),
                                // const Text(${state.userData.email}),
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
                    //-------------------the user profile details------------------//
                    ListTile(
                      leading: iconContainer(Icons.person_outline),
                      trailing: GradientBackground.gradientIcon(
                          Icons.arrow_forward_ios),
                      title: const Text("Personal Information"),
                      subtitle: const Text("Name, Phone number, Email"),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.editProfileScreen);
                      },
                    ),
                    const SizedBox(height: 10),
                    //-----------------the user favorite doctors-----------------//
                    ListTile(
                      leading: iconContainer(Icons.favorite_outline),
                      trailing: GradientBackground.gradientIcon(
                          Icons.arrow_forward_ios),
                      title: const Text("Favorite"),
                      subtitle: const Text("your favorite doctors"),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.favDoctors);
                        // !Handle favorite icon press later with database values
                      },
                    ),
                    const SizedBox(height: 10),
                    //---------------the user medical history------------------//
                    ListTile(
                      leading: iconContainer(Icons.medical_information),
                      trailing: GradientBackground.gradientIcon(
                          Icons.arrow_forward_ios),
                      title: const Text("Medical History"),
                      subtitle: const Text("View your medical records"),
                      onTap: () {
                        Navigator.pushNamed(
                            context, Routes.medicalHistoryScreen);
                      },
                    ),
                    const SizedBox(height: 10),
                    //----------the user settings------------//
                    ListTile(
                      leading: iconContainer(Icons.settings_outlined),
                      trailing: GradientBackground.gradientIcon(
                          Icons.arrow_forward_ios),
                      title: const Text("Settings"),
                      subtitle: const Text("manage your settings"),
                      onTap: () {
                        Navigator.pushNamed(context, Routes.settingsScreen);
                      },
                    ),
                    const SizedBox(height: 10),
                    //--------------the user profile logout---------------//
                    ListTile(
                      leading: iconContainer(Icons.logout_outlined),
                      title: const Text("Logout"),
                      onTap: () => _logout(context),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center();
        }
      },
    );
  }
}
