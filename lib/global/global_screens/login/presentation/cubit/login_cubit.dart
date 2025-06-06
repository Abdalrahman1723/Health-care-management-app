import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  // Future<void> login({required String email, required String password}) async {
  //   emit(LoginLoading());
  //
  //   try {
  //     final loginEntity = await loginUseCase.call(email: email, password: password);
  //     emit(LoginSuccess( loginEntity));
  //   } catch (e) {
  //     emit(LoginFailure( e.toString()));
  //   }
  // }

  Future<String?> login(
      {required String email, required String password}) async {
    emit(LoginLoading());

    try {
      log("========================");
      final loginEntity =
          await loginUseCase.call(email: email, password: password);
      log("the returned login entity : $loginEntity");
      emit(LoginSuccess(loginEntity));
      return loginEntity.token; // رجع التوكن هنا
    } catch (e) {
      emit(LoginFailure(e.toString()));
      return null; // رجع null لو فشل
    }
  }
}
