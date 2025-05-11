import 'package:galaksi/models/travel_plan/accomodation_model.dart';
import 'package:galaksi/models/travel_plan/flight_detail_model.dart';
import 'package:galaksi/models/travel_plan/note_model.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';

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
  List<Accommodation> accomodations;
}
