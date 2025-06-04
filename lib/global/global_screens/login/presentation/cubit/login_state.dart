

import '../../domain/entities/login_entity.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginEntity loginEntity;
  LoginSuccess(this.loginEntity);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
