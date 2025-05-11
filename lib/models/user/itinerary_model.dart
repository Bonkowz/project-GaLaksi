import 'dart:convert';

class Coordinates {
  Coordinates(this.latitude, this.longitude);
  double latitude;
  double longitude;
}

class Itinerary {
  Itinerary({
    required this.name,
    required this.dates,
    required this.location,
    this.id,
    this.flightDetails,
    this.accommodation,
    this.notes,
    this.checklist,
  });

  // Factory constructor to instantiate object from json format
  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      id: json['id'],
      name: json['name'],
      dates: json['dates'],
      location: json['location'],
      flightDetails: json['flightDetails'],
      accommodation: json['accommodation'],
      notes: json['notes'],
      checklist: json['checklist'],
    );
  }
  String? id;
  String name;
  List<String> dates;
  Coordinates location;
  String? flightDetails;
  String? accommodation;
  String? notes;
  List<String>? checklist;

  static List<Itinerary> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Itinerary>((dynamic d) => Itinerary.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': dates,
      'location': location,
      'flightDetails': flightDetails,
      'accommodation': accommodation,
      'notes': notes,
      'checklist': checklist,
    };
  }
}
