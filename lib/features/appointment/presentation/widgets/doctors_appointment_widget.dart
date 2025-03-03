import 'package:flutter/material.dart';

import '../views/doctors_appointment_view.dart';

class DoctorsAppointmentWidget extends StatelessWidget {
  const DoctorsAppointmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: const Scaffold(
        body: DoctorsAppointment(),
      ),
    );
  }
}
