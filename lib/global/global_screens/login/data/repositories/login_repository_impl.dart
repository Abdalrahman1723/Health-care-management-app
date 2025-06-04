
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/register_remote_data_source.dart';
import '../models/login_model.dart';

class LoginRepositoryImpl extends LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginEntity> loginUser({
    required String email,
    required String password,
  }) async {
    final data = await remoteDataSource.register(
      email: email,
      password: password,
    );

    return RegisterModel.fromJson(data);
  }

}
