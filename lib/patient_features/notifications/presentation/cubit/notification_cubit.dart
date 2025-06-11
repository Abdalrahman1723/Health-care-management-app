import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/api/api_client.dart';
import 'package:health_care_app/core/api/endpoints.dart';
import 'package:health_care_app/patient_features/notifications/domain/entities/notification.dart';
import 'package:health_care_app/patient_features/notifications/presentation/cubit/notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final ApiClient _apiClient;
  final String authToken; //! will be fetched from shared pref later

  NotificationCubit(this.authToken, {required ApiClient apiClient})
      : _apiClient = apiClient,
        super(NotificationInitial());

  Future<void> fetchNotifications(String patientId) async {
    try {
      emit(NotificationLoading());

      final response = await _apiClient.get(
        '${PatientApiConstants.getNotifications}/$patientId',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response != null) {
        final List<dynamic> notificationsJson = response;
        final notifications = notificationsJson.map((json) {
          return NotificationEntity(
            title: json['title'] ?? '',
            content: json['content'] ?? '',
            isSchedule: json['isSchedule'] ?? false,
            timeStamp: DateTime.parse(
                json['timeStamp'] ?? DateTime.now().toIso8601String()),
            isRead: json['isRead'] ?? false,
          );
        }).toList();

        emit(NotificationLoaded(notifications));
      } else {
        emit(const NotificationError('No notifications found'));
      }
    } catch (e) {
      log('Error fetching notifications: $e');
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updatedNotifications =
            currentState.notifications.map((notification) {
          // if (notification.id == notificationId) {
          //   notification.markAsRead();
          // }
          return notification;
        }).toList();

        emit(NotificationLoaded(updatedNotifications));
      }
    } catch (e) {
      log('Error marking notification as read: $e');
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updatedNotifications =
            currentState.notifications.map((notification) {
          notification.markAsRead();
          return notification;
        }).toList();

        emit(NotificationLoaded(updatedNotifications));
      }
    } catch (e) {
      log('Error marking all notifications as read: $e');
      emit(NotificationError(e.toString()));
    }
  }
}
