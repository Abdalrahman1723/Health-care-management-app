import 'package:dio/dio.dart';

class LoginRemoteDataSource {
  final Dio dio;

  LoginRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      'https://healthcaresystem.runasp.net/api/auth/login',
      data: {
        "email": email,
        "password": password,
      },
    );

    return response.data;
  }
}
