import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import 'entity.dart';

abstract class Repo {
  Future<Either<Failure, List<Entity>>> fetchDoctorsData();
}
