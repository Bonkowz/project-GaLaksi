class Accommodation {
  Accommodation({
    required this.name,
    required this.checkIn,
    required this.checkOut,
    required this.location,
  });

  /// Factory to instantiate [Accommodation] from JSON
  factory Accommodation.fromJson(Map<String, dynamic> json) {
    return Accommodation(
      name: json['name'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      location: json['location'],
    );
  }

  String name;
  DateTime checkIn;
  DateTime checkOut;
  String location;

  /// Method to convert [Accommodation] to JSON
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'checkIn': checkIn.toIso8601String(),
      'checkOut': checkOut.toIso8601String(),
      'location': location,
    };
  }
}
