import 'package:dartz/dartz.dart';
import 'package:health_care_app/patient_features/doctors/data/services/service_api.dart';
import 'package:health_care_app/patient_features/doctors/domain/entity.dart';
import 'package:health_care_app/core/error/failure.dart';
import '../model/doctor_model.dart';
import '../../domain/repo.dart'; // <-- تأكد إن دا هو ملف الواجهة الأساسية Repo

class RepoImpl extends Repo {
  final NewsService newsService;

  RepoImpl({required this.newsService});

  @override
  Future<Either<Failure, List<Entity>>> fetchDoctorsData() async {
    var response = await newsService.fetchDoctorsData();

    return response.fold(
          (failure) {
        return Left(ServerFailure(errMessage: failure.errMessage));
      },
          (doctorList) {
        List<Entity> entityList = doctorList.map((doctor) {
          return Entity(
            photo: doctor.photo,
            fullName: doctor.fullName,
            specialization: doctor.specialization,

          );
        }).toList();
        return Right(entityList);
      },
    );
  }
}
