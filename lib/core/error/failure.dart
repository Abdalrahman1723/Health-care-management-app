import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String errMessage;

  const Failure({required this.errMessage});

  @override
  List<Object> get props => [errMessage];
}

class ServerFailure extends Failure {
  const ServerFailure({required String errMessage}) : super(errMessage: errMessage);
}

class CacheFailure extends Failure {
  const CacheFailure({required String errMessage}) : super(errMessage: errMessage);
}
