
import '../../domain/entities/register_entity.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final RegisterEntity registerEntity;
  RegisterSuccess(this.registerEntity);
}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}
