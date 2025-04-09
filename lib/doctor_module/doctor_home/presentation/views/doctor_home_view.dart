import 'package:flutter/material.dart';

import '../../../../patient_features/appointment/presentation/views/doctors_appointment_view.dart';
import '../../../doctors_appointment/presentation/widget/doctors_appointement_avaliablity_widget.dart';
import '../../../doctors_date/presentation/widget/doctors_date_widget.dart';
import '../../../doctors_notification/presentation/widgets/doctors_notification_widget.dart';
import '../../../patient_details_in_doctor/presentation/widgets/patient_details_in_doctor_widget.dart';

class DoctorHomeView extends StatefulWidget {
  const DoctorHomeView({Key? key}) : super(key: key);

  @override
  State<DoctorHomeView> createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<DoctorHomeView> {
  int _currentIndex = 0;

  // List of Screens
  final List<Widget> _pages = [
    const DoctorHomeContent(), // Home Screen
    const DoctorDatesWidget(), // Availability Screen
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 30),
            label: 'Availability',
          ),
        ],
      ),
    );
  }
}

// Extracted Home Screen Content for Clean Code
class DoctorHomeContent extends StatelessWidget {
  const DoctorHomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Welcome Back Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.blue[100],
                backgroundImage: const AssetImage(
                  'lib/core/assets/images/img.png', // Replace with actual image
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Dr. Andrew Smith',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_none, size: 27, color: Color(0xFF0BDCDC)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorsNotification()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.fact_check, size: 27, color: Color(0xFF0BDCDC)),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DoctorsAppointmentScreen()));
                },
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Upcoming Appointments Section
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming appointments',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Appointment List
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const PatientDetailsInDoctorWidget()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                'lib/core/assets/images/download.jpg', // Replace with actual image
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'James Harris',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'Psychologist | Mercy Hospital Patient',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 14,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Sat 12/5/2025 10:30am - 5:30pm',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
