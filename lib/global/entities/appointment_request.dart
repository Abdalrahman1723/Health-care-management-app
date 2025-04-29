import 'package:health_care_app/global/entities/time_slot.dart';

class AppointmentRequest {
  final String id;
  final String patientId;
  final String doctorId;
  final TimeSlotEntity appointmentDate;
  final AppointmentStatus status;

  AppointmentRequest({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.appointmentDate,
    required this.status,
  });

  // Factory method to create an AppointmentRequest from JSON
  factory AppointmentRequest.fromJson(Map<String, dynamic> json) {
    return AppointmentRequest(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      appointmentDate: TimeSlotEntity.fromJson(json['appointmentDate']),
      status: json['status'],
    );
  }

  // Method to convert an AppointmentRequest to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'appointmentDate':
          TimeSlotEntity(start: appointmentDate.start, end: appointmentDate.end)
              .toJson(), //!not sure
      'status': status,
    };
  }
}

enum AppointmentStatus {
  pending,
  confirmed,
  cancelled,
  rejected,
  completed,
}
