import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../global/global_screens/login/presentation/widgets/login_widget.dart';
import '../../../doctors_appointment/presentation/views/doctors_appointement_avaliablity_view.dart';
import '../../../notifications/presentation/views/doctors_notification_screen.dart';
import '../../../patient_details_in_doctor/presentation/widgets/patient_details_in_doctor_widget.dart';
import '../../../doctors_date/presentation/widget/doctors_date_widget.dart';

class DoctorHomeView extends StatefulWidget {
  final String doctorId;
  final String token;

  const DoctorHomeView({
    Key? key,
    required this.doctorId,
    required this.token,
  }) : super(key: key);

  @override
  State<DoctorHomeView> createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<DoctorHomeView> {
  int _currentIndex = 0;
  int _notificationCount = 0;
  List<Map<String, dynamic>> appointments = [];
  bool isAppointmentsLoading = true;
  Set<int> rejectedAppointments = {};
  Set<int> acceptedAppointments = {};
  Set<int> completedAppointments = {};

  @override
  void initState() {
    super.initState();
    _loadPersistedStates();
    _fetchNotifications();
    _fetchAppointments();
  }

  Future<void> _loadPersistedStates() async {
    final prefs = await SharedPreferences.getInstance();
    final rejected = prefs.getStringList('rejectedAppointments') ?? [];
    final accepted = prefs.getStringList('acceptedAppointments') ?? [];
    final completed = prefs.getStringList('completedAppointments') ?? [];
    setState(() {
      rejectedAppointments = rejected.map((e) => int.tryParse(e) ?? -1).where((e) => e != -1).toSet();
      acceptedAppointments = accepted.map((e) => int.tryParse(e) ?? -1).where((e) => e != -1).toSet();
      completedAppointments = completed.map((e) => int.tryParse(e) ?? -1).where((e) => e != -1).toSet();
    });
  }

  Future<void> _persistStates() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('rejectedAppointments', rejectedAppointments.map((e) => e.toString()).toList());
    await prefs.setStringList('acceptedAppointments', acceptedAppointments.map((e) => e.toString()).toList());
    await prefs.setStringList('completedAppointments', completedAppointments.map((e) => e.toString()).toList());
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await Dio().get(
        'https://healthcaresystem.runasp.net/api/Notification/doctor/${widget.doctorId}',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> notifications = response.data;
        setState(() {
          _notificationCount = notifications.length;
        });
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      isAppointmentsLoading = true;
    });
    try {
      final response = await Dio().get(
        'https://healthcaresystem.runasp.net/api/Doctor/ViewAppointments',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
        queryParameters: {
          'doctorId': widget.doctorId,
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          appointments = List<Map<String, dynamic>>.from(response.data);
          isAppointmentsLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isAppointmentsLoading = false;
      });
      print('Error fetching appointments: $e');
    }
  }

  Future<void> _rejectAppointment(int appointmentId) async {
    try {
      final response = await Dio().put(
        'https://healthcaresystem.runasp.net/api/Doctor/Reject/$appointmentId',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );
      if (response.statusCode == 200) {
        setState(() {
          rejectedAppointments.add(appointmentId);
        });
        await _persistStates();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to reject appointment'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _acceptAppointment(int appointmentId) async {
    try {
      final response = await Dio().put(
        'https://healthcaresystem.runasp.net/api/Doctor/accept/$appointmentId',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );
      if (response.statusCode == 200) {
        setState(() {
          acceptedAppointments.add(appointmentId);
        });
        await _persistStates();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to accept appointment'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.green),
      );
    }
  }

  Future<void> _completeAppointment(int appointmentId) async {
    try {
      final response = await Dio().put(
        'https://healthcaresystem.runasp.net/api/Doctor/Completed/$appointmentId',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );
      if (response.statusCode == 200) {
        setState(() {
          completedAppointments.add(appointmentId);
        });
        await _persistStates();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Appointment marked as completed'), backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to complete appointment'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  List<Widget> get _pages => [
    DoctorHomeContent(
      notificationCount: _notificationCount,
      appointments: appointments,
      isAppointmentsLoading: isAppointmentsLoading,
      rejectedAppointments: rejectedAppointments,
      acceptedAppointments: acceptedAppointments,
      completedAppointments: completedAppointments,
      onReject: _rejectAppointment,
      onAccept: _acceptAppointment,
      onComplete: _completeAppointment,
    ),
    const DoctorDatesWidget(),
    const DoctorsAppointmentAvaliable(),
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
        selectedItemColor: const Color(0xFF0BDCDC),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 30),
            label: 'Set Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available_outlined, size: 30),
            label: 'Available',
          ),
        ],
      ),
    );
  }
}

class DoctorHomeContent extends StatelessWidget {
  final int notificationCount;
  final List<Map<String, dynamic>> appointments;
  final bool isAppointmentsLoading;
  final Set<int> rejectedAppointments;
  final Set<int> acceptedAppointments;
  final Set<int> completedAppointments;
  final Function(int) onReject;
  final Function(int) onAccept;
  final Function(int) onComplete;

  const DoctorHomeContent({
    Key? key,
    this.notificationCount = 0,
    required this.appointments,
    required this.isAppointmentsLoading,
    required this.rejectedAppointments,
    required this.acceptedAppointments,
    required this.completedAppointments,
    required this.onReject,
    required this.onAccept,
    required this.onComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: const BoxDecoration(
            color: Color(0xFFE0F7F7),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none, size: 27, color: Color(0xFF0BDCDC)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DoctorsNotificationScreen(),
                        ),
                      );
                    },
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$notificationCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout, size: 27, color: Colors.red),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                if (isAppointmentsLoading)
                  const Center(child: CircularProgressIndicator())
                else if (appointments.isEmpty)
                  const Center(child: Text('No appointments found'))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      final appointmentId = appointment['appointmentId'] as int;
                      final isRejected = rejectedAppointments.contains(appointmentId);
                      final isAccepted = acceptedAppointments.contains(appointmentId);
                      final isCompleted = completedAppointments.contains(appointmentId);
                      return GestureDetector(
                        onTap: () {
                          final patientId = appointment['patientId'];
                          print('Patient ID: $patientId');
                          if (patientId != null) {
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                          child: Card(
                            elevation: 2,
                            color: isRejected
                                ? Colors.red[100]
                                : isAccepted
                                ? Colors.green[100]
                                : isCompleted
                                ? Colors.blue[100]
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // CircleAvatar(
                                      //   radius: 28,
                                      //   backgroundImage: NetworkImage(appointment['patientImage'] ?? ''),
                                      // ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              appointment['patientFullName'] ?? '',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    _formatAppointmentTime(appointment),
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Buttons in a flexible layout
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      // Check if screen is too narrow for 3 buttons in a row
                                      if (constraints.maxWidth < 300) {
                                        return Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: _buildButton(
                                                    'Accept',
                                                    Colors.green,
                                                    (isRejected || isAccepted || isCompleted) ? null : () => onAccept(appointmentId),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: _buildButton(
                                                    'Reject',
                                                    Colors.red,
                                                    (isRejected || isAccepted || isCompleted) ? null : () => onReject(appointmentId),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              width: double.infinity,
                                              child: _buildButton(
                                                'Complete',
                                                Colors.blue,
                                                (isRejected || isAccepted || isCompleted) ? null : () => onComplete(appointmentId),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: _buildButton(
                                                'Accept',
                                                Colors.green,
                                                (isRejected || isAccepted || isCompleted) ? null : () => onAccept(appointmentId),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: _buildButton(
                                                'Reject',
                                                Colors.red,
                                                (isRejected || isAccepted || isCompleted) ? null : () => onReject(appointmentId),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: _buildButton(
                                                'Complete',
                                                Colors.blue,
                                                (isRejected || isAccepted || isCompleted) ? null : () => onComplete(appointmentId),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
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

  Widget _buildButton(String text, Color color, VoidCallback? onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(0, 32),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  String _formatAppointmentTime(Map<String, dynamic> appointment) {
    final date = DateTime.parse(appointment['appointmentDate']);
    final start = appointment['startTimeInHours'];
    final end = appointment['endTimeInHours'];
    return '${DateFormat('E d/M/yyyy').format(date)} $start:00 - $end:00';
  }
}