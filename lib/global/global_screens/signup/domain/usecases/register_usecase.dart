import '../entities/register_entity.dart';
import '../repositories/register_repository.dart';

class RegisterUseCase {
  final RegisterRepository repository;

  RegisterUseCase(this.repository);

  Future<RegisterEntity> call({
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
  }) {
    return repository.registerUser(
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
  }
}
