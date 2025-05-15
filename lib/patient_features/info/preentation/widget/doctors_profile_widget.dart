import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/doctors_profile.dart';

class DoctorsProfileWidget extends StatelessWidget {
  final String fullName;
  final String specialization;
  final String photoUrl;

  const DoctorsProfileWidget({
    Key? key,
    required this.fullName,
    required this.specialization,
    required this.photoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: DoctorProfileScreen(
          fullName: fullName,
          specialization: specialization,
          photoUrl: photoUrl,
        ),
      ),
    );
  }
}
