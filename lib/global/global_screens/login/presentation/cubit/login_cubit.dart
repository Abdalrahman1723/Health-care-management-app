import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  // الطريقة الصحيحة - void method
  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());

    try {
      final loginEntity = await loginUseCase.call(email: email, password: password);
      emit(LoginSuccess(loginEntity));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

// شيل الطريقة القديمة اللي بترجع String
// Future<String?> login() - دي كانت السبب في المشكلة
}