import 'package:health_care_app/global/entities/review.dart';
import 'package:intl/intl.dart';

class AppointmentEntity {
  final int appointmentId;
  final int doctorId;
  final String doctor;
  final int patientId;
  final String patient;
  final String createdAt;
  final String availableDate;
  final double startTimeInHours;
  final double endTimeInHours;
  final String status;
  final String? notes;
  final AppointmentReviewEntity? review;

  AppointmentEntity({
    required this.appointmentId,
    required this.doctorId,
    required this.doctor,
    required this.patientId,
    required this.patient,
    required this.createdAt,
    required this.availableDate,
    required this.startTimeInHours,
    required this.endTimeInHours,
    required this.status,
    this.notes = '',
    this.review,
  });

  factory AppointmentEntity.fromJson(Map<String, dynamic> json) {
    return AppointmentEntity(
      appointmentId: json['appointmentId'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      doctor: json['doctor'] ?? '',
      patientId: json['patientId'] ?? 0,
      patient: json['patient'] ?? '',
      createdAt: json['createdAt'] ?? '',
      availableDate: json['availableDate'] ?? '',
      startTimeInHours: (json['startTimeInHours'] as num?)?.toDouble() ?? 0.0,
      endTimeInHours: (json['endTimeInHours'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      review: json['review'] != null
          ? AppointmentReviewEntity.fromJson(json['review'])
          : null,
    );
  }

  // Static method to create a list of appointments from JSON
  static List<AppointmentEntity> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => AppointmentEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  // Helper method to get the appointment date in DateTime format
  DateTime get appointmentDateTime {
    try {
      // Parse the date from "dd/MM/yyyy" format
      final dateFormat = DateFormat('dd/MM/yyyy');
      return dateFormat.parse(availableDate);
    } catch (e) {
      // If parsing fails, return current date
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'doctor': doctor,
      'patientId': patientId,
      'patient': patient,
      'createdAt': createdAt,
      'availableDate': availableDate,
      'startTimeInHours': startTimeInHours,
      'endTimeInHours': endTimeInHours,
      'status': status,
      'notes': notes,
      'review': review?.toJson(),
    };
  }
}
