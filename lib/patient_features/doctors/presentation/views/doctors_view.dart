// lib/doctors/presentation/views/doctors_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../appointment/presentation/widgets/doctors_appointment_widget.dart';
import '../../../fav_doctors/presentation/views/fav_doctors_view.dart';
import '../../domain/entity.dart';
import '../cubit/cubit_doctors_cubit.dart';
import 'doctor_card.dart';

class DoctorsView extends StatefulWidget {
  const DoctorsView({super.key});

  @override
  _DoctorsViewState createState() => _DoctorsViewState();
}

class _DoctorsViewState extends State<DoctorsView> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  List<Entity> favoriteDoctors = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: const TextStyle(color: Color(0xFF0BDCDC), fontSize: 17),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search, color: Color(0xFF0BDCDC)),
            ),
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: BlocBuilder<DoctorsCubit, DoctorsState>(
              builder: (context, state) {
                if (state is DoctorsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DoctorsFailure) {
                  return Center(child: Text(state.errMessage));
                } else if (state is DoctorsSuccess) {
                  List<Entity> filteredDoctors = state.entities.where((doctor) {
                    return doctor.fullName.toLowerCase().contains(_searchQuery) ||
                        doctor.specialization.toLowerCase().contains(_searchQuery);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = filteredDoctors[index];
                      final isFav = favoriteDoctors.contains(doctor);

                      return DoctorCard(
                        doctor: doctor,
                        isFavorite: isFav,
                        onFavorite: () {
                          setState(() {
                            if (isFav) {
                              favoriteDoctors.remove(doctor);
                            } else {
                              favoriteDoctors.add(doctor);
                            }
                          });
                        },
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink(); // DoctorsInitial
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavDoctors(
                    favoriteDoctors: favoriteDoctors,
                  ),
                ),
              );
            },
            child: const Text('Go to Favorite Doctors'),
          ),
        ],
      ),
    );
  }
}
