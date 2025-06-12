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
    required String profilePicture,
    required String dateOfBirth,
    required String gender,
    required int age,
    required String nationalID,
    required String bloodType,
    required String chronicDiseases,
    required String allergies,
    required String currentMedications,
    required String insuranceProvider,
  }) async {
    emit(RegisterLoading());
    try {
      final result = await registerUseCase(
        username: username,
        personName: personName,
        phoneNumber: phoneNumber,
        email: email,
        password: password,
        profilePicture: profilePicture,
        dateOfBirth: dateOfBirth,
        gender: gender,
        age: age,
        nationalID: nationalID,
        bloodType: bloodType,
        chronicDiseases: chronicDiseases,
        allergies: allergies,
        currentMedications: currentMedications,
        insuranceProvider: insuranceProvider,
      );
      emit(RegisterSuccess(result));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
