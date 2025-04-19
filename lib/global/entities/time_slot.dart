class TimeSlotEntity {
  final DateTime start;
  final DateTime end;

  TimeSlotEntity({
    required this.start,
    required this.end,
  });

  Duration get duration => end.difference(start);

  bool overlapsWith(TimeSlotEntity other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  bool contains(DateTime time) {
    return time.isAfter(start) && time.isBefore(end);
  }

  factory TimeSlotEntity.fromJson(Map<String, dynamic> json) {
    return TimeSlotEntity(
      start: DateTime.parse(json['start']),
      end: DateTime.parse(json['end']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}
