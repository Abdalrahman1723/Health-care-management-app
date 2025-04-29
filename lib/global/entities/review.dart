//feedback on the appointment

class AppointmentReviewEntity {
  final String id; 
  final String appointmentId;
  final String reviewerId; // ID of the user who wrote the review
  final String doctorId; // ID of the doctor being reviewed
  final String comment;
  final double rating;
  final DateTime createdAt;

  AppointmentReviewEntity({
    required this.id,
    required this.appointmentId,
    required this.reviewerId,
    required this.doctorId,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  // Factory method to create an instance from a JSON object
  factory AppointmentReviewEntity.fromJson(Map<String, dynamic> json) {
    return AppointmentReviewEntity(
      id: json['id'],
      appointmentId: json['appointmentId'],
      reviewerId: json['reviewerId'],
      doctorId: json['doctorId'],
      comment: json['comment'],
      rating: json['rating'].toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Method to convert an instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'appointmentId': appointmentId,
      'reviewerId': reviewerId,
      'doctorId': doctorId,
      'comment': comment,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}