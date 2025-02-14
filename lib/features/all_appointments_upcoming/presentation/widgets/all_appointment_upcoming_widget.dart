import 'package:flutter/material.dart';
import '../views/all_appointment_upcoming_view.dart';

class AllAppointments extends StatelessWidget {
  const AllAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0BDCDC),
        title: const Text('Cardiology', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const AllAppointmentUpcomingView(),
    );
  }
}
