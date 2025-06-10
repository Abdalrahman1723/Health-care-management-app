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

  Future<void> updateUserData(
      Map<String, dynamic> data, String patientID) async {
    try {
      emit(ProfileLoading());
      await apiClient.put(
        "${ApiConstants.updatePatientProfile}$patientID",
        headers: {
          'Authorization': //!temp remove it
              'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJVc2VySWQiOiJlM2M4MjE5YS03YjRiLTQ0NzAtYjhmOC0yNDY3ODM1ZDFkZDEiLCJVc2VyTmFtZSI6ImFiZGFscmFobWFuIiwicm9sZSI6IlBhdGllbnQiLCJuYmYiOjE3NDk1MTUwNDAsImV4cCI6MTc0OTYwMTQ0MCwiaWF0IjoxNzQ5NTE1MDQwLCJpc3MiOiJDbGluaWNQcm9qZWN0In0.N4-WgiMXJcT1B7mDyqjnIZODFzgkV5eYJBQDt2jn_n4',
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
