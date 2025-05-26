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

  Future<void> syncNotifications({
    required List<TravelPlan> previousPlans,
    required List<TravelPlan> nextPlans,
  }) async {
    for (final updatedPlan in nextPlans) {
      TravelPlan? previousPlan;

      try {
        previousPlan = previousPlans.firstWhere((p) => p.id == updatedPlan.id);
      } catch (e) {
        // Returns StateError on not found
        // A null previousPlan means that this is a new TravelPlan
        previousPlan = null;
      }

      // DEBUG PRINTING, new plan
      if (previousPlan == null) {
        debugPrint("Null previous plan");
      }

      // Different activities
      if (previousPlan != null &&
          updatedPlan.hasDifferentActivities(previousPlan)) {
        debugPrint(
          "${updatedPlan.title} has diff activities with ${previousPlan.title}",
        );
      }

      if (previousPlan != null &&
          updatedPlan.hasDifferentSharedWith(previousPlan)) {
        debugPrint(
          "${updatedPlan.title} has diff shared with ${previousPlan.title}",
        );
      }

      // Check if there are changes in the travel plan
      if (previousPlan == null ||
          updatedPlan.hasDifferentActivities(previousPlan) ||
          updatedPlan.hasDifferentSharedWith(previousPlan)) {
        debugPrint("[NOTIF CHANGE] ${updatedPlan.title}");
        await cancelNotificationsForPlan(updatedPlan);
        await scheduleNotificationsForPlan(updatedPlan);
      }
    }

    // Remove notifications for removed plans
    final removedPlans = previousPlans.where(
      (prevPlan) => !nextPlans.any((nextPlan) => nextPlan.id == prevPlan.id),
    );

    for (final plan in removedPlans) {
      await scheduleNotificationsForPlan(plan);
    }
  }

  Future<void> syncCloudNotifications(TravelPlan plan) async {}
}
