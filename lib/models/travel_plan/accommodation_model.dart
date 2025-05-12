import 'package:cloud_firestore/cloud_firestore.dart';

class Accommodation {
  Accommodation({
    required this.name,
    required this.checkIn,
    required this.checkOut,
    required this.location,
  });

  /// Factory to instantiate [Accommodation] from [Map]
  factory Accommodation.fromMap(Map<String, dynamic> json) {
    return Accommodation(
      name: json['name'],
      checkIn: (json['checkIn'] as Timestamp).toDate(),
      checkOut: (json['checkOut'] as Timestamp).toDate(),
      location: json['location'],
    );
  }

  String name;
  DateTime checkIn;
  DateTime checkOut;
  String location;

  /// Method to convert [Accommodation] to a [Map]
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'checkIn': Timestamp.fromDate(checkIn),
      'checkOut': Timestamp.fromDate(checkOut),
      'location': location,
    };
  }
}
