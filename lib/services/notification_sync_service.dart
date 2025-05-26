import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/services/notification_service.dart';
import 'package:galaksi/utils/time_utils.dart';

class NotificationSyncService {
  final NotificationService _notificationService;

  NotificationSyncService(this._notificationService);

  List<int> getNotificationIdsForPlan(TravelPlan plan) {
    final notificationIds = <int>[];

    for (final activity in plan.activities) {
      for (final reminder in activity.reminders) {
        final id = Object.hash(plan.id, activity, reminder);
        notificationIds.add(id);
      }
    }

    return notificationIds;
  }

  Future<void> cancelNotificationsForPlan(TravelPlan plan) async {
    final ids = getNotificationIdsForPlan(plan);
    for (final id in ids) {
      await _notificationService.cancelNotification(id: id);
      debugPrint("[${DateTime.now()}] Canceled notif for ${id}");
    }
  }

  Future<void> scheduleNotificationsForPlan(TravelPlan plan) async {
    for (final activity in plan.activities) {
      for (final reminder in activity.reminders) {
        final scheduledDate = activity.startAt.subtract(reminder);
        final id = Object.hash(plan.id, activity, reminder);

        _notificationService.scheduleNotification(
          id: id,
          title: plan.title,
          body:
              "${activity.title} is starting in ${TimeUtils.convertDurationToStr(reminder)}!",
          payload: plan.id,
          scheduledDate: scheduledDate,
        );

        debugPrint("[${DateTime.now()}] Scheduled notif for ${activity.title}");
      }
    }
  }
}
