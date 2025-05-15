import '../../domain/entity.dart';

class ModelDoctor extends Entity {
  ModelDoctor({required super.photo, required super.fullName, required super.specialization});
  factory ModelDoctor.fromJson(Map<String, dynamic> json) {
    return ModelDoctor(
      photo: json['photo'],
      fullName: json['fullName'],
      specialization: json['specialization'],

    );
  }
}
