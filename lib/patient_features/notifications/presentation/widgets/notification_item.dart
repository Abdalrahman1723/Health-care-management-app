import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';
import 'package:health_care_app/patient_features/notifications/domain/entities/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget notificationItem({required NotificationEntity notification}) {
  return ListTile(
    leading: notification.isSchedule
        ? GradientBackground.gradientIcon(Icons.date_range_outlined)
        : GradientBackground.gradientIcon(Icons.note_alt_outlined),
    title: Text(
      notification.title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(notification.content),
    trailing: Text(
      timeago.format(notification.timeStamp, locale: 'en'), // Converts to "1h ago"
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    ),
  );
}
