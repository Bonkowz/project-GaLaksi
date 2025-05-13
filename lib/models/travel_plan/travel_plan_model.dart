import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaksi/models/travel_plan/accommodation_model.dart';
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
    required this.accommodations,
  });

  /// TODO: Add attribute for travel plan image

  factory TravelPlan.fromDocument(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;

    return TravelPlan(
      id: doc.id,
      title: map['title'],
      description: map['description'],
      creatorID: map['creatorID'],
      sharedWith: List<String>.from(map['sharedWith']),
      notes: (map['notes'] as List).map((note) => Note.fromMap(note)).toList(),
      activities:
          (map['activities'] as List)
              .map((activity) => TravelActivity.fromMap(activity))
              .toList(),
      flightDetails:
          (map['flightDetails'] as List)
              .map((flight) => FlightDetail.fromMap(flight))
              .toList(),
      accommodations:
          (map['accommodations'] as List)
              .map((accom) => Accommodation.fromMap(accom))
              .toList(),
    );
  }

  TravelPlan setID(String newID) {
    return TravelPlan(
      id: newID,
      title: title,
      description: description,
      creatorID: creatorID,
      sharedWith: sharedWith,
      notes: notes,
      activities: activities,
      flightDetails: flightDetails,
      accommodations: accommodations,
    );
  }

  String id;
  String title;
  String description;
  String creatorID;
  List<String> sharedWith;
  List<Note> notes;
  List<TravelActivity> activities;
  List<FlightDetail> flightDetails;
  List<Accommodation> accommodations;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'creatorID': creatorID,
      'sharedWith': sharedWith,
      'notes': notes.map((note) => note.toMap()).toList(),
      'activities': activities.map((activity) => activity.toMap()).toList(),
      'flightDetails': flightDetails.map((flight) => flight.toMap()).toList(),
      'accomodations': accommodations.map((accom) => accom.toMap()).toList(),
    };
  }
}
