// lib/doctors/presentation/views/doctors_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../fav_doctors/presentation/views/fav_doctors_view.dart';
import '../../../info/preentation/views/doctors_profile.dart';
import '../../domain/entities/doctor_entity.dart';
import '../cubit/doctors_cubit.dart';
import 'doctor_card.dart';


class DoctorsView extends StatefulWidget {
  const DoctorsView({Key? key}) : super(key: key);

  @override
  State<DoctorsView> createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  List<DoctorEntity> favDoctors = [];
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
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
        title: const Text('Doctors',style: TextStyle(fontSize: 25)),
        backgroundColor: const Color(0xFF0BDCDC),
      ),
      body: Column(
        children: [
          Padding(
        padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.black), // 👈 ده السطر اللي يغير لون النص
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF0BDCDC)),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
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
                    return name.contains(_searchQuery) || spec.contains(_searchQuery);
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
                      final isFav = favDoctors.any((d) => d.fullName == doctor.fullName);
                  return DoctorCard(
                    doctor: doctor,
                        isFavorite: isFav,
                    onFavorite: () {
                      setState(() {
                            if (isFav) {
                              favDoctors.removeWhere((d) => d.fullName == doctor.fullName);
                        } else {
                              favDoctors.add(doctor);
                        }
                      });
                    },
                        onInfo: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DoctorProfileScreen(doctorId: doctor.id,),
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
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              ),
            ),
          ],
      ),
    );
  }
}
