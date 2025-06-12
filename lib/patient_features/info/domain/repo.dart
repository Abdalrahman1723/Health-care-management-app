import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import 'entity.dart';

abstract class RepoDoctorInfo {
  Future<Either<Failure, List<EntityDoctorInfo>>> fetchDoctorsInfo(int id);
}
