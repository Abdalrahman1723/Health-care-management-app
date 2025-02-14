String getWeekdayName(int weekdayNumber) {
    List<String> weekdays = [
      'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
    ];

    return weekdays[weekdayNumber % 7]; // Use modulo to handle Sunday (7)
  }