import 'package:flutter/material.dart';
import '../views/doctors_appointment_view.dart';

class DoctorsAppointmentWidget extends StatelessWidget {
  final String fullName;
  final String specialization;
  final String photoUrl;
  final int doctorId;

  const DoctorsAppointmentWidget({
    Key? key,
    required this.fullName,
    required this.specialization,
    required this.photoUrl,
    required this.doctorId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: DoctorsAppointment(
          doctorName: fullName,
          specialty: specialization,
          doctorImage: photoUrl,
          doctorId: doctorId,
        ),
      ),
    );
  }
}
