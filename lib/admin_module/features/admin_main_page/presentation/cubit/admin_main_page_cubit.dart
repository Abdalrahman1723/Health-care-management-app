import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/entities/doctor.dart';
import 'package:health_care_app/core/utils/doctor_specialties.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/endpoints.dart';
import '../../domain/entities/admin_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_main_page_state.dart';

class AdminMainPageCubit extends Cubit<AdminMainPageState> {
  final ApiClient apiClient;
  String? authToken;

  AdminMainPageCubit({required this.apiClient}) : super(AdminInitial());

  // --------------------Fetch all doctors
  Future<void> fetchDoctors() async {
    emit(DoctorsLoading());
    try {
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(DoctorsError('Authentication token not found'));
        return;
      }

      log(
          name: "ADMIN URI",
          "your admin URI is : ${AdminApiConstants.baseUrl}${AdminApiConstants.getAllDoctors}");
      final response = await apiClient.get(
        "Admin/doctors",
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );
      log(name: "CUBIT RESPONSE DOCTORS", "doctors loaded: \n $response");
      log(
          name: "CUBIT RESPONSE DOCTORS RAW",
          "Raw response type: ${response.runtimeType}");
      if (response is List) {
        log(
            name: "CUBIT RESPONSE DOCTORS RAW",
            "First doctor data: ${response.first}");
      }

      if (response == null) {
        log("error number : ${response.runtimeType}");
        emit(const DoctorsError('No doctors data received'));
        return;
      }

      // Ensure response is a List
      if (response is! List) {
        log("Error: Response is not a list", name: "DOCTORS");
        emit(const DoctorsError('Invalid response format'));
        return;
      }

      log('=====================get success======================');

      // Convert each item in the list to DoctorEntity
      final List<DoctorEntity> doctors = (response).map((json) {
        try {
          return DoctorEntity.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing doctor: $e', name: 'DOCTORS');
          // Return a default doctor entity if parsing fails
          return DoctorEntity(
            id: 'error',
            userName: 'Error Doctor',
            specialty: DoctorSpecialty.generalPractitioner,
            email: 'email error',
            password: 'error',
            clinic: 'error',
          );
        }
      }).toList();

      // Filter out any error doctors if needed
      final validDoctors =
          doctors.where((doctor) => doctor.id != 'error').toList();

      if (validDoctors.isEmpty) {
        emit(const DoctorsError('No valid doctors found in response'));
        return;
      }

      emit(DoctorsLoaded(validDoctors));
    } catch (e) {
      log('Error fetching doctors: $e', name: "DOCTORS");
      emit(DoctorsError('Failed to fetch doctors: ${e.toString()}'));
    }
  }

  //---------------------update a doctor
  Future<void> updateDoctor(DoctorEntity doctor) async {
    try {
      emit(DoctorsLoading());
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(DoctorsError('Authentication token not found'));
        return;
      }

      final response = await apiClient.put(
        "Admin/doctors/${doctor.id}",
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: doctor.toJson(),
      );

      if (response != null) {
        await fetchDoctors();
      } else {
        emit(const DoctorsError('Failed to update doctor'));
      }
    } catch (e) {
      log('Error updating doctor: $e', name: "DOCTORS");
      emit(DoctorsError('Failed to update doctor: ${e.toString()}'));
    }
  }

  //---------------------delete a doctor
  Future<void> deleteDoctor(String doctorId) async {
    try {
      emit(DoctorsLoading());
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(const DoctorsError('Authentication token not found'));
        return;
      }

      final response = await apiClient.delete(
        "${AdminApiConstants.deleteDoctor}/$doctorId",
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        await fetchDoctors();
      } else {
        emit(const DoctorsError('Failed to delete doctor'));
      }
    } catch (e) {
      log('Error deleting doctor: $e', name: "DOCTORS");
      emit(DoctorsError('Failed to delete doctor: ${e.toString()}'));
    }
  }

  //---------------------fetch admin stats
  Future<void> fetchAdminStats() async {
    try {
      emit(AdminStatsLoading());
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(AdminStatsError('Authentication token not found'));
        return;
      }

      final response = await apiClient.get(
        AdminApiConstants.fetchAdminStats,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response != null) {
        final stats = AdminStatus.fromJson(response);
        emit(AdminStatsLoaded(stats));
      } else {
        emit(const AdminStatsError('Failed to fetch admin stats'));
      }
    } catch (e) {
      log('Error fetching admin stats: $e', name: "ADMIN");
      emit(AdminStatsError('Failed to fetch admin stats: ${e.toString()}'));
    }
  }
}
