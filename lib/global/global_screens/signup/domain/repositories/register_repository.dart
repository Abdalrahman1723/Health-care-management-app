import '../entities/register_entity.dart';

abstract class RegisterRepository {
  Future<RegisterEntity> registerUser({
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
  });
}
