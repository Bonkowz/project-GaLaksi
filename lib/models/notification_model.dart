import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  Notification({
    required this.to,
    required this.planID,
    required this.title,
    required this.body,
    required this.scheduledAt,
    required this.isRead,
  });

  /// Factory to instantiate [Notification] from [Map]
  factory Notification.fromMap(Map<String, dynamic> json) {
    return Notification(
      to: List<String>.from(json['to'] ?? []),
      planID: json['planID'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      scheduledAt: (json['scheduledAt'] as Timestamp).toDate(),
      isRead: json['isRead'] as bool,
    );
  }

  List<String>
  to; // List of people who are supposed to receive the notification. Owner + shared.
  String planID;
  String title;
  String body;
  DateTime scheduledAt;
  bool isRead;

  Map<String, dynamic> toMap() {
    return {
      'to': to,
      'planID': planID,
      'title': title,
      'body': body,
      'scheduledAt': Timestamp.fromDate(scheduledAt),
      'isRead': isRead,
    };
  }
}
