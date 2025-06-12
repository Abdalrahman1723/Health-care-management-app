import '../entities/login_entity.dart';

abstract class LoginRepository {
  Future<LoginEntity> loginUser({
    required String email,
    required String password,
  });
}
