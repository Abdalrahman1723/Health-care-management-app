import '../../domain/entity.dart';

class ModelDoctorInfo extends EntityDoctorInfo {
  ModelDoctorInfo({required super.photo, required super.fullName, required super.specialization, required super.rating, required super.reviewsCount, required super.experience, required super.focus, required super.profile, required super.careerPath, required super.highlights});

  factory ModelDoctorInfo.fromJson(Map<String, dynamic> json) => ModelDoctorInfo(
    photo: json['photo'] ?? '',
    fullName: json['fullName'] ?? '',
    specialization: json['specialization'] ?? '',
    rating: json['rating'] ?? 0.0,
    reviewsCount: json['reviewsCount'] ?? 0,
    experience: json['experience'] ?? 0,
    focus: json['focus'] ?? '',
    profile: json['profile'] ?? '',
    careerPath: json['careerPath'] ?? '',
    highlights: json['highlights'] ?? '',
  );
}
