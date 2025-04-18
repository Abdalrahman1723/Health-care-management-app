import 'package:flutter/material.dart';
import 'package:health_care_app/doctor_module/features/doctor_details_screen/presentation/view/DoctorDetailsScreenView.dart';



class Doctordetailswidget extends StatelessWidget {
  const Doctordetailswidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0BDCDC),
          title: const Text(
            'Doctor Details',
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
        body: const DoctorDetailsScreen(),
      ),
    );
  }
}
