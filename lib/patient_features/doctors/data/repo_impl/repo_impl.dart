import 'package:dartz/dartz.dart';
import '../services/service_api.dart';
import '../../domain/entities/doctor_entity.dart';
import '../../domain/repo.dart';
import '../model/doctor_model.dart';
import '../../../../core/error/failure.dart';

class RepoImpl extends Repo {
  final DoctorsService doctorsService;

  RepoImpl({required this.doctorsService});

  @override
  Future<Either<Failure, List<DoctorEntity>>> fetchDoctorsData() async {
    try {
      final data = await doctorsService.fetchAllDoctors();
      final doctors = data.map((json) => DoctorModel.fromJson(json)).toList();
      final entities = doctors
          .map((model) => DoctorEntity(
                id: model.doctorId,
                fullName: model.fullName,
                specialization: model.specialization,
                photoUrl: model.photo,
              ))
          .toList();
      return Right(entities);
    } catch (e) {
      return Left(ServerFailure(errMessage: e.toString()));
    }
  }
}
