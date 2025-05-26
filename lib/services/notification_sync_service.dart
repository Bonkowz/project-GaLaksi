import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/notification_model.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/services/notification_service.dart';
import 'package:galaksi/utils/time_utils.dart';

class NotificationSyncService {
  NotificationSyncService(this._notificationService);
  final NotificationService _notificationService;

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

  Future<void> cancelLocalNotificationsForPlan(TravelPlan plan) async {
    final ids = getNotificationIdsForPlan(plan);
    for (final id in ids) {
      await _notificationService.cancelNotification(id: id);
      debugPrint("[${DateTime.now()}] Canceled notif for $id");
    }
  }

  Future<void> scheduleLocalNotificationsForPlan(TravelPlan plan) async {
    for (final activity in plan.activities) {
      for (final reminder in activity.reminders) {
        final scheduledDate = activity.startAt.subtract(reminder);
        final id = Object.hash(plan.id, activity, reminder);
        final stringId = "${plan.id}_${scheduledDate.toIso8601String()}";
        final receivers = [...plan.sharedWith, plan.creatorID];

        final notification = UserNotification(
          notificationID: stringId,
          to: receivers,
          planID: plan.id,
          title: plan.title,
          body:
              "${activity.title} is starting in ${TimeUtils.convertDurationToStr(reminder)}!",
          scheduledAt: scheduledDate,
          isRead: false,
        );

        _notificationService.scheduleNotification(
          id: id,
          title: notification.title,
          body: notification.body,
          payload: notification.planID,
          scheduledDate: notification.scheduledAt,
        );
      }
    }
  }

  Future<void> syncLocalNotifications({
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

      // Shared with has changed
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
        await cancelLocalNotificationsForPlan(updatedPlan);
        await scheduleLocalNotificationsForPlan(updatedPlan);
      }
    }

    // Remove notifications for removed plans
    final removedPlans = previousPlans.where(
      (prevPlan) => !nextPlans.any((nextPlan) => nextPlan.id == prevPlan.id),
    );

    for (final plan in removedPlans) {
      await cancelLocalNotificationsForPlan(plan);
    }
  }

  Future<void> syncCloudNotificationForPlan(TravelPlan plan) async {
    for (final activity in plan.activities) {
      for (final reminder in activity.reminders) {
        final scheduledDate = activity.startAt.subtract(reminder);
        final id = Object.hash(plan.id, activity, reminder);
        final stringId = "${plan.id}_${scheduledDate.toIso8601String()}";
        final receivers = [...plan.sharedWith, plan.creatorID];

        final notification = UserNotification(
          notificationID: stringId,
          to: receivers,
          planID: plan.id,
          title: plan.title,
          body:
              "${activity.title} is starting in ${TimeUtils.convertDurationToStr(reminder)}!",
          scheduledAt: scheduledDate,
          isRead: false,
        );

        // Fetch existing cloud notification
        final notificationQuery = await FirebaseFirestoreApi()
            .fetchNotificationFromID(notification.notificationID);

        UserNotification? userNotification;

        notificationQuery.when(
          onSuccess: (success) {
            userNotification = UserNotification.fromDocument(success.data);
          },
          onFailure: (_) {
            userNotification = null;
          },
        );

        final deepEq = const DeepCollectionEquality();

        final isSame =
            userNotification != null &&
            userNotification!.planID == notification.planID &&
            userNotification!.title == notification.title &&
            userNotification!.body == notification.body &&
            userNotification!.scheduledAt == notification.scheduledAt &&
            deepEq.equals(userNotification!.to, notification.to);

        if (!isSame) {
          await FirebaseFirestoreApi().addCloudNotification(notification);
          await FirebaseFirestoreApi().deleteCloudNotification(id);
          debugPrint(
            "[NOT_TRACE ${DateTime.now()}] Synced cloud notif for ${activity.title}",
          );
        } else {
          debugPrint("Skipped cloud sync (no changes): ${activity.title}");
        }
      }
    }
  }

  Future<void> syncCloudNotifications({required List<TravelPlan> plans}) async {
    for (final plan in plans) {
      await syncCloudNotificationForPlan(plan);
    }
  }
}
