import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:health_care_app/patient_features/doctors/data/model/doctor_model.dart';
import '../../../../core/error/failure.dart';

class NewsService {
  final Dio _dio = Dio();


  Future<Either<Failure, List<ModelDoctor>>> fetchDoctorsData() async {
    try {

      final response = await _dio.get("https://healthcaresystem.runasp.net/api/Patient/GetAllDoctor");

      if (response.statusCode == 200) {
        List doctors = response.data;

        List<ModelDoctor> doctorList = doctors.map((doctor) {
          return ModelDoctor.fromJson(doctor);
        }).toList();

        return Right(doctorList);
      } else {
        return Left(ServerFailure(
            errMessage: 'Failed to fetch doctors. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
