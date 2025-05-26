import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

class TravelActivity {
  TravelActivity({
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.location,
    required this.reminders,
  });

  /// Factory method to instantiate [TravelActivity] from [Map]
  factory TravelActivity.fromMap(Map<String, dynamic> json) {
    return TravelActivity(
      startAt: (json['startAt'] as Timestamp).toDate(),
      endAt: (json['endAt'] as Timestamp).toDate(),
      title: json['title'],
      location: Place.fromMap(json['location']),
      reminders:
          (json['reminders'] as List)
              .map((e) => Duration(minutes: e['minutes']))
              .toList(),
    );
  }

  DateTime startAt;
  DateTime endAt;
  String title;
  Place location;
  List<Duration> reminders;

  /// Function to convert [TravelActivity] to a [Map]
  Map<String, dynamic> toMap() {
    return {
      'startAt': Timestamp.fromDate(startAt),
      'endAt': Timestamp.fromDate(endAt),
      'title': title,
      'location': location.toMap(),
      'reminders': reminders.map((e) => {'minutes': e.inMinutes}).toList(),
    };
  }

  /// SRC: https://medium.com/@hamxa678/operator-overloading-in-dart-517dde92e23d
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TravelActivity) return false;

    final listEquals = const DeepCollectionEquality().equals;

    return startAt == other.startAt &&
        endAt == other.endAt &&
        title == other.title &&
        location == other.location && // Make sure Place also overrides ==
        listEquals(reminders, other.reminders);
  }

  @override
  int get hashCode => Object.hash(
    startAt,
    endAt,
    title,
    location,
    const DeepCollectionEquality().hash(reminders),
  );
}

class Place {
  Place({required this.name, required this.displayName});

  // Factory constructor to create Place from JSON map
  factory Place.fromMap(Map<String, dynamic> json) {
    return Place(
      name: json['name'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
    );
  }

  final String name;
  final String displayName;

  Map<String, dynamic> toMap() {
    return {'name': name, 'display_name': displayName};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Place) return false;

    return name == other.name && displayName == other.displayName;
  }

  @override
  int get hashCode => Object.hash(name, displayName);
}
