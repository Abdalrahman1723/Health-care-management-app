import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../views/doctors_profile.dart';
import '../../../doctors/domain/entities/doctor_entity.dart';

class DoctorsProfileWidget extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorsProfileWidget({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(),
      child: Scaffold(
        body: DoctorProfileScreen(
          doctorId: doctor.id,
        ),
      ),
    );
  }
}
