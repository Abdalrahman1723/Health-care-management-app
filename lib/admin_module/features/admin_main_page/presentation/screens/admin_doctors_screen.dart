import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/admin_module/features/admin_main_page/presentation/cubit/admin_main_page_cubit.dart';
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
  DoctorEntity? selectedDoctor;

  @override
  void initState() {
    super.initState();
    // Fetch doctors when screen loads
    log('Initializing AdminDoctorsScreen', name: 'ADMIN_DOCTORS');
    context.read<AdminMainPageCubit>().fetchDoctors();
  }

  //clear filters
  void clearFilters() {
    log('Clearing filters', name: 'ADMIN_DOCTORS');
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
    return BlocBuilder<AdminMainPageCubit, AdminMainPageState>(
      builder: (context, state) {
        // Handle loading state
        if (state is DoctorsLoading) {
          log('Loading doctors...', name: 'ADMIN_DOCTORS');
          return const Center(child: CircularProgressIndicator());
        }

        // Handle error state
        if (state is DoctorsError) {
          log('Error loading doctors: ${state.message}', name: 'ADMIN_DOCTORS');
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    log('Retrying to fetch doctors', name: 'ADMIN_DOCTORS');
                    context.read<AdminMainPageCubit>().fetchDoctors();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Handle loaded state
        if (state is DoctorsLoaded) {
          log('Doctors loaded successfully: ${state.doctors.length} doctors',
              name: 'ADMIN_DOCTORS');
          return Container(
            decoration: BoxDecoration(
              gradient: AdminAppColors.containerBackground,
            ),
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Column(
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
                  const Divider(
                    color: Colors.white,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 350,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
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
                                onPressed: clearFilters,
                                child: const Text("Clear")),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 300,
                              child: SearchAnchor.bar(
                                searchController: _searchController,
                                onChanged: (value) {
                                  if (value.isEmpty) {
                                    log('Search cleared',
                                        name: 'ADMIN_DOCTORS');
                                    setState(() {
                                      selectedDoctor = null;
                                    });
                                  }
                                },
                                barHintText: "name / ID",
                                suggestionsBuilder: (context, controller) =>
                                    searchBuilder(
                                        context, controller, state.doctors),
                              ),
                            )
                          ],
                        ),
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
                            log('Specialty selected: $value',
                                name: 'ADMIN_DOCTORS');
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
                        if (selectedDoctor == null && selectedSpecialty == null)
                          ...state.doctors.map((dr) => InkWell(
                                onTap: () {
                                  log('Doctor selected: ${dr.name}',
                                      name: 'ADMIN_DOCTORS');
                                  Navigator.pushNamed(
                                      context, Routes.doctorProfileScreen);
                                },
                                child: doctorDetails(
                                  context: context,
                                  doctor: dr,
                                ),
                              ))
                        else if (selectedSpecialty != null)
                          ...state.doctors
                              .where((dr) => dr.specialty == selectedSpecialty)
                              .map((dr) => InkWell(
                                    onTap: () {
                                      log('Doctor selected: ${dr.name}',
                                          name: 'ADMIN_DOCTORS');
                                      Navigator.pushNamed(
                                          context, Routes.doctorProfileScreen);
                                    },
                                    child: doctorDetails(
                                      context: context,
                                      doctor: dr,
                                    ),
                                  ))
                        else
                          doctorDetails(
                            context: context,
                            doctor: selectedDoctor!,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          );
        }

        // Default state
        return const Center(child: Text('No data available'));
      },
    );
  }

  // Search builder function
  FutureOr<Iterable<Widget>> searchBuilder(BuildContext context,
      SearchController controller, List<DoctorEntity> doctors) {
    final query = controller.text.toLowerCase().trim();
    log('Searching for: $query', name: 'ADMIN_DOCTORS');

    final results = doctors.where((doc) {
      return doc.name.toLowerCase().contains(query) ||
          doc.id.toLowerCase().contains(query);
    }).toList();

    log('Found ${results.length} results', name: 'ADMIN_DOCTORS');

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
          log('Doctor selected from search: ${doc.name}',
              name: 'ADMIN_DOCTORS');
          controller.closeView(doc.name);
          setState(() {
            selectedDoctor = doc;
          });
        },
      );
    });
  }
}

// Doctor details card widget
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
          doctorAvatar(
            imageUrl: doctor.imageUrl!.contains("http")
                ? doctor.imageUrl
                : ImageAsset.doctorImageFemale,
            size: 60,
          ),
          const SizedBox(width: 16.0),
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
