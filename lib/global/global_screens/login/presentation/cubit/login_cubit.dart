import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/global_screens/login/domain/usecases/login_usecase.dart';
import 'package:health_care_app/global/global_screens/login/presentation/cubit/login_state.dart';
import 'package:health_care_app/global/global_screens/signup/presentation/cubit/register_state.dart';





class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      final result = await loginUseCase(
        email: email,
        password: password,
      );
      emit(LoginSuccess(result));
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
