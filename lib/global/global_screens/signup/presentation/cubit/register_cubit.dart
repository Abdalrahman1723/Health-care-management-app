import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/global/global_screens/signup/presentation/cubit/register_state.dart';

import '../../domain/usecases/register_usecase.dart';


class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;

  RegisterCubit(this.registerUseCase) : super(RegisterInitial());

  Future<void> register({
    required String username,
    required String personName,
    required String phoneNumber,
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      final result = await registerUseCase(
        username: username,
        personName: personName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
      );
      emit(RegisterSuccess(result));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
