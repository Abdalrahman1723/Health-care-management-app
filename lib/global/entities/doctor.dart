// This file defines the sheared Doctor entity with its properties and constructor.
import 'package:health_care_app/global/entities/time_slot.dart';

import '../../core/utils/doctor_specialties.dart';

class DoctorEntity {
  final String id;
  final String userName;
  final String? fullName;
  final String email;
  final String password;
  final String? imageUrl;
  final DoctorSpecialty specialty;
  final double rating;
  final int reviewCount; // the number of reviews for the doctor
  final List<TimeSlotEntity> availableSlots;
  // ---------- professional info about the doctor's career
  final String bio; // a short bio about the doctor
  final String focus; // the area of focus
  final String careerPath; // the career path of the doctor
  final String highlights; // the highlights of the doctor's career
  final int experienceYears;
  //------------------------
  final String clinic;
  final String? phoneNumber; // Added phone number field

  DoctorEntity({
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    this.fullName,
    this.imageUrl,
    required this.specialty,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.availableSlots = const [],
    this.bio = '',
    this.focus = '',
    this.careerPath = '',
    this.highlights = '',
    this.experienceYears = 0,
    required this.clinic,
    this.phoneNumber,
  });

  bool isAvailableAt(DateTime time) {
    //todo: implement the logic to check if the doctor is available at the given time
    return availableSlots.any((slot) => slot.contains(time));
  }

  factory DoctorEntity.fromJson(Map<String, dynamic> json, {String? id}) {
    // Safely parse specialization string to DoctorSpecialty enum
    DoctorSpecialty parseSpecialty(String? specialization) {
      if (specialization == null) return DoctorSpecialty.generalPractitioner;

      try {
        return DoctorSpecialty.values.firstWhere(
          (e) =>
              e.toString().split('.').last.toLowerCase() ==
              specialization.toLowerCase(),
          orElse: () => DoctorSpecialty.generalPractitioner,
        );
      } catch (e) {
        return DoctorSpecialty.generalPractitioner;
      }
    }

    return DoctorEntity(
      id: id ?? json['id']?.toString() ?? '',
      userName: json['userName']?.toString() ?? 'Unknown Doctor',
      fullName: json['fullName']?.toString(),
      email: json['email'].toString(),
      password: json['password'].toString(),
      specialty: parseSpecialty(json['specialization']?.toString()),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['photo']?.toString(),
      availableSlots: const [], // Default empty list since not provided in response
      bio: json['profile'] ?? '', // Using profile as bio
      focus: json['focus'] ?? '',
      careerPath: json['careerPath'] ?? '',
      highlights: json['highlights'] ?? '',
      reviewCount: json['reviewsCount'] ?? 0,
      experienceYears: json['experienceYears'] ?? 0,
      clinic: json['clinicName'] ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'fullName': fullName,
      'photo': imageUrl,
      'specialization': specialty.toString().split('.').last,
      'rating': rating,
      'reviewsCount': reviewCount,
      'availableSlots': availableSlots.map((slot) => slot.toJson()).toList(),
      'profile': bio,
      'focus': focus,
      'careerPath': careerPath,
      'highlights': highlights,
      'experienceYears': experienceYears,
      'clinicName': clinic,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
    };
  }
}
