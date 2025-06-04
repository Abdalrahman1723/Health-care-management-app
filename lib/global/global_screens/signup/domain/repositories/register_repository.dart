import '../entities/register_entity.dart';

abstract class RegisterRepository {
  Future<RegisterEntity> registerUser({
    required String username,
    required String personName,
    required String phoneNumber,
    required String email,
    required String password,
  });
}
