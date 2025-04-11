// This file defines the sheared Doctor entity with its properties and constructor.
import 'package:health_care_app/global/entities/time_slot.dart';

import '../../core/utils/doctor_specialties.dart';

class DoctorEntity {
  final String id;
  final String name;
  final DoctorSpecialty specialty;
  final double rating;
  final String? imageUrl;
  final List<TimeSlot> availableSlots;


  DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    this.imageUrl,
    required this.availableSlots,
  });

  bool isAvailableAt(DateTime time) {
    //todo: implement the logic to check if the doctor is available at the given time
    return availableSlots.any((slot) => slot.contains(time));
  }
}
