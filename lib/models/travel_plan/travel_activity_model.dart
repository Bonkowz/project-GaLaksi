import 'package:cloud_firestore/cloud_firestore.dart';

class TravelActivity {
  TravelActivity({
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.location,
    required this.reminders,
  });

  /// Factory method to convert [TravelActivity] from [Map]
  factory TravelActivity.fromJson(Map<String, dynamic> json) {
    return TravelActivity(
      startAt: DateTime.parse(json['startAt']),
      endAt: DateTime.parse(json['endAt']),
      title: json['title'],
      location: json['location'],
      reminders:
          (json['reminders'] as List)
              .map((e) => Duration(minutes: e['minutes']))
              .toList(),
    );
  }

  DateTime startAt;
  DateTime endAt;
  String title;
  String location;
  List<Duration> reminders;

  /// Function to convert [TravelActivity] to [Map]
  Map<String, dynamic> toMap() {
    return {
      'startAt': startAt.toIso8601String(), // Timestamp
      'endAt': endAt.toIso8601String(), // Timestamp
      'title': title,
      'location': location,
      'reminders': reminders.map((e) => {'minutes': e.inMinutes}).toList(),
    };
  }
}
