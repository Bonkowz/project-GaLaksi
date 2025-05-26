import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:galaksi/utils/time_utils.dart';

/// Source: Mitch KoKo on YouTube (https://www.youtube.com/watch?v=uKz8tWbMuUw)
class NotificationService {
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  final bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // iOS initialization
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize settings
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(initSettings);

    notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel',
        'Reminders',
        channelDescription: 'Travel Plan Reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  Future<void> scheduleNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    DateTime? scheduledDate,
  }) async {
    return notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      payload: payload,
      TimeUtils.convertToTZ(scheduledDate!, "Asia/Manila"),
      notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelNotification({required int id}) async {
    return notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    debugPrint("Cancelling all notifs");
    return notificationsPlugin.cancelAll();
  }
}
