import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/constants.dart';
import 'package:health_care_app/core/utils/doctor_specialties.dart';
import 'package:health_care_app/patient_features/doctors/presentation/widgets/doctors_widget.dart';

Widget specialty(BuildContext context, String icon, String title) {
  // Convert the title to the corresponding DoctorSpecialty enum value
  String getSpecialtyValue(String title) {
    switch (title.toLowerCase()) {
      case 'cardiology':
        return DoctorSpecialty.cardiologist.name;
      case 'dermatology':
        return DoctorSpecialty.dermatologist.name;
      case 'general medicine':
        return DoctorSpecialty.generalPractitioner.name;
      case 'gynecology':
        return DoctorSpecialty.gynecologist.name;
      case 'dentistry':
        return DoctorSpecialty.dentist.name;
      case 'oncology':
        return DoctorSpecialty.oncologist.name;
      case 'orthopedics':
        return DoctorSpecialty.orthopedic.name;
      case 'ophthalmology':
        return DoctorSpecialty.ophthalmologist.name;
      case 'endocrinology':
        return DoctorSpecialty.endocrinologist.name;
      case 'rheumatology':
        return DoctorSpecialty.rheumatologist.name;
      case 'urology':
        return DoctorSpecialty.urologist.name;
      case 'gastroenterology':
        return DoctorSpecialty.gastroenterologist.name;
      case 'pulmonology':
        return DoctorSpecialty.pulmonologist.name;
      default:
        return DoctorSpecialty.generalPractitioner.name;
    }
  }

  return InkWell(
    borderRadius: BorderRadius.circular(16),
    splashColor: Colors.green,
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DoctorsWidget(initialSpecialty: getSpecialtyValue(title)),
        ),
      );
    },
    child: Container(
      height: Constants.containerWidthHight,
      width: Constants.containerWidthHight,
      decoration: BoxDecoration(
        gradient: AppColors.containerBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon.contains("svg")
              ? SvgPicture.asset(
                  icon,
                  height: 55,
                  width: 60,
                )
              : Image.asset(
                  icon,
                  color: Colors.white,
                  height: 55,
                  width: 60,
                ),
          Text(
            title,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
