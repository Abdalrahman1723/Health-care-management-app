import 'package:flutter/material.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/widgets/doctor_avatar.dart';
import 'package:health_care_app/core/utils/assets_manager.dart';
import 'package:health_care_app/core/utils/camelcase_to_normal.dart';
import 'package:health_care_app/core/utils/doctor_specialties.dart';
import 'package:health_care_app/global/entities/doctor.dart';
import '../../../../core/utils/admin_app_colors.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => _AdminDoctorsScreenState();
}

class _AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AdminAppColors.containerBackground,
      ),
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          //---------Header section
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("All Doctors",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            //------------ divider
            const Divider(
              color: Colors.white,
              thickness: 2,
              indent: 15,
              endIndent: 15,
            ),
            //------------ date picker section
            const SizedBox(height: 15),
            Container(
              width: 350,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //---see all appointments button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange),
                        onPressed: () {
                          //todo navigate to all appointments screen
                          // Navigator.pushNamed(
                          //     context, Routes.allAppointments);
                          // Handle see all appointments button press
                        },
                        child: const Text(
                          "See all",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  //------------ doctor information

                  //doctor 1 example

                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(
                      //     context, Routes.appointmentDetailsScreen);
                    },
                    child: doctorDetails(
                      context: context,
                      doctor: DoctorEntity(
                          id: '1234',
                          name: "Dr. John Doe",
                          specialty: DoctorSpecialty.orthopedic,
                          rating: 4.5,
                          imageUrl: ImageAsset.doctorImageMale,
                          availableSlots: []),
                    ),
                  ),

                  //doctor 2 example
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.appointmentDetailsScreen),
                    },
                    child: doctorDetails(
                      context: context,
                      doctor: DoctorEntity(
                          id: '1234',
                          name: "Dr. Sarah Smith",
                          specialty: DoctorSpecialty.generalPractitioner,
                          rating: 4.5,
                          imageUrl: ImageAsset.doctorImageFemale,
                          availableSlots: []),
                    ),
                  ),
                  //doctor 2 example
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.appointmentDetailsScreen),
                    },
                    child: doctorDetails(
                      context: context,
                      doctor: DoctorEntity(
                          id: '1234',
                          name: "Dr. Sarah Smith",
                          specialty: DoctorSpecialty.generalPractitioner,
                          rating: 4.5,
                          imageUrl: ImageAsset.doctorImageFemale,
                          availableSlots: []),
                    ),
                  ),
                  //doctor 2 example
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.appointmentDetailsScreen),
                    },
                    child: doctorDetails(
                      context: context,
                      doctor: DoctorEntity(
                          id: '1234',
                          name: "Dr. Sarah Smith",
                          specialty: DoctorSpecialty.generalPractitioner,
                          rating: 4.5,
                          imageUrl: ImageAsset.doctorImageFemale,
                          availableSlots: []),
                    ),
                  ),
                  //doctor 2 example
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.appointmentDetailsScreen),
                    },
                    child: doctorDetails(
                      context: context,
                      doctor: DoctorEntity(
                          id: '1234',
                          name: "Dr. Sarah Smith",
                          specialty: DoctorSpecialty.generalPractitioner,
                          rating: 4.5,
                          imageUrl: ImageAsset.doctorImageFemale,
                          availableSlots: []),
                    ),
                  ),
                  //doctor 2 example
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.appointmentDetailsScreen),
                    },
                    child: doctorDetails(
                      context: context,
                      doctor: DoctorEntity(
                          id: '1234',
                          name: "Dr. Sarah Smith",
                          specialty: DoctorSpecialty.generalPractitioner,
                          rating: 4.5,
                          imageUrl: ImageAsset.doctorImageFemale,
                          availableSlots: []),
                    ),
                  ),
                  //doctor 2 example
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.appointmentDetailsScreen),
                    },
                    child: doctorDetails(
                      context: context,
                      doctor: DoctorEntity(
                          id: '1234',
                          name: "Dr. Sarah Smith",
                          specialty: DoctorSpecialty.generalPractitioner,
                          rating: 4.5,
                          imageUrl: ImageAsset.doctorImageFemale,
                          availableSlots: []),
                    ),
                  ),
                  //doctor 2 example
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.pushNamed(context, Routes.appointmentDetailsScreen),
                    },
                    child: doctorDetails(
                      context: context,
                      doctor: DoctorEntity(
                          id: '1234',
                          name: "Dr. Sarah Smith",
                          specialty: DoctorSpecialty.generalPractitioner,
                          rating: 4.5,
                          imageUrl: ImageAsset.doctorImageFemale,
                          availableSlots: []),
                    ),
                  ),
                ],
              ),
            ),
            //the end of the information section
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

//-----------------------------------
Widget doctorDetails({
  required BuildContext context,
  required DoctorEntity doctor,
}) {
  return Card(
    margin: const EdgeInsets.all(16.0),
    color: Colors.green.withOpacity(0.99),
    elevation: 4.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Doctor Avatar
          doctorAvatar(
            imageUrl: doctor.imageUrl,
            size: 60,
          ),
          const SizedBox(width: 16.0),
          // Doctor info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                Text(
                  camelCaseToNormal(doctor.specialty.name),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white, fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16.0,
                      color: Colors.yellow,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      doctor.rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
