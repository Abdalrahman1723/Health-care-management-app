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
      final List<DoctorEntity> doctors = (response as List).map((json) {
        try {
          return DoctorEntity.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          log('Error parsing doctor: $e', name: 'DOCTORS');
          // Return a default doctor entity if parsing fails
          return DoctorEntity(
            id: 'error',
            name: 'Error Doctor',
            specialty: DoctorSpecialty.generalPractitioner,
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
}
