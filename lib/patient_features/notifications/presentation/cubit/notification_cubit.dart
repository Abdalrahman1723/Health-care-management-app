import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_care_app/core/api/api_client.dart';
import 'package:health_care_app/core/api/endpoints.dart';
import 'package:health_care_app/patient_features/notifications/domain/entities/notification.dart';
import 'package:health_care_app/patient_features/notifications/presentation/cubit/notification_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final ApiClient _apiClient;
  String? authToken;

  NotificationCubit({required ApiClient apiClient})
      : _apiClient = apiClient,
        super(NotificationInitial());

  int getUnreadCount() {
    if (state is NotificationLoaded) {
      return (state as NotificationLoaded)
          .notifications
          .where((notification) => !notification.isRead)
          .length;
    }
    return 0;
  }

  Future<void> fetchNotifications(String patientId) async {
    if (patientId.isEmpty) {
      emit(const NotificationError('Invalid patient ID'));
      return;
    }

    try {
      emit(NotificationLoading());

      // Get token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(const NotificationError('Authentication token not found'));
        return;
      }

      final response = await _apiClient.get(
        '${PatientApiConstants.getNotifications}/$patientId',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response != null) {
        final List<dynamic> notificationsJson = response;
        final notifications = notificationsJson
            .map((json) => NotificationEntity.fromJson(json))
            .toList();

        emit(NotificationLoaded(notifications));
      } else {
        emit(const NotificationError('No notifications found'));
      }
    } catch (e) {
      log('Error fetching notifications: $e');
      emit(NotificationError(e.toString()));
    }
  }

  Future<void> markNotificationAsRead(int notificationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(const NotificationError('Authentication token not found'));
        return;
      }

      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updatedNotifications =
            currentState.notifications.map((notification) {
          if (notification.id == notificationId) {
            notification.markAsRead();
          }
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
      final prefs = await SharedPreferences.getInstance();
      authToken = prefs.getString('token');

      if (authToken == null) {
        emit(const NotificationError('Authentication token not found'));
        return;
      }

      // Get current state
      final currentState = state;
      if (currentState is NotificationLoaded) {
        // Make API call to mark all notifications as read
        final response = await _apiClient.put(
          PatientApiConstants.markAllNotificationsAsRead,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $authToken',
          },
        );

        if (response != null) {
          // Update local state
          final updatedNotifications =
              currentState.notifications.map((notification) {
            notification.markAsRead();
            return notification;
          }).toList();

          emit(NotificationLoaded(updatedNotifications));
        } else {
          emit(const NotificationError('Failed to mark all notifications as read'));
        }
      }
    } catch (e) {
      log('Error marking all notifications as read: $e');
      emit(NotificationError(e.toString()));
    }
  }
}
