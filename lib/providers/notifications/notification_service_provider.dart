import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/notification_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/services/notification_service.dart';
import 'package:galaksi/services/notification_sync_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service_provider.g.dart';

@riverpod
NotificationService notificationService(Ref ref) {
  final notificationService = NotificationService();
  return notificationService;
}

@riverpod
NotificationSyncService notificationSyncService(Ref ref) {
  final notificationSyncService = NotificationSyncService(
    ref.read(notificationServiceProvider),
  );

  return notificationSyncService;
}

@riverpod
Stream<List<UserNotification>> userNotificationsStream(Ref ref) {
  final currentAuthUser = ref.watch(currentUserStreamProvider);
  final authUid = currentAuthUser.when(
    data: (user) => user?.uid,
    error: (error, stackTrace) {
      debugPrint("Error fetching current user: $stackTrace");
      return null;
    },
    loading: () {
      debugPrint("Auth data is loading.");
      return null;
    },
  );

  // If the UID is null, we cannot create a profile
  if (authUid == null) {
    debugPrint("Error fetching travel plans");
    return const Stream.empty();
  }

  final result = FirebaseFirestoreApi().fetchNotificationsToUser(authUid);
  return result.when(
    onSuccess: (success) {
      return success.data.map(
        (qShot) =>
            qShot.docs
                .map((doc) => UserNotification.fromDocument(doc))
                .toList(),
      );
    },
    onFailure: (failure) {
      debugPrint("Error fetching data: ${failure.message}");
      return const Stream.empty();
    },
  );
}
