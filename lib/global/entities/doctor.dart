// This file defines the sheared Doctor entity with its properties and constructor.
import 'package:health_care_app/global/entities/clinic.dart';
import 'package:health_care_app/global/entities/time_slot.dart';

import '../../core/utils/doctor_specialties.dart';

class DoctorEntity {
  final String id;
  final String name;
  final String? fullName;
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
  final ClinicEntity? clinic;

  DoctorEntity({
    required this.id,
    required this.name,
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
    this.clinic,
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
      id: id ?? json['doctorId']?.toString() ?? '',
      name: json['userName']?.toString() ?? 'Unknown Doctor',
      fullName: json['fullName']?.toString(),
      specialty: parseSpecialty(json['specialization']?.toString()),
      rating: 0.0, // Default rating since not provided in response
      imageUrl: json['photo']?.toString(),
      availableSlots: const [], // Default empty list since not provided in response
      bio: '', // Default empty string since not provided in response
      focus: '', // Default empty string since not provided in response
      careerPath: '', // Default empty string since not provided in response
      highlights: '', // Default empty string since not provided in response
      reviewCount: 0, // Default 0 since not provided in response
      experienceYears: 0, // Default 0 since not provided in response
      clinic: null, // Default null since not provided in response
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'doctorId': id,
      'userName': name,
      'fullName': fullName,
      'photo': imageUrl,
      'specialization': specialty.toString().split('.').last,
      'rating': rating,
      'reviewCount': reviewCount,
      'availableSlots': availableSlots.map((slot) => slot.toJson()).toList(),
      'bio': bio,
      'focus': focus,
      'careerPath': careerPath,
      'highlights': highlights,
      'experienceYears': experienceYears,
      'clinic': clinic?.toJson(),
    };
  }
}
