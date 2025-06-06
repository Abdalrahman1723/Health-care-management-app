import 'dart:developer';

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
  }) async {
    final response = await dio.post(
      'https://healthcaresystem.runasp.net/api/auth/register',
      data: {
        "username": username,
        "personName": personName,
        "phoneNumber": phoneNumber,
        "email": email,
        "password": password,
      },
    );
    log(name: "Register", "the register response data : ${response.data}");
    return response.data;
  }
}
