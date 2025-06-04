
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
  }) async {
    final data = await remoteDataSource.register(
      username: username,
      personName: personName,
      phoneNumber: phoneNumber,
      email: email,
      password: password,
    );

    return RegisterModel.fromJson(data);
  }
}
