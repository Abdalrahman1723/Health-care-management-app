// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/app_icons.dart';
import 'package:health_care_app/core/utils/camelcase_to_normal.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';
import 'package:health_care_app/patient_features/add_review/presentation/screens/add_review_screen.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/appointment_details.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/avatar.dart';
import 'package:calendar_day_slot_navigator/calendar_day_slot_navigator.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/header.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/specialty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:health_care_app/patient_features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:health_care_app/patient_features/notifications/presentation/cubit/notification_state.dart';

import '../../../../core/utils/doctor_specialties.dart';
import '../../../info/preentation/views/doctors_profile.dart';
import '../cubit/patient_cubit.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _imagePath;
  String? patientID;

  Future<void> _loadImageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString('profile_image');
    if (savedImagePath != null) {
      setState(() {
        _imagePath = savedImagePath;
      });
    }
  }

  Future<void> _loadPatientId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('actorId');
    if (id != null && id.isNotEmpty) {
      setState(() {
        patientID = id;
      });
      if (mounted) {
        context.read<PatientCubit>().fetchPatientById(id);
        context.read<PatientCubit>().fetchAppointments();
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to load profile: Patient ID not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImageFromPrefs();
    _loadPatientId();
    // Fetch notifications when the screen loads
    if (patientID != null) {
      context.read<NotificationCubit>().fetchNotifications(patientID!);
    }
  }

  //refresh screen
  Future<void> _refreshData() async {
    setState(() {
      _loadImageFromPrefs();
      _loadPatientId();
    });
    // Refresh notifications when pulling to refresh
    if (patientID != null) {
      context.read<NotificationCubit>().fetchNotifications(patientID!);
    }
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
                        if (patientID != null) {
                          context
                              .read<PatientCubit>()
                              .fetchPatientById(patientID!);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Unable to load profile: Patient ID not found'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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
                      imageUrl: _imagePath,
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
                          child: Stack(
                            children: [
                              IconButton(
                                icon: BlocBuilder<NotificationCubit,
                                    NotificationState>(
                                  builder: (context, state) {
                                    final unreadCount = context
                                        .read<NotificationCubit>()
                                        .getUnreadCount();
                                    return Icon(
                                      unreadCount > 0
                                          ? Icons.notifications_active
                                          : Icons.notifications_none,
                                      color:
                                          unreadCount > 0 ? Colors.blue : null,
                                    );
                                  },
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.notificationsScreen);
                                },
                              ),
                              BlocBuilder<NotificationCubit, NotificationState>(
                                builder: (context, state) {
                                  final unreadCount = context
                                      .read<NotificationCubit>()
                                      .getUnreadCount();
                                  if (unreadCount > 0) {
                                    return Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
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
                              Navigator.pushNamed(
                                  context, Routes.specializationsScreen);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]),

            //------------------------ body section --------------------------------
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: _refreshData,
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
                              Navigator.pushNamed(context, Routes.allDoctors);
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Your Appointments",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                              width: 350,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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

                                  //---------------appointment information---------------//
                                  if (state.appointment.isNotEmpty)
                                    ...state.appointment
                                        .where((appointment) =>
                                            appointment?.appointmentDateTime !=
                                                null &&
                                            appointment!
                                                    .appointmentDateTime.year ==
                                                _selectedDate.year &&
                                            appointment.appointmentDateTime
                                                    .month ==
                                                _selectedDate.month &&
                                            appointment
                                                    .appointmentDateTime.day ==
                                                _selectedDate.day)
                                        .map((appointment) => Column(
                                              children: [
                                                const Divider(
                                                  indent: 15,
                                                  endIndent: 15,
                                                  color: Colors.white,
                                                  thickness: 1,
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context)
                                                        .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          DoctorProfileScreen(
                                                        doctorId: appointment
                                                            .doctorId,
                                                      ),
                                                    ));
                                                  },
                                                  child: appointmentDetails(
                                                      doctorName:
                                                          "Dr. ${appointment?.doctor}",
                                                      selectedDate: appointment
                                                              ?.appointmentDateTime ??
                                                          DateTime.now(),
                                                      context: context,
                                                      startTimeInHours:
                                                          appointment!
                                                              .startTimeInHours,
                                                      endTimeInHours:
                                                          appointment
                                                              .endTimeInHours),
                                                ),
                                              ],
                                            )),
                                  if (state.appointment.isEmpty ||
                                      state.appointment
                                          .every((a) => a == null) ||
                                      !state.appointment.any((appointment) =>
                                          appointment?.appointmentDateTime !=
                                              null &&
                                          appointment!
                                                  .appointmentDateTime.year ==
                                              _selectedDate.year &&
                                          appointment
                                                  .appointmentDateTime.month ==
                                              _selectedDate.month &&
                                          appointment.appointmentDateTime.day ==
                                              _selectedDate.day))
                                    const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        "No appointments found for selected date",
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
                          specialty(context, AppIcons.cardiology,
                              DoctorSpecialtyName.cardiology.name),
                          //specialty 2
                          specialty(context, AppIcons.dermatology,
                              DoctorSpecialtyName.dermatology.name),
                          //specialty 3
                          specialty(
                              context,
                              AppIcons.generalMedicine,
                              camelCaseToNormal(
                                  DoctorSpecialtyName.generalMedicine.name)),
                          //specialty 4
                          specialty(context, AppIcons.gynecology,
                              DoctorSpecialtyName.gynecology.name),
                          //specialty 5
                          specialty(context, AppIcons.dentistry,
                              DoctorSpecialtyName.dentistry.name),
                          //specialty 6
                          specialty(context, AppIcons.oncology,
                              DoctorSpecialtyName.oncology.name),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //--------------------FAB--------------------//
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.predictionScreen);
              },
              tooltip: "AI diagnosis",
              child: const Icon(Icons.chat),
            ),
          );
          //=====================no appointments=====================//
        } // -------------no appointment state -------------------//
        else if (state is PatientLoadedWithNoAppointments) {
          log("==============no appointments state");
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
                          child: Stack(
                            children: [
                              IconButton(
                                icon: BlocBuilder<NotificationCubit,
                                    NotificationState>(
                                  builder: (context, state) {
                                    final unreadCount = context
                                        .read<NotificationCubit>()
                                        .getUnreadCount();
                                    return Icon(
                                      unreadCount > 0
                                          ? Icons.notifications_active
                                          : Icons.notifications_none,
                                      color:
                                          unreadCount > 0 ? Colors.blue : null,
                                    );
                                  },
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, Routes.notificationsScreen);
                                },
                              ),
                              BlocBuilder<NotificationCubit, NotificationState>(
                                builder: (context, state) {
                                  final unreadCount = context
                                      .read<NotificationCubit>()
                                      .getUnreadCount();
                                  if (unreadCount > 0) {
                                    return Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          unreadCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ],
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
                              Navigator.pushNamed(
                                  context, Routes.specializationsScreen);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
            body: SafeArea(
              child: RefreshIndicator(
                onRefresh: _refreshData,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Your Appointments",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {},
                                          child: const Icon(Icons.abc)),
                                      IconButton(
                                        onPressed: () {
                                          context
                                              .read<PatientCubit>()
                                              .fetchPatientById(patientID!);
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
            ),
          );
        } else {
          log(name: "ERROR", state.runtimeType.toString());
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  DateTime _parseAppointmentDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      log('Error parsing date: $dateStr', name: "DATE_PARSE");
      return DateTime.now();
    }
  }
}
