class TravelPlan {
  TravelPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.creatorID,
    required this.sharedWith,
    required this.notes,
    required this.activities,
    required this.flightDetails,
    required this.accomodations,
  });

  /// TODO: Add attribute for travel plan image

  String id;
  String title;
  String description;
  String creatorID;
  List<String> sharedWith;
  List<Note> notes;
  List<TravelActivity> activities;
  List<FlightDetail> flightDetails;
  List<Accomodation> accomodations;
}

class Accomodation {
  Accomodation({
    required this.name,
    required this.checkIn,
    required this.checkOut,
    required this.location,
  });

  String name;
  DateTime checkIn;
  DateTime checkOut;
  String location;
}

class FlightDetail {
  FlightDetail({
    required this.flightNumber,
    required this.airline,
    required this.location,
    required this.destination,
    required this.departureAt,
  });

  String flightNumber;
  String airline;
  String location; // Departure airport / city
  String destination; // Arrival airport / city
  DateTime departureAt;
}

class TravelActivity {
  TravelActivity({
    required this.startAt,
    required this.endAt,
    required this.title,
    required this.location,
    required this.reminders,
  });

  DateTime startAt;
  DateTime endAt;
  String title;
  String location;
  List<Duration> reminders;
}

class Note {
  Note({
    required this.authorID,
    required this.message,
    required this.createdAt,
  });

  String authorID;
  String message;
  DateTime createdAt;
}
