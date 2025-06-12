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
        // التحقق من وجود البيانات المطلوبة
        if (response.data is! Map) {
          throw Exception("استجابة غير صالحة من الخادم");
        }

        // تحويل البيانات إلى Map<String, dynamic>
        final Map<String, dynamic> data = Map<String, dynamic>.from(response.data);
        
        // التحقق من وجود رسالة خطأ
        if (data['Message'] != null) {
          throw Exception(data['Message']);
        }

        // التحقق من وجود البيانات المطلوبة
        if (data['token'] == null || data['actorId'] == null || data['role'] == null) {
          throw Exception("بيانات تسجيل الدخول غير مكتملة");
        }

        // تحويل البيانات إلى النموذج المطلوب
        return LoginModel.fromJson(data);
      } else {
        throw Exception("حدث خطأ في السيرفر. الرمز: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null && e.response?.data != null) {
        final errorData = e.response?.data;
        if (errorData is Map) {
          final Map<String, dynamic> errorMap = Map<String, dynamic>.from(errorData);
          if (errorMap['message'] != null) {
            throw Exception(errorMap['message']);
          }
        }
        throw Exception("فشل في تسجيل الدخول: ${e.message}");
      }
      throw Exception("فشل في الاتصال بالسيرفر: ${e.message}");
    } catch (e) {
      throw Exception("حدث خطأ غير متوقع: $e");
    }
  }
}
