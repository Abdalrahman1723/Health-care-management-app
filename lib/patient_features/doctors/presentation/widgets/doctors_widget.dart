import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/doctors_cubit.dart';
import '../views/doctors_view.dart';
import '../../data/datasources/doctor_remote_data_source.dart';
import '../../data/repositories/doctor_repository_impl.dart';
import '../../domain/usecases/get_all_doctors_usecase.dart';

class DoctorsWidget extends StatelessWidget {
  const DoctorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorsCubit(
        GetAllDoctorsUseCase(
          DoctorRepositoryImpl(
            DoctorRemoteDataSource(Dio()),
          ),
        ),
      ),
      child: const DoctorsView(),
    );
  }
}
