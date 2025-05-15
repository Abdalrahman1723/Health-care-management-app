import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/patient_features/doctors/data/services/service_api.dart';
import 'package:health_care_app/patient_features/doctors/presentation/cubit/cubit_doctors_cubit.dart';
import 'package:health_care_app/patient_features/doctors/presentation/views/doctors_view.dart';

import '../../data/repo_impl/repo_impl.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      DoctorsCubit(RepoImpl(newsService: NewsService()))..fetchDoctorsData(),
      child: Theme(
        data: ThemeData(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF0BDCDC),
            title: const Text('Cardiology', style: TextStyle(color: Colors.white)),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: const DoctorsView(),
        ),
      ),
    );
  }
}
