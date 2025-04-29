import 'package:flutter/material.dart';

import '../views/patient_details_in_doctor_view.dart';

class PatientDetailsInDoctorWidget extends StatelessWidget {
  const PatientDetailsInDoctorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0BDCDC),
          title: const Text(
            'Patient Details',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: const PatientDetailsInDoctorScreen(),
      ),
    );
  }
}
