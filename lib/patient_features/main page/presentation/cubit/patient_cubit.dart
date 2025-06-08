import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/entities/patient.dart';
import 'package:health_care_app/global/entities/appointment.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';

part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final ApiClient apiClient;
  final String authToken; //! will be fetched from shared pref later

  PatientCubit({required this.apiClient, required this.authToken})
      : super(PatientInitial());
  //========the get method=========//
  Future<void> fetchPatientById(String patientId) async {
    emit(PatientLoading());
    try {
      log('patient id : $patientId', name: "PATIENT ID");
      log('your uri is :${ApiConstants.baseUrl}/${ApiConstants.getPatientById}$patientId',
          name: "URI"); //log message

      final response = await apiClient.get(
        //get
        '${ApiConstants.getPatientById}$patientId',
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );
      log('=====================get success======================');
      final patient = PatientEntity.fromJson(response, patientId: patientId);
      emit(PatientLoaded(patient));
    } catch (e) {
      emit(PatientError('Failed to fetch patient: ${e.toString()}'));
    }
  }

  //========fetch appointments method=========//
  Future<void> fetchAppointments(String patientId) async {
    emit(AppointmentsLoading());
    try {
      log('Fetching appointments for patient: $patientId',
          name: "APPOINTMENTS");
      log('your uri is :${ApiConstants.baseUrl}/${ApiConstants.getPatientAppointments(patientId)}',
          name: "URI"); //log message
      final response = await apiClient.get(
        ApiConstants.getPatientAppointments(patientId),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      log('=====================appointments fetch success======================');

      final List<dynamic> appointmentsJson = response as List<dynamic>;
      final appointments = AppointmentEntity.fromJsonList(appointmentsJson);

      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      emit(AppointmentsError('Failed to fetch appointments: ${e.toString()}'));
    }
  }
}
