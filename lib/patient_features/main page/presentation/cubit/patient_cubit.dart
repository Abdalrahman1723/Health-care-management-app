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
      log('your uri is :${ApiConstants.baseUrl}${ApiConstants.getPatientById}$patientId',
          name: "URI"); //log message

      final patientResponse = await apiClient.get(
        //get
        '${ApiConstants.getPatientById}$patientId',
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      List<AppointmentEntity?> appointments;
      try {
        final appointmentResponse = await apiClient.get(
          ApiConstants.getAllAppointments,
          headers: {
            'Authorization': 'Bearer $authToken',
            'Content-Type': 'application/json',
          },
        );
        log(name: "APPOINTMENT ERROR", "$appointmentResponse");
        if (appointmentResponse != null &&
            appointmentResponse is List &&
            appointmentResponse.isNotEmpty) {
          appointments = appointmentResponse
              .map((json) =>
                  AppointmentEntity.fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          appointments = [];
        }
      } on FormatException catch (e) {
        log('No appointments found: $e', name: "APPOINTMENTS");
        emit(PatientLoadedWithNoAppointments(
            PatientEntity.fromJson(patientResponse, patientId: patientId)));
        return;
      } catch (e) {
        log('Error fetching appointments: $e', name: "APPOINTMENTS");
        appointments = [];
      }

      log('=====================get success======================');
      final patient =
          PatientEntity.fromJson(patientResponse, patientId: patientId);

      emit(PatientLoaded(patient, appointments));
    } catch (e) {
      emit(PatientError('Failed to fetch patient: ${e.toString()}'));
    }
  }

  //========fetch appointments method=========//
  Future<void> fetchAppointments() async {
    emit(AppointmentsLoading());
    try {
      log('Fetching appointments for patient', name: "APPOINTMENTS");
      log('your uri is :${ApiConstants.baseUrl}${ApiConstants.getAllAppointments}',
          name: "URI"); //log message
      final response = await apiClient.get(
        ApiConstants.getAllAppointments,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      log('=====================appointments fetch success======================');

      if (response == null) {
        emit(const AppointmentsError('No appointments data received'));
        return;
      }

      final List<dynamic> appointmentsJson = response as List<dynamic>;
      if (appointmentsJson.isEmpty) {
        emit(const AppointmentsLoaded([]));
        return;
      }

      final appointments = appointmentsJson
          .map((json) =>
              AppointmentEntity.fromJson(json as Map<String, dynamic>))
          .toList();

      emit(AppointmentsLoaded(appointments));
    } catch (e) {
      log('Error fetching appointments: ${e.toString()}', name: "APPOINTMENTS");
      emit(AppointmentsError('Failed to fetch appointments: ${e.toString()}'));
    }
  }
}
