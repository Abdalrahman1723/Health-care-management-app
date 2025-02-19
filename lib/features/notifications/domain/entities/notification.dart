class NotificationEntity {
  final String title;
  final String content;
  final bool isSchedule;
  final DateTime timeStamp;
  bool isRead;

  NotificationEntity({
    required this.title,
    required this.content,
    required this.isSchedule,
    required this.timeStamp,
    this.isRead = false, // Default to unread
  });

  // Toggle read/unread status
  void markAsRead() {
    isRead = true;
  }

  void markAsUnread() {
    isRead = false;
  }
}
