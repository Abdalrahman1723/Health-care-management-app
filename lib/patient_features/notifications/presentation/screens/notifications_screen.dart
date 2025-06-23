import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/utils/app_bar.dart';
import 'package:health_care_app/patient_features/add_review/presentation/screens/add_review_screen.dart';
import 'package:health_care_app/patient_features/notifications/presentation/cubit/notification_cubit.dart';
import 'package:health_care_app/patient_features/notifications/presentation/cubit/notification_state.dart';
import 'package:health_care_app/patient_features/notifications/presentation/widgets/notification_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../config/routes/routes.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _loadPatientId();
  }

  Future<void> _loadPatientId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('actorId');
    if (id != null && id.isNotEmpty) {
      if (mounted) {
        context.read<NotificationCubit>().fetchNotifications(id);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to load notifications: Patient ID not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: "Notifications"),
      body: SafeArea(
        child: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is NotificationError) {
              return Center(child: Text(state.message));
            }

            if (state is NotificationLoaded) {
              final notifications = state.notifications;
              if (notifications.isEmpty) {
                return const Center(child: Text('No notifications'));
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          notificationDate("Today"),
                          BlocBuilder<NotificationCubit, NotificationState>(
                            builder: (context, state) {
                              return OutlinedButton(
                                onPressed: state is NotificationLoading
                                    ? null
                                    : () {
                                        context
                                            .read<NotificationCubit>()
                                            .markAllNotificationsAsRead();
                                      },
                                child: state is NotificationLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text("Mark all read"),
                              );
                            },
                          ),
                        ],
                      ),
                      const Divider(
                        endIndent: 15,
                        indent: 15,
                      ),
                      ...notifications.map((notification) => InkWell(
                            onTap: () {
                              context
                                  .read<NotificationCubit>()
                                  .markNotificationAsRead(notification.id);
                              if (notification.doctorId == null) {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const AddReviewScreen(
                                      doctorId: 4,
                                      doctorName: "Mohamed Khaled",
                                      patientId: 2,
                                      patientName: "ALi"),
                                ));
                              }
                            },
                            child: notificationItem(
                              notification: notification,
                            ),
                          )),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
