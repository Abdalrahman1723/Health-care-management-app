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

class DoctorModel {
  final int doctorId;
  final String fullName;
  final String specialization;
  final String photo;

  DoctorModel({
    required this.doctorId,
    required this.fullName,
    required this.specialization,
    required this.photo,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      doctorId: json['doctorId'],
      fullName: json['fullName'],
      specialization: json['specialization'],
      photo: json['photo'],
    );
  }
}
