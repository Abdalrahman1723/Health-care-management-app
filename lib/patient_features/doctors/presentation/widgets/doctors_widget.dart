import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/services/service_api.dart';
import '../../data/repo_impl/repo_impl.dart';
import '../cubit/doctors_cubit.dart';
import '../views/doctors_view.dart';

class DoctorsWidget extends StatelessWidget {
  final String? initialSpecialty;

  const DoctorsWidget({
    Key? key,
    this.initialSpecialty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorsCubit(
        RepoImpl(doctorsService: DoctorsService()),
      )..fetchDoctorsData(),
      child: DoctorsView(initialSpecialty: initialSpecialty),
    );
  }
}
