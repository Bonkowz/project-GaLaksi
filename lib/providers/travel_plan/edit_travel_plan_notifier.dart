import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/accommodation_model.dart';
import 'package:galaksi/models/travel_plan/flight_detail_model.dart';
import 'package:galaksi/models/travel_plan/note_model.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'edit_travel_plan_notifier.g.dart';

@riverpod
class EditTravelPlanNotifier extends _$EditTravelPlanNotifier {
  @override
  TravelPlanState build() {
    return TravelPlanState();
  }

  void setCurrentTravelPlan(TravelPlan travelPlan) {
    state = state.copyWith(
      id: travelPlan.id,
      title: travelPlan.title,
      description: travelPlan.description,
      creatorID: travelPlan.creatorID,
      sharedWith: travelPlan.sharedWith,
      notes: travelPlan.notes,
      activities: travelPlan.activities,
      flightDetails: travelPlan.flightDetails,
      accommodations: travelPlan.accommodations,
    );
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  Future<bool> editTravelPlan() async {
    final currentAuthUser = ref.watch(currentUserStreamProvider);
    final authUid = currentAuthUser.when(
      data: (user) => user?.uid,
      error: (error, stackTrace) {
        debugPrint("Error fetching current user: $stackTrace");
        return null;
      },
      loading: () {
        debugPrint("Auth data is loading.");
        return null;
      },
    );

    if (authUid == null) {
      debugPrint("Error creating travel plan: Did not obtain user UID");
      return false;
    }

    final editedTravelPlan = TravelPlan(
      id: state.id!,
      title: state.title!,
      description: state.description,
      creatorID: authUid,
      sharedWith: state.sharedWith,
      notes: state.notes,
      activities: state.activities,
      flightDetails: state.flightDetails,
      accommodations: state.accommodations,
    );

    final result = await FirebaseFirestoreApi().editTravelPlan(
      editedTravelPlan,
    );
    return result.when(
      onSuccess: (success) {
        return success.data;
      },
      onFailure: (failure) {
        debugPrint(failure.message);
        return false;
      },
    );
  }

  void reset() {
    state = TravelPlanState();
  }
}

class TravelPlanState {
  TravelPlanState({
    this.id,
    this.title,
    this.description = '',
    this.creatorID,
    this.sharedWith = const [],
    this.notes = const [],
    this.activities = const [],
    this.flightDetails = const [],
    this.accommodations = const [],
  });

  String? id;
  String? title;
  String description;
  String? creatorID;
  List<String> sharedWith;
  List<Note> notes;
  List<TravelActivity> activities;
  List<FlightDetail> flightDetails;
  List<Accommodation> accommodations;

  TravelPlanState copyWith({
    String? id,
    String? title,
    String? description,
    String? creatorID,
    List<String>? sharedWith,
    List<Note>? notes,
    List<TravelActivity>? activities,
    List<FlightDetail>? flightDetails,
    List<Accommodation>? accommodations,
  }) {
    return TravelPlanState(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      creatorID: creatorID ?? this.creatorID,
      sharedWith: sharedWith ?? this.sharedWith,
      notes: notes ?? this.notes,
      activities: activities ?? this.activities,
      flightDetails: flightDetails ?? this.flightDetails,
      accommodations: accommodations ?? this.accommodations,
    );
  }
}
