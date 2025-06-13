import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_colors.dart';
import 'package:health_care_app/core/utils/app_icons.dart';
import 'package:health_care_app/patient_features/main%20page/presentation/widgets/specialty.dart'
    as specialty_widget;

import '../../../../core/utils/doctor_specialties.dart';

class SpecializationsScreen extends StatefulWidget {
  const SpecializationsScreen({super.key});

  @override
  State<SpecializationsScreen> createState() => _SpecializationsScreenState();
}

class _SpecializationsScreenState extends State<SpecializationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _allSpecialties = [
    {'icon': AppIcons.cardiology, 'name': "Cardiology"},
    {'icon': AppIcons.dermatology, 'name': "Dermatology"},
    {'icon': AppIcons.generalMedicine, 'name': "General Medicine"},
    {'icon': AppIcons.gynecology, 'name': "Gynecology"},
    {'icon': AppIcons.dentistry, 'name': "Dentistry"},
    {'icon': AppIcons.oncology, 'name': "Oncology"},
    {'icon': AppIcons.orthopedics, 'name': "Orthopedics"},
    {'icon': AppIcons.ophtamology, 'name': "ophtamology"},
    {
      'icon': AppIcons.endocrinology,
      'name': DoctorSpecialtyName.endocrinology.name
    },
    {
      'icon': AppIcons.rheumatology,
      'name': DoctorSpecialtyName.rheumatology.name
    },
    {'icon': AppIcons.urology, 'name': DoctorSpecialtyName.urology.name},
    {
      'icon': AppIcons.gastroenterology,
      'name': DoctorSpecialtyName.gastroenterology.name
    },
    {
      'icon': AppIcons.pulmonology,
      'name': DoctorSpecialtyName.pulmonology.name
    },
  ];

  List<Map<String, dynamic>> get _filteredSpecialties {
    if (_searchQuery.isEmpty) {
      return _allSpecialties;
    }
    return _allSpecialties
        .where((specialty) => specialty['name']
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: AppBar(
          // the back button
          leading: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.transparent),
            ),
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          flexibleSpace: Container(
            padding: const EdgeInsets.only(top: 12),
            // for gradient color background
            decoration: BoxDecoration(gradient: AppColors.containerBackground),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Specializations",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Find the right doctor for you",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: Theme.of(context).textTheme.displayMedium,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: AppColors.primary),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.count(
                physics: const NeverScrollableScrollPhysics(), //for scroll
                crossAxisCount: 2,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                shrinkWrap: true,
                crossAxisSpacing: 8,
                mainAxisSpacing: 16,
                children: _filteredSpecialties
                    .map((specialty) => specialty_widget.specialty(
                          context,
                          specialty['icon'],
                          specialty['name'],
                        ))
                    .toList(),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
