import 'package:flutter/material.dart';
import '../views/doctors_profile.dart';

class DoctorsProfileWidget extends StatelessWidget {
  const DoctorsProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: const Scaffold(
        body: DoctorProfileScreen(),
      ),
    );
  }
}
