import 'package:health_care_app/patient_features/personal%20profile/data/datasources/profile_remote_data_source.dart';

class ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepository(this._remoteDataSource);

  Future<Map<String, dynamic>> getUserData(String patientId) async {
    return await _remoteDataSource.getUserData();
  }

  // Future<void> updateUserData(Map<String, dynamic> data) async {
  //   await _remoteDataSource.updateUserData(data);
  // }

  // Future<void> deleteAccount() async {
  //   await _remoteDataSource.deleteAccount();
  // }
}
