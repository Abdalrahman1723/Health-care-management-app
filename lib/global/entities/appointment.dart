import 'package:health_care_app/global/entities/review.dart';
import 'package:health_care_app/global/entities/time_slot.dart';

class AppointmentEntity {
  final String id;
  final String patientId;
  final String doctorId;
  final TimeSlotEntity dateTime;
  final String status; // e.g., "Scheduled", "Completed", "Cancelled"
  final String notes;
  final AppointmentReviewEntity? review;

  AppointmentEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.dateTime,
    required this.status,
    this.notes = '',
    this.review,
  });

  factory AppointmentEntity.fromJson(Map<String, dynamic> json) {
    return AppointmentEntity(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      dateTime: TimeSlotEntity.fromJson(json['dateTime']),
      status: json['status'],
      notes: json['notes'] ?? '',
      review: json['review'] != null
          ? AppointmentReviewEntity.fromJson(json['review'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'dateTime':
          TimeSlotEntity(start: dateTime.start, end: dateTime.end).toJson(), //!not sure
      'status': status,
      'notes': notes,
      'review': review?.toJson(),
    };
  }
}
