import '../../domain/entity.dart';

class ModelDoctor extends Entity {
  ModelDoctor({required super.photo, required super.fullName, required super.specialization, required super.id});
  factory ModelDoctor.fromJson(Map<String, dynamic> json) {
    final id = json['doctorId'];
    print('DEBUG: Parsing doctor with id = ' + id.toString());
    return ModelDoctor(
      photo: json['photo'],
      fullName: json['fullName'],
      specialization: json['specialization'],
      id: id ?? 0,
    );
  }
}
