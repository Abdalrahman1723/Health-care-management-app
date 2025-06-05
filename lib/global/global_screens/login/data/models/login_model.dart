


import '../../domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({required int id, required String token})
      : super(id: id, token: token);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: json['Id'] ?? 0,
      token: json['token'] ?? '',
    );
  }
}
