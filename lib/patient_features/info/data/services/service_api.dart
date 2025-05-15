import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../model/doctor_info_model.dart';

class NewsServiceDoctorInfo {
  final Dio _dio = Dio();


  Future<Either<Failure, ModelDoctorInfo>> fetchDoctorInfoById(int doctorId) async {
    try {
      final response = await _dio.get(
        "https://healthcaresystem.runasp.net/api/Patient/$doctorId",
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final doctorInfo = ModelDoctorInfo.fromJson(data);

        return Right(doctorInfo);
      } else {
        return Left(ServerFailure(
          errMessage: 'Failed to fetch doctor info. Status code: ${response.statusCode}',
        ));
      }
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
