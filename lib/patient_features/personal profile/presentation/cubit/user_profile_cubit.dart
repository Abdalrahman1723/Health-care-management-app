import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/patient_features/personal%20profile/presentation/cubit/user_profile_state.dart';

import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../../../global/entities/patient.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  final ApiClient apiClient;
  final String authToken; //! will be fetched from shared pref later
  UserProfileCubit({required this.apiClient, required this.authToken})
      : super(ProfileInitial());

  Future<void> fetchUserData(String patientId) async {
    try {
      emit(ProfileLoading());
      final userData = await apiClient.get(
        //get
        '${ApiConstants.getPatientById}$patientId',
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

  // Future<void> updateUserData(Map<String, dynamic> data) async {
  //   try {
  //     emit(ProfileLoading());
  //     await _ProfileRepository.updateUserData(data);
  //     await fetchUserData();
  //   } catch (e) {
  //     emit(ProfileError(e.toString()));
  //   }
  // }

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
