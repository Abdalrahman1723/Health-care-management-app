
class TimeSlot {
  final DateTime start;
  final DateTime end;

  TimeSlot({
    required this.start,
    required this.end,
  });

  Duration get duration => end.difference(start);

  bool overlapsWith(TimeSlot other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  bool contains(DateTime time) {
    return time.isAfter(start) && time.isBefore(end);
  }
}
