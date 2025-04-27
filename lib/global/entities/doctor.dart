// This file defines the sheared Doctor entity with its properties and constructor.
import 'package:health_care_app/global/entities/clinic.dart';
import 'package:health_care_app/global/entities/time_slot.dart';

import '../../core/utils/doctor_specialties.dart';

class DoctorEntity {
  final String id;
  final String name;
  final String? imageUrl;
  final DoctorSpecialty specialty;
  final double rating;
  final int reviewCount;
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
    this.imageUrl,
    required this.specialty,
    required this.rating,
    this.reviewCount = 0,
    required this.availableSlots,
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

  factory DoctorEntity.fromJson(Map<String, dynamic> json) {
    return DoctorEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: DoctorSpecialty.values.firstWhere(
        (e) => e.toString() == 'DoctorSpecialty.${json['specialty']}',
      ),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String?,
      availableSlots: (json['availableSlots'] as List<dynamic>)
          .map((slot) => TimeSlotEntity.fromJson(slot as Map<String, dynamic>))
          .toList(),
      bio: json['bio'] as String? ?? '',
      focus: json['focus'] as String? ?? '',
      careerPath: json['careerPath'] as String? ?? '',
      highlights: json['highlights'] as String? ?? '',
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
      clinic: ClinicEntity.fromJson(json['clinic'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty.toString().split('.').last,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'availableSlots': availableSlots.map((slot) => slot.toJson()).toList(),
      'bio': bio,
      'focus': focus,
      'careerPath': careerPath,
      'highlights': highlights,
      'experienceYears': experienceYears,
      'clinic': clinic!.toJson(),
    };
  }
}
