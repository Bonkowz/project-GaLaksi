import 'package:cloud_firestore/cloud_firestore.dart';

class FlightDetail {
  FlightDetail({
    required this.flightNumber,
    required this.airline,
    required this.location,
    required this.destination,
    required this.departureAt,
  });

  /// Factory constructor to create a [FlightDetail] from [Map]
  factory FlightDetail.fromMap(Map<String, dynamic> json) {
    return FlightDetail(
      flightNumber: json['flightNumber'],
      airline: json['airline'],
      location: json['location'],
      destination: json['destination'],
      departureAt: (json['departureAt'] as Timestamp).toDate(),
    );
  }

  String flightNumber;
  String airline;
  String location; // Departure airport / city
  String destination; // Arrival airport / city
  DateTime departureAt;

  /// Method to convert [FlightDetail] to a [Map]
  Map<String, dynamic> toMap() {
    return {
      'flightNumber': flightNumber,
      'airline': airline,
      'location': location,
      'destination': destination,
      'departureAt': Timestamp.fromDate(departureAt),
    };
  }
}
