import 'package:flutter_riverpod/flutter_riverpod.dart';
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
