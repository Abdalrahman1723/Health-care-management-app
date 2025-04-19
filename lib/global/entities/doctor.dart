// This file defines the sheared Doctor entity with its properties and constructor.
import 'package:health_care_app/global/entities/clinic.dart';
import 'package:health_care_app/global/entities/time_slot.dart';

import '../../core/utils/doctor_specialties.dart';

class DoctorEntity {
  final String id;
  final String name;
  final DoctorSpecialty specialty;
  final double rating;
  final String? imageUrl;
  final List<TimeSlotEntity> availableSlots;
  final String bio;
  final int experienceYears;
  final ClinicEntity? clinic;

  DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    this.imageUrl,
    required this.availableSlots,
    this.bio = '',
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
      'imageUrl': imageUrl,
      'availableSlots': availableSlots.map((slot) => slot.toJson()).toList(),
      'bio': bio,
      'experienceYears': experienceYears,
      'clinic': clinic!.toJson(),
    };
  }
}
