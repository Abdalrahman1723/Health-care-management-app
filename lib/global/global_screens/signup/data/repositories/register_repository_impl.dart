import '../../domain/entities/register_entity.dart';
import '../../domain/repositories/register_repository.dart';
import '../datasources/register_remote_data_source.dart';
import '../models/register_model.dart';

class RegisterRepositoryImpl extends RegisterRepository {
  final RegisterRemoteDataSource remoteDataSource;

  RegisterRepositoryImpl(this.remoteDataSource);

  @override
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
  }) async {
    final data = await remoteDataSource.register(
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

    return RegisterModel.fromJson(data);
  }
}
