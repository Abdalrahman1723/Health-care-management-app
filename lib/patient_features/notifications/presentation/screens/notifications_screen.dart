import 'package:flutter/material.dart';
import 'package:health_care_app/core/utils/app_bar.dart';
import 'package:health_care_app/patient_features/notifications/domain/entities/notification.dart';
import 'package:health_care_app/patient_features/notifications/presentation/widgets/notification_date.dart';

import '../../../../config/routes/routes.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _isAllRead = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: "Notifications"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //---------header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    notificationDate("Today"),
                    //make all as read button
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _isAllRead = true;
                        });
                      },
                      child: const Text("Mark all read"),
                    ),
                  ],
                ),
                const Divider(
                  endIndent: 15,
                  indent: 15,
                ),
                //----------notifications-------------//
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, Routes.addReviewScreen);
                  },
                  child: notificationItem(
                    notification: NotificationEntity(
                      title: "Review your doctor",
                      content:
                          "please review your doctor based on your experience",
                      isSchedule: false,
                      timeStamp: DateTime.now(),
                    ),
                  ),
                ),
                notificationItem(
                  notification: NotificationEntity(
                    title: "schedule appointment",
                    content: "this is the content of the notification",
                    isSchedule: true,
                    timeStamp: DateTime.now(),
                  ),
                ),
                notificationItem(
                  notification: NotificationEntity(
                    title: "schedule appointment",
                    content: "this is the content of the notification",
                    isSchedule: false,
                    timeStamp: DateTime.now(),
                  ),
                ),
                notificationItem(
                  notification: NotificationEntity(
                    title: "schedule appointment",
                    content: "this is the content of the notification",
                    isSchedule: true,
                    timeStamp: DateTime.now(),
                  ),
                ),
                const Divider(
                  endIndent: 15,
                  indent: 15,
                ),
                notificationDate("Yesterday"),
                notificationItem(
                  notification: NotificationEntity(
                    title: "Yesterday notification",
                    content: "that's what i'm talking about",
                    isSchedule: false,
                    timeStamp: DateTime(2025, 2, 18),
                  ),
                ),
                notificationItem(
                  notification: NotificationEntity(
                    title: "Yesterday notification",
                    content: "that's what i'm talking about",
                    isSchedule: true,
                    timeStamp: DateTime(2025, 2, 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
