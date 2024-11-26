import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  //singleton pattern to ensure only one instance of dio is created
  static Dio? dio;

  DioFactory._();

 static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);
    if (dio == null) {
      dio = Dio()
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioInterceptors();
      return dio!;
    } else {
      return dio!;
    }
  }

 static addDioInterceptors() {
    dio!.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
    ));
  }
}
