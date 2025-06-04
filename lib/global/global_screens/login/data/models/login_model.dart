


import '../../domain/entities/login_entity.dart';

class RegisterModel extends LoginEntity {
  RegisterModel({required int id, required String token})
      : super(id: id, token: token);

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      id: json['Id'] ?? 0,
      token: json['token'] ?? '',
    );
  }
}
