import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/entities/doctor.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';

part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final ApiClient apiClient;
  final String authToken;

  PatientCubit({required this.apiClient, required this.authToken})
      : super(PatientInitial());
  //========the get method=========//
  Future<void> fetchDoctorById(String doctorId) async {
    emit(PatientLoading());
    try {
      log('doctor id : $doctorId', name: "DOCTOR ID");
      log('your uri is :${ApiConstants.baseUrl}/${ApiConstants.getDoctorById}$doctorId',
          name: "URI"); //log message

      final response = await apiClient.get(
        //get
        '${ApiConstants.getDoctorById}$doctorId',
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );
      log('=====================get success======================');
      final doctor = DoctorEntity.fromJson(response, id: doctorId);
      emit(PatientDoctorLoaded(doctor));
    } catch (e) {
      emit(PatientError('Failed to fetch doctor: ${e.toString()}'));
    }
  }
}
