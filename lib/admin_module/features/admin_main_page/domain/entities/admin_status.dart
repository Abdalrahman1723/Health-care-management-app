import 'package:equatable/equatable.dart';

class AdminStatus extends Equatable {
  final int totalDoctors;
  final int totalPatients;
  final Map<String, int> mostRequestedSpecializations;

  const AdminStatus({
    required this.totalDoctors,
    required this.totalPatients,
    required this.mostRequestedSpecializations,
  });

  factory AdminStatus.fromJson(Map<String, dynamic> json) {
    return AdminStatus(
      totalDoctors: json['totalDoctors'] as int,
      totalPatients: json['totalPatients'] as int,
      mostRequestedSpecializations: Map<String, int>.from(
        json['mostRequestedSpecializations'] as Map,
      ),
    );
  }

  @override
  List<Object?> get props =>
      [totalDoctors, totalPatients, mostRequestedSpecializations];
}
