import 'package:flutter/material.dart';
import '../views/doctor_home_view.dart';

class DoctorHomeWidget extends StatelessWidget {
  const DoctorHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DoctorHomeView(),
    );
  }
}
