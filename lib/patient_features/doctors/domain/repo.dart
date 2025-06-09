import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import 'entities/doctor_entity.dart';

abstract class Repo {
  Future<Either<Failure, List<DoctorEntity>>> fetchDoctorsData();
}
