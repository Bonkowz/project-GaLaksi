import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/notifications/notification_service_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = ref.read(notificationServiceProvider);
    return Center(
      child: TextButton(
        onPressed: () {
          notificationService.scheduleNotification(
            title: "Yeah Boit",
            body: "Hello",
            scheduledDate: DateTime.now().add(const Duration(seconds: 5)),
          );
        },
        child: const Text("Send Notification"),
      ),
    );
  }
}
