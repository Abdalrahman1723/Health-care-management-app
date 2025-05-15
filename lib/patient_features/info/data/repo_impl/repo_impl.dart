import 'package:dartz/dartz.dart';
import 'package:health_care_app/core/error/failure.dart';
import 'package:health_care_app/patient_features/doctors/data/services/service_api.dart';
import 'package:health_care_app/patient_features/doctors/domain/entity.dart';
import 'package:health_care_app/patient_features/info/data/services/service_api.dart';
import '../../domain/entity.dart';
import '../../domain/repo.dart';

class RepoImpl extends RepoDoctorInfo {
  final NewsServiceDoctorInfo newsServiceDoctorInfo;

  RepoImpl({required this.newsServiceDoctorInfo});

  @override
  Future<Either<Failure, List<EntityDoctorInfo>>> fetchDoctorsInfo(int id) async {
    final response = await newsServiceDoctorInfo.fetchDoctorInfoById(id);

    return response.fold(
          (failure) => Left(failure),
          (model) => Right([model]),
    );
  }
}
