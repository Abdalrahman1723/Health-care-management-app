// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/app_icons.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/appointment_details.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/avatar.dart';
import 'package:calendar_day_slot_navigator/calendar_day_slot_navigator.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/header.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/specialty.dart';

import '../cubit/patient_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _selectedDate = DateTime.now();
  static const String patientID =
      "1"; //! this is a temp (later should be actorId) with shared pref

  @override
  void initState() {
    super.initState();
    // Fetch patient with ID 3 when screen loads
    context.read<PatientCubit>().fetchPatientById(patientID);
    context.read<PatientCubit>().fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    //update the date to selected date
    void _updateDate(DateTime newDate) {
      setState(() {
        _selectedDate = newDate;
      });
      log("Selected date: $_selectedDate");
    }

    return BlocBuilder<PatientCubit, PatientState>(
      builder: (context, state) {
        // ==========loading state =============//
        if (state is PatientLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );

          // ==========error state =============//
        } else if (state is PatientError) {
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
                            .read<PatientCubit>()
                            .fetchPatientById(patientID);
                      },
                      child: const Text("restart connection"))
                ],
              ),
            ),
          );
          // ==========success state =============//
        } else if (state is PatientLoaded) {
          //good to go
          return Scaffold(
            appBar: AppBar(
                title: Column(
                  children: [
                    GradientBackground.gradientText("Hi, Welcome back!"),
                    Text(
                      state.patient.name,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  //--------the avatar
                  child: avatar(
                      context: context,
                      // imageUrl: state.patient.imageUrl, //?empty for now
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
                              Navigator.pushNamed(
                                  context, Routes.notificationsScreen);
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
                              Navigator.pushNamed(
                                  context, Routes.settingsScreen);
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
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GradientBackground.gradientText("Categories",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
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
                            Navigator.pushNamed(context, Routes.favDoctors);
                            // !Handle favorite icon press later with database values
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
                            Navigator.pushNamed(context, Routes.allDoctors);
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
                            Navigator.pushNamed(
                                context, Routes.specializationsScreen);
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
                    //--------------- information section----------------//
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.containerBackground,
                      ),
                      width: double.infinity,
                      child: Column(
                        //---------Header section
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Your Appointments",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 20,
                                ),
                                //months button
                                Text(
                                  "Months&Year",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<PatientCubit>()
                                            .fetchPatientById(patientID);
                                        context
                                            .read<PatientCubit>()
                                            .fetchAppointments();
                                      },
                                      icon: const Icon(Icons.refresh),
                                    ),
                                    //---see all appointments button
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, Routes.allAppointments);
                                      },
                                      child: const Text(
                                        "See all",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold),
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
                                //---------------appointment information---------------//
                                if (state.appointment.isNotEmpty)
                                  ...state.appointment.map((appointment) =>
                                      Column(
                                        children: [
                                          const Divider(
                                            indent: 15,
                                            endIndent: 15,
                                            color: Colors.white,
                                            thickness: 1,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context,
                                                  Routes
                                                      .appointmentDetailsScreen);
                                            },
                                            child: appointmentDetails(
                                                doctorName:
                                                    appointment?.doctor ??
                                                        "Unknown Doctor",
                                                selectedDate: DateTime.parse(
                                                    appointment
                                                            ?.appointmentDate ??
                                                        DateTime.now()
                                                            .toIso8601String()),
                                                context: context),
                                          ),
                                        ],
                                      )),
                                if ((state.appointment.isEmpty ||
                                    state.appointment.every((a) => a == null)))
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Text(
                                      "No appointments found",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
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
                        title: "specialties",
                        buttonText: "See all",
                        route: Routes.specializationsScreen),
                    //------------ specialties list section

                    GridView.count(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      //specialties list
                      children: [
                        //specialty 1
                        specialty(AppIcons.cardiology, "Cardiology"),
                        //specialty 2
                        specialty(AppIcons.dermatology, "Dermatology"),
                        //specialty 3
                        specialty(AppIcons.generalMedicine, "General Medicine"),
                        //specialty 4
                        specialty(AppIcons.gynecology, "Gynecology"),
                        //specialty 5
                        specialty(AppIcons.dentistry, "Dentistry"),
                        //specialty 6
                        specialty(AppIcons.oncology, "Oncology"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          //=====================no appointments=====================//
        } else if (state is PatientLoadedWithNoAppointments) {
          return Scaffold(
            appBar: AppBar(
                title: Column(
                  children: [
                    GradientBackground.gradientText("Hi, Welcome back!"),
                    Text(
                      state.patient.name,
                      style: const TextStyle(color: Colors.black),
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
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: IconButton(
                            icon: const Icon(Icons.notifications_none),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, Routes.notificationsScreen);
                            },
                          ),
                        ),
                        const SizedBox(width: 3),
                        SizedBox(
                          width: 35,
                          height: 35,
                          child: IconButton(
                            icon: const Icon(Icons.settings_outlined),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, Routes.settingsScreen);
                            },
                          ),
                        ),
                        const SizedBox(width: 3),
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // ... (keep all the categories and other sections)
                    Container(
                      decoration: BoxDecoration(
                        gradient: AppColors.containerBackground,
                      ),
                      width: double.infinity,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Your Appointments",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  "Months&Year",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.white,
                            thickness: 2,
                            indent: 15,
                            endIndent: 15,
                          ),
                          CalendarDaySlotNavigator(
                            isGoogleFont: false,
                            slotLength: 6,
                            dayBoxHeightAspectRatio: 4,
                            dayDisplayMode: DayDisplayMode.outsideDateBox,
                            headerText: "Select Date",
                            onDateSelect: (selectedDate) {
                              _updateDate(selectedDate);
                            },
                          ),
                          const SizedBox(height: 15),
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
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        context
                                            .read<PatientCubit>()
                                            .fetchPatientById(patientID);
                                        context
                                            .read<PatientCubit>()
                                            .fetchAppointments();
                                      },
                                      icon: const Icon(Icons.refresh),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, Routes.allAppointments);
                                      },
                                      child: const Text(
                                        "See all",
                                        style: TextStyle(
                                            color: Colors.blueGrey,
                                            decoration:
                                                TextDecoration.underline,
                                            fontWeight: FontWeight.bold),
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
                                const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    "No appointments found",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    // ... (keep the rest of the UI elements)
                  ],
                ),
              ),
            ),
          );
        } else {
          log(name: "ERROR", state.runtimeType.toString());
          return const Center();
        }
      },
    );
  }
}
