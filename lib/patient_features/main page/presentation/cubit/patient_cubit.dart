import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/entities/patient.dart';
import 'package:health_care_app/global/entities/appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';

part 'patient_state.dart';

class PatientCubit extends Cubit<PatientState> {
  final ApiClient apiClient;
  String? authToken;

  PatientCubit({required this.apiClient}) : super(PatientInitial());

  Future<void> fetchPatientById(String patientId) async {
    emit(PatientLoading());
    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(const PatientError('Authentication token not found'));
        return;
      }

      log('patient id : $patientId', name: "PATIENT ID");
      log('your uri is :${PatientApiConstants.baseUrl}${PatientApiConstants.getPatientById}$patientId',
          name: "URI"); //log message

      final patientResponse = await apiClient.get(
        '${PatientApiConstants.getPatientById}$patientId',
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      List<AppointmentEntity?> appointments;
      try {
        final appointmentResponse = await apiClient.get(
          PatientApiConstants.getAllAppointments,
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

  Future<void> fetchAppointments() async {
    emit(AppointmentsLoading());
    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(const AppointmentsError('Authentication token not found'));
        return;
      }

      log('Fetching appointments for patient', name: "APPOINTMENTS");
      log('your uri is :${PatientApiConstants.baseUrl}${PatientApiConstants.getAllAppointments}',
          name: "URI"); //log message
      final response = await apiClient.get(
        PatientApiConstants.getAllAppointments,
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
