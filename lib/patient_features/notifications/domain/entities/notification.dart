class NotificationEntity {
  final int id;
  final String title;
  final String message;
  final DateTime createdAt;
  final int? doctorId;
  final int patientId;
  bool isRead;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    this.doctorId,
    required this.patientId,
    this.isRead = false,
  });

  factory NotificationEntity.fromJson(Map<String, dynamic> json) {
    return NotificationEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      doctorId: json['doctorId'] as int?,
      patientId: json['patientId'] as int,
      isRead: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'doctorId': doctorId,
      'patientId': patientId,
      'isRead': isRead,
    };
  }

  void markAsRead() {
    isRead = true;
  }

  void markAsUnread() {
    isRead = false;
  }
}
