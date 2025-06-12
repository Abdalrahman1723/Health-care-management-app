import 'package:dio/dio.dart';

class RegisterRemoteDataSource {
  final Dio dio;

  RegisterRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> register({
    required String username,
    required String personName,
    required String phoneNumber,
    required String email,
    required String password,
    required String profilePicture,
    required String dateOfBirth,
    required String gender,
    required int age,
    required String nationalID,
    required String bloodType,
    required String chronicDiseases,
    required String allergies,
    required String currentMedications,
    required String insuranceProvider,
  }) async {
    final response = await dio.post(
      'https://healthcaresystem.runasp.net/api/auth/register',
      data: {
        "username": username,
        "personName": personName,
        "phoneNumber": phoneNumber,
        "email": email,
        "password": password,
        "patientProfile": {
          "profilePicture": profilePicture,
          "dateOfBirth": dateOfBirth,
          "gender": gender,
          "age": age,
          "nationalID": nationalID,
          "bloodType": bloodType,
          "chronicDiseases": chronicDiseases,
          "allergies": allergies,
          "currentMedications": currentMedications,
          "insuranceProvider": insuranceProvider,
        }
      },
    );

    return response.data;
  }
}
