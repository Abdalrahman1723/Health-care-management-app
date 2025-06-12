import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/entities/doctor.dart';
import 'package:health_care_app/core/utils/doctor_specialties.dart';
import '../../../../../core/api/api_client.dart';
import '../../../../../core/api/endpoints.dart';

part 'admin_main_page_state.dart';

class AdminMainPageCubit extends Cubit<AdminMainPageState> {
  final ApiClient apiClient;
  final String authToken;

  AdminMainPageCubit({required this.apiClient, required this.authToken})
      : super(AdminInitial());

  // --------------------Fetch all doctors
  Future<void> fetchDoctors() async {
    emit(DoctorsLoading());
    try {
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

      final response = await apiClient.put(
        '${AdminApiConstants.updateDoctor}/1',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: {
          "id": doctor.id,
          "photo": doctor.imageUrl ?? "",
          "userName": doctor.userName,
          "fullName": doctor.fullName ?? "",
          "email": doctor.email,
          "password": doctor.password,
          "specialization": doctor.specialty.name,
          "rating": doctor.rating,
          "reviewsCount": doctor.reviewCount,
          "experienceYears": doctor.experienceYears,
          "workingHours": "9",
          "focus": doctor.focus,
          "profile": doctor.bio,
          "careerPath": doctor.careerPath,
          "highlights": doctor.highlights,
          "clinicName": doctor.clinic,
          "phoneNumber": doctor.phoneNumber ?? "",
        },
      );

      if (response == null) {
        emit(const DoctorsError('Failed to update doctor'));
        return;
      }

      // Refresh the doctors list after successful update
      await fetchDoctors();
    } catch (e) {
      log('Error updating doctor: $e', name: "DOCTORS");
      emit(DoctorsError('Failed to update doctor: ${e.toString()}'));
    }
  }

  //---------------------delete a doctor
  Future<void> deleteDoctor(String doctorId) async {
    try {
      emit(DoctorsLoading());

      final response = await apiClient.delete(
        '${AdminApiConstants.deleteDoctor}/$doctorId',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response == null) {
        emit(const DoctorsError('Failed to delete doctor'));
        return;
      }

      // Refresh the doctors list after successful deletion
      await fetchDoctors();
    } catch (e) {
      log('Error deleting doctor: $e', name: "DOCTORS");
      emit(DoctorsError('Failed to delete doctor: ${e.toString()}'));
    }
  }
}
