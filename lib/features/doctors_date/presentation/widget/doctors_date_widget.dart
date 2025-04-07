import 'package:flutter/material.dart';

import '../view/doctors_date_view.dart';


class DoctorDatesWidget extends StatelessWidget {
  const DoctorDatesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0BDCDC),
          title:
          const Text('Available Dates', style: TextStyle(color: Colors.white)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const DoctorsDates(),
      ),
    );
  }
}