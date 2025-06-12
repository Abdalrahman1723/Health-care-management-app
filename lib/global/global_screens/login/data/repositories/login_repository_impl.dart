import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/login_repository.dart';
import '../datasources/login_remote_data_source.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<LoginEntity> loginUser({required String email, required String password}) async {
    final model = await remoteDataSource.login(email: email, password: password);
    return LoginEntity(token: model.token, id: model.id, role: model.role);
  }
  
}
