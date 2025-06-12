import '../../domain/entities/login_entity.dart';

class LoginModel extends LoginEntity {
  LoginModel({required int id, required String token, required String role})
      : super(id: id, token: token, role: role);

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      id: int.tryParse(json['actorId'].toString()) ?? 0,
      token: json['token'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
