import '../../domain/entities/register_entity.dart';

class RegisterModel extends RegisterEntity {
  RegisterModel({
    required String actorId,
    required String role,
    required String token,
    required int validFor,
  }) : super(
          actorId: actorId,
          role: role,
          token: token,
          validFor: validFor,
        );

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      actorId: json['actorId'] ?? '',
      role: json['role'] ?? '',
      token: json['token'] ?? '',
      validFor: json['validFor'] ?? 0,
    );
  }
}
