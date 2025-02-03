import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quotes/core/error/failure.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call();
}

// This is a class that will be used as a parameter for the UseCase class
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
