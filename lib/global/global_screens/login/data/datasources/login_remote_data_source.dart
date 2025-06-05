import 'package:dio/dio.dart';
import '../models/login_model.dart';

class LoginRemoteDataSource {
  final Dio dio;

  LoginRemoteDataSource(this.dio);

  Future<LoginModel> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        'https://healthcaresystem.runasp.net/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // هنا بنشوف إذا الرسالة فيها Error من السيرفر
        if (response.data is Map && response.data['Message'] == "Email is not exist.") {
          throw Exception("البريد الإلكتروني غير مسجل.");
        }

        // تحقق من وجود التوكن في الاستجابة
        if (response.data['token'] != null) {
          return LoginModel.fromJson(response.data);
        } else {
          throw Exception("فشل تسجيل الدخول. تأكد من البيانات.");
        }
      } else {
        throw Exception("حدث خطأ في السيرفر. حاول لاحقاً.");
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        // دي الرسالة اللي بيرجعها السيرفر لما الايميل مش مسجل
        final errorMessage = e.response?.data["message"] ?? "فشل في تسجيل الدخول";
        throw Exception(errorMessage);
      } else {
        throw Exception("فشل في الاتصال بالسيرفر");
      }
    }
  }
}
