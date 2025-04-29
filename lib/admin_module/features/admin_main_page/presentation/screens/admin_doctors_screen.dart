import 'dart:async';
import 'package:flutter/material.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/widgets/doctor_avatar.dart';
import 'package:health_care_app/config/routes/routes.dart';
import 'package:health_care_app/core/utils/assets_manager.dart';
import 'package:health_care_app/core/utils/camelcase_to_normal.dart';
import 'package:health_care_app/core/utils/doctor_specialties.dart';
import 'package:health_care_app/global/entities/doctor.dart';
import '../../../../../global/entities/time_slot.dart';
import '../../../../core/utils/admin_app_colors.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => _AdminDoctorsScreenState();
}

class _AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  DoctorSpecialty? selectedSpecialty; //for dropdown menu
  final SearchController _searchController = SearchController();

  //clear filters
  void clearFilters() {
    setState(() {
      selectedSpecialty = null;
      selectedDoctor = null;
      _searchController.clear();
    });
  }

  //dispose
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AdminAppColors.containerBackground,
      ),
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                  SizedBox(width: 20),
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
            //------------ doctors info section
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add filters"),
                      ElevatedButton(
                          onPressed: clearFilters, child: const Text("Clear")),
                    ],
                  ),
                  const SizedBox(height: 10),
                  //----------------search bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 300,
                        child: SearchAnchor.bar(
                          searchController: _searchController,
                          onChanged: (value) {
                            if (value.isEmpty) {
                              //if search value is null -> show all doctors
                              setState(() {
                                selectedDoctor = null;
                              });
                            }
                          },
                          barHintText: "name / ID",
                          suggestionsBuilder: searchBuilder,
                        ),
                      )
                    ],
                  ),
                  //specialty dropdown menu
                  DropdownButton(
                    dropdownColor: Colors.amber,
                    iconEnabledColor: Colors.green,
                    value: selectedSpecialty,
                    items: DoctorSpecialty.values.map((specialty) {
                      return DropdownMenuItem<DoctorSpecialty>(
                        value: specialty,
                        child: Text(camelCaseToNormal(specialty.name)
                            .toString()
                            .split('.')
                            .last),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedSpecialty = value!;
                        selectedDoctor = null;
                        _searchController.clear();
                      });
                    },
                  ),
                  const Divider(
                    indent: 15,
                    endIndent: 15,
                    color: Colors.white,
                    thickness: 1,
                  ),
                  //------------ doctors information cards
                  //doctors list example
                  if (selectedDoctor == null &&
                      selectedSpecialty ==
                          null) //no doctor selected -> show all
                    for (var dr in doctors)
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, Routes.doctorProfileScreen);
                        },
                        child: doctorDetails(
                          context: context,
                          doctor: dr,
                        ),
                      )
                  else if (selectedSpecialty != null)
                    for (var dr in doctors.where(
                      (dr) => dr.specialty == selectedSpecialty,
                    ))
                      InkWell(
                        onTap: () {
                          // Navigator.pushNamed(
                          //     context, Routes.appointmentDetailsScreen);
                        },
                        child: doctorDetails(
                          context: context,
                          doctor: dr,
                        ),
                      )
                  else //search result
                    doctorDetails(
                      context: context,
                      doctor: selectedDoctor!,
                    ),
                ],
              ),
            ),
            //the end of the information section
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

//--------------------------search builder
  DoctorEntity? selectedDoctor;

  FutureOr<Iterable<Widget>> searchBuilder(context, controller) {
    final query = controller.text.toLowerCase().trim();

    final results = doctors.where((doc) {
      return doc.name.toLowerCase().contains(query) ||
          doc.id.toLowerCase().contains(query);
    }).toList();

    return List<Widget>.generate(results.length, (index) {
      final doc = results[index];
      final isAvailable = doc.isAvailableAt(DateTime.now());
      return ListTile(
        leading: const Icon(Icons.person),
        title: Text(doc.name),
        subtitle:
            Text('${camelCaseToNormal(doc.specialty.name)} • ⭐ ${doc.rating}'),
        trailing: Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.red,
        ),
        onTap: () {
          controller.closeView(doc.name);
          setState(() {
            selectedDoctor = doc;
          });
        },
      );
    });
  }
}

//-------------------------- show doctor's card
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

//-----------dummy data for doctor user
final List<DoctorEntity> doctors = [
  DoctorEntity(
    id: 'D1',
    name: 'Dr. Alice Smith',
    specialty: DoctorSpecialty.cardiologist,
    rating: 4.8,
    imageUrl: ImageAsset.doctorImageFemale,
    availableSlots: [
      TimeSlotEntity(
          start: DateTime(2025, 4, 12, 9), end: DateTime(2025, 4, 12, 12)),
      TimeSlotEntity(
          start: DateTime(2025, 4, 13, 14), end: DateTime(2025, 4, 13, 17)),
    ],
  ),
  DoctorEntity(
    id: 'D2',
    name: 'Dr. Bob Johnson',
    specialty: DoctorSpecialty.neurologist,
    rating: 4.6,
    imageUrl: ImageAsset.doctorImageMale,
    availableSlots: [
      TimeSlotEntity(
          start: DateTime(2025, 4, 12, 10), end: DateTime(2025, 4, 12, 13)),
    ],
  ),
  DoctorEntity(
    id: 'D3',
    name: 'Dr. Clara Davis',
    specialty: DoctorSpecialty.pediatrician,
    rating: 4.9,
    imageUrl: ImageAsset.doctorImageFemale,
    availableSlots: [
      TimeSlotEntity(
          start: DateTime(2025, 4, 15, 13), end: DateTime(2025, 4, 15, 16)),
    ],
  ),
  DoctorEntity(
    id: 'D4',
    name: 'Dr. Michael Chen',
    specialty: DoctorSpecialty.dermatologist,
    rating: 4.7,
    imageUrl: ImageAsset.doctorImageMale,
    availableSlots: [
      TimeSlotEntity(
          start: DateTime(2025, 4, 14, 9), end: DateTime(2025, 4, 14, 12)),
      TimeSlotEntity(
          start: DateTime(2025, 4, 16, 14), end: DateTime(2025, 4, 16, 17)),
    ],
  ),
  DoctorEntity(
    id: 'D5',
    name: 'Dr. Sarah Wilson',
    specialty: DoctorSpecialty.orthopedic,
    rating: 4.5,
    imageUrl: ImageAsset.doctorImageFemale,
    availableSlots: [
      TimeSlotEntity(
          start: DateTime(2025, 4, 13, 8), end: DateTime(2025, 4, 13, 11)),
      TimeSlotEntity(
          start: DateTime(2025, 4, 17, 13), end: DateTime(2025, 4, 17, 16)),
    ],
  ),
  DoctorEntity(
    id: 'D6',
    name: 'Dr. James Brown',
    specialty: DoctorSpecialty.ophthalmologist,
    rating: 4.9,
    imageUrl: ImageAsset.doctorImageMale,
    availableSlots: [
      TimeSlotEntity(
          start: DateTime(2025, 4, 15, 10), end: DateTime(2025, 4, 15, 13)),
      TimeSlotEntity(
          start: DateTime(2025, 4, 18, 9), end: DateTime(2025, 4, 18, 12)),
    ],
  ),
  DoctorEntity(
    id: 'D7',
    name: 'Dr. Emily Taylor',
    specialty: DoctorSpecialty.psychiatrist,
    rating: 4.8,
    imageUrl: ImageAsset.doctorImageFemale,
    availableSlots: [
      TimeSlotEntity(
          start: DateTime(2025, 4, 14, 14), end: DateTime(2025, 4, 14, 17)),
      TimeSlotEntity(
          start: DateTime(2025, 4, 19, 10), end: DateTime(2025, 4, 19, 13)),
    ],
  ),
  DoctorEntity(
    id: 'D8',
    name: 'Dr. Robert Garcia',
    specialty: DoctorSpecialty.generalPractitioner,
    rating: 4.6,
    imageUrl: ImageAsset.doctorImageMale,
    availableSlots: [
      TimeSlotEntity(
          start: DateTime(2025, 4, 16, 8), end: DateTime(2025, 4, 16, 12)),
      TimeSlotEntity(
          start: DateTime(2025, 4, 18, 14), end: DateTime(2025, 4, 18, 17)),
    ],
  ),
];
