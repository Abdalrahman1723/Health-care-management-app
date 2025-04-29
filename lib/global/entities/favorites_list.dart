class FavoriteEntity {
  final String id;
  final String patientId;
  final String doctorId;
  final DateTime createdAt;

  FavoriteEntity({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.createdAt,
  });

  factory FavoriteEntity.fromJson(Map<String, dynamic> json) {
    return FavoriteEntity(
      id: json['id'],
      patientId: json['patientId'],
      doctorId: json['doctorId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'doctorId': doctorId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
