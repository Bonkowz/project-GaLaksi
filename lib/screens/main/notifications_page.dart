import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:galaksi/services/notification_service.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () {
          NotificationService().scheduleNotification(
            title: "Yeah Boit",
            body: "Hello",
            scheduledDate: DateTime.now().add(Duration(seconds: 5)),
          );
        },
        child: const Text("Send Notification"),
      ),
    );
  }
}
