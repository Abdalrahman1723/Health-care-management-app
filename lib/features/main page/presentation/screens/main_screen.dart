// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/app_icons.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';
import 'package:health_care_app/features/main%20page/presentation/widgets/appointment_details.dart';
import 'package:health_care_app/features/main%20page/presentation/widgets/avatar.dart';
import 'package:calendar_day_slot_navigator/calendar_day_slot_navigator.dart';
import 'package:health_care_app/features/main%20page/presentation/widgets/header.dart';
import 'package:health_care_app/features/main%20page/presentation/widgets/specialty.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    void _updateDate(DateTime newDate) {
      setState(() {
        _selectedDate = newDate;
      });
      log("Selected date: $_selectedDate");
    }

    return Scaffold(
      appBar: AppBar(
          title: Column(
            children: [
              GradientBackground.gradientText("Hi, Welcome back!"),
              const Text(
                'Abdalrahman', //later will be replaced with the user name
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: avatar(
                context: context,
                editIconSize: 8,
                avatarSize: 20,
                route: Routes.userProfileScreen),
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

      //------------------------ body section --------------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //------------ Categories button section
              Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GradientBackground.gradientText("Categories",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  //------------ divider
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                    indent: 15,
                    endIndent: 15,
                  ),
                ],
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

              //------------ divider box
              const SizedBox(
                height: 12,
              ),
              //------------ information section
              Container(
                decoration: BoxDecoration(
                  gradient: AppColors.containerBackground,
                ),
                width: double.infinity,
                child: Column(
                  //---------Header section
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Upcoming Appointments",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 20,
                          ),
                          //monthes button
                          Text(
                            "Monthes&Year",
                            style: TextStyle(
                                // decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    //------------ divider
                    const Divider(
                      color: Colors.white,
                      thickness: 2,
                      indent: 15,
                      endIndent: 15,
                    ),
                    //------------ date picker section
                    CalendarDaySlotNavigator(
                      isGoogleFont: false,
                      slotLength: 6,
                      dayBoxHeightAspectRatio: 4,
                      dayDisplayMode: DayDisplayMode.outsideDateBox,
                      headerText: "Select Date",
                      onDateSelect: (selectedDate) {
                        _updateDate(selectedDate);
                        // print("Selected date: $selectedDate");  //default
                        //?here should send the selected date to the backend
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: 300,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Handle see all appointments button press
                                },
                                child: const Text(
                                  "See all",
                                  style: TextStyle(
                                      color: Colors.white,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          const Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.white,
                            thickness: 1,
                          ),
                          //------------ appointment information

                          //appointment 1

                          appointmentDetails(
                              doctorName: 'Ahmed Essam',
                              selectedDate: _selectedDate,
                              context: context),

                          //appointment 2
                          const Divider(
                            indent: 15,
                            endIndent: 15,
                            color: Colors.white,
                            thickness: 1,
                          ),
                          appointmentDetails(
                              doctorName: 'Helana Emad',
                              selectedDate: _selectedDate,
                              context: context),
                        ],
                      ),
                    ),
                    //the end of the information section
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              header(
                  context: context,
                  title: "specilaties",
                  buttonText: "See all",
                  route: Routes.specializationsScreen),
              //------------ specilaties list section

              GridView.count(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                crossAxisCount: 3,
                shrinkWrap: true,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                //specilaties list
                children: [
                  //specilaty 1
                  specilaty(AppIcons.cardiology, "Cardiology"),
                  //specilaty 2
                  specilaty(AppIcons.dermatology, "Dermatology"),
                  //specilaty 3
                  specilaty(AppIcons.generalMedicine, "General Medicine"),
                  //specilaty 4
                  specilaty(AppIcons.gynecology, "Gynecology"),
                  //specilaty 5
                  specilaty(AppIcons.odontology, "Odontology"),
                  //specilaty 6
                  specilaty(AppIcons.oncology, "Oncology"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
