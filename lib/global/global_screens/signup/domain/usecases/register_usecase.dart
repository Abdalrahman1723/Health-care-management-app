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
  }) {
    return repository.registerUser(
      username: username,
      personName: personName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );
  }
}
