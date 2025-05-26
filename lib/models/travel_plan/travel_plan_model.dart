import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
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
    this.image = '',
  });

  factory TravelPlan.fromDocument(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;

    return TravelPlan(
      id: doc.id,
      title: map['title'],
      description: map['description'],
      creatorID: map['creatorID'],
      image: map['image'] ?? '',
      sharedWith: List<String>.from(map['sharedWith'] ?? []),
      notes:
          (map['notes'] as List?)?.map((nt) => Note.fromMap(nt)).toList() ?? [],
      activities:
          (map['activities'] as List?)
              ?.map((ac) => TravelActivity.fromMap(ac))
              .toList() ??
          [],
      flightDetails:
          (map['flightDetails'] as List?)
              ?.map((fl) => FlightDetail.fromMap(fl))
              .toList() ??
          [],
      accommodations:
          (map['accommodations'] as List?)
              ?.map((am) => Accommodation.fromMap(am))
              .toList() ??
          [],
    );
  }

  String id;
  String title;
  String description;
  String creatorID;
  String image;
  List<String> sharedWith;
  List<Note> notes;
  List<TravelActivity> activities;
  List<FlightDetail> flightDetails;
  List<Accommodation> accommodations;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'creatorID': creatorID,
      'sharedWith': sharedWith,
      'notes': notes.map((note) => note.toMap()).toList(),
      'activities': activities.map((activity) => activity.toMap()).toList(),
      'flightDetails': flightDetails.map((flight) => flight.toMap()).toList(),
      'accomodations': accommodations.map((accom) => accom.toMap()).toList(),
      'image': image,
    };
  }

  // SRC: https://stackoverflow.com/questions/76697156/how-do-i-compare-dart-records-with-deep-equality
  bool hasDifferentActivities(TravelPlan other) {
    final deepEq = const DeepCollectionEquality();

    // Deep equality comparison for lists compares each element
    return !deepEq.equals(activities, other.activities);
  }

  bool hasDifferentSharedWith(TravelPlan other) {
    final deepEq = const DeepCollectionEquality();

    return !deepEq.equals(sharedWith, other.sharedWith);
  }
}
