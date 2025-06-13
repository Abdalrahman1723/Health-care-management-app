// lib/doctors/presentation/views/doctors_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/utils/doctor_specialties.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../fav_doctors/presentation/views/fav_doctors_view.dart';
import '../../../info/preentation/views/doctors_profile.dart';
import '../../domain/entities/doctor_entity.dart';
import '../cubit/doctors_cubit.dart';
import 'doctor_card.dart';

class DoctorsView extends StatefulWidget {
  final String? initialSpecialty;
  const DoctorsView({Key? key, this.initialSpecialty}) : super(key: key);

  @override
  State<DoctorsView> createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  List<DoctorEntity> favDoctors = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedSpecialty;

  @override
  void initState() {
    super.initState();
    _selectedSpecialty = widget.initialSpecialty;
    _loadDoctors();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      context.read<DoctorsCubit>().fetchDoctorsData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors', style: TextStyle(fontSize: 25)),
        backgroundColor: const Color(0xFF0BDCDC),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: _selectedSpecialty,
                decoration: InputDecoration(
                  labelText: 'Filter by Specialty',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      'All Specialties',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  ...DoctorSpecialty.values
                      .map((specialty) => DropdownMenuItem<String>(
                            value: specialty.name,
                            child: Text(
                              specialty.name,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedSpecialty = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(
                    color: Colors.black), // 👈 ده السطر اللي يغير لون النص
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF0BDCDC)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<DoctorsCubit, DoctorsState>(
                builder: (context, state) {
                  if (state is DoctorsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is DoctorsSuccess) {
                    final filteredDoctors = state.entities.where((doctor) {
                      final name = doctor.fullName.toLowerCase();
                      final spec = doctor.specialization.toLowerCase();
                      final matchesSearch = name.contains(_searchQuery) ||
                          spec.contains(_searchQuery);
                      final matchesSpecialty = _selectedSpecialty == null ||
                          doctor.specialization == _selectedSpecialty;
                      return matchesSearch && matchesSpecialty;
                    }).toList();
                    if (filteredDoctors.isEmpty) {
                      return const Center(
                        child: Text(
                          'No doctors found',
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: filteredDoctors.length,
                      itemBuilder: (context, index) {
                        final doctor = filteredDoctors[index];
                        final isFav = favDoctors
                            .any((d) => d.fullName == doctor.fullName);
                        return DoctorCard(
                          doctor: doctor,
                          isFavorite: isFav,
                          onFavorite: () {
                            setState(() {
                              if (isFav) {
                                favDoctors.removeWhere(
                                    (d) => d.fullName == doctor.fullName);
                              } else {
                                favDoctors.add(doctor);
                              }
                            });
                          },
                          onInfo: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DoctorProfileScreen(
                                  doctorId: doctor.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is DoctorsFailure) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${state.errMessage}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadDoctors,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FavDoctors(
                          favoriteDoctors: favDoctors,
                          onFavChanged: (updatedFavs) {
                            setState(() {
                              favDoctors = updatedFavs;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0BDCDC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Go to Fav Doctors',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
