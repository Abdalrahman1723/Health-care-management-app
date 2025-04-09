import 'package:flutter/material.dart';

import '../../../../patient_features/appointment/presentation/views/doctors_appointment_view.dart';
import '../views/doctors_appointement_avaliablity_view.dart';


class DoctorsAppointmentScreen extends StatelessWidget {
  const DoctorsAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0BDCDC),
          title:
          const Text('My Appointment', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const DoctorsAppointmentAvaliable(),
      ),
    );
  }
}
