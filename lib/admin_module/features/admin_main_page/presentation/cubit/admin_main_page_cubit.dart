import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/entities/doctor.dart';
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
      final response = await apiClient.get(
        AdminApiConstants.getAllDoctors,
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
      log('=====================get success======================');
      final doctors = response
          .map((json) => DoctorEntity.fromJson(json as Map<String, dynamic>))
          .toList();

      emit(DoctorsLoaded(doctors));
    } catch (e) {
      log('Error fetching doctors: $e', name: "DOCTORS");
      emit(DoctorsError('Failed to fetch doctors: ${e.toString()}'));
    }
  }
}
