import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/gradient_text.dart';
import 'package:health_care_app/patient_features/notifications/domain/entities/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

Widget notificationItem({required NotificationEntity notification}) {
  return ListTile(
    leading: notification.doctorId != null
        ? GradientBackground.gradientIcon(Icons.person_outline)
        : GradientBackground.gradientIcon(Icons.notifications_outlined),
    title: Text(
      notification.title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(notification.message),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          timeago.format(notification.createdAt, locale: 'en'),
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        if (!notification.isRead)
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
          ),
      ],
    ),
  );
}
