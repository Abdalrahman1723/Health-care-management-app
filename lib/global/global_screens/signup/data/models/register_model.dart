import '../../domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  RegisterModel({required String message, required String token})
      : super(message: message, token: token);

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
