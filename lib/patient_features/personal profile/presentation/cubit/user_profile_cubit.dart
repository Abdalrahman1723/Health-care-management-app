import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../global/entities/patient.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final ApiClient apiClient;
  String? authToken;

  UserProfileCubit({required this.apiClient}) : super(ProfileInitial());

  Future<void> fetchUserData(String patientId) async {
    try {
      emit(ProfileLoading());
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(ProfileError('Authentication token not found'));
        return;
      }

      final userData = await apiClient.get(
        '${PatientApiConstants.getPatientById}$patientId',
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );
      log("the user profile : $userData");
      final patient = PatientEntity.fromJson(userData, patientId: patientId);
      emit(ProfileLoaded(patient));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateUserData(
      Map<String, dynamic> data, String patientID) async {
    try {
      emit(ProfileLoading());
      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(ProfileError('Authentication token not found'));
        return;
      }

      await apiClient.put(
        "${PatientApiConstants.updatePatientProfile}$patientID",
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: data,
      );
      await fetchUserData(patientID);
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  // Future<void> deleteAccount() async {
  //   try {
  //     emit(ProfileLoading());
  //     await _ProfileRepository.deleteAccount();
  //     emit(ProfileInitial());
  //   } catch (e) {
  //     emit(ProfileError(e.toString()));
  //   }
  // }
}
