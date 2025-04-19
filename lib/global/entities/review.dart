class AppointmentReviewEntity {
  final String id;
  final String appointmentId;
  final String reviewerId;
  final String reviewText;
  final double rating;
  final DateTime createdAt;

  AppointmentReviewEntity({
    required this.id,
    required this.appointmentId,
    required this.reviewerId,
    required this.reviewText,
    required this.rating,
    required this.createdAt,
  });

  // Factory method to create an instance from a JSON object
  factory AppointmentReviewEntity.fromJson(Map<String, dynamic> json) {
    return AppointmentReviewEntity(
      id: json['id'],
      appointmentId: json['appointmentId'],
      reviewerId: json['reviewerId'],
      reviewText: json['reviewText'],
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
      'reviewText': reviewText,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}