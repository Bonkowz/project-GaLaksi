import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/providers/travel_plan/current_travel_plan_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_travel_activity_notifier.g.dart';

bool rangesOverlap(
  DateTime start1,
  DateTime end1,
  DateTime start2,
  DateTime end2,
) {
  return start1.isBefore(end2) && start2.isBefore(end1);
}

@riverpod
class CreateTravelActivityNotifier extends _$CreateTravelActivityNotifier {
  @override
  TravelActivityState build() {
    return TravelActivityState();
  }

  void updateStartAt(DateTime date, TimeOfDay time) {
    final clearedDate = DateTime(date.year, date.month, date.day);
    final newDateTime = clearedDate.add(
      Duration(hours: time.hour, minutes: time.minute),
    );

    state = state.copyWith(startAt: newDateTime);
    debugPrint("Start at: ${state.startAt}");
  }

  void updateEndAt(DateTime date, TimeOfDay time) {
    final clearedDate = DateTime(date.year, date.month, date.day);
    final newDateTime = clearedDate.add(
      Duration(hours: time.hour, minutes: time.minute),
    );

    state = state.copyWith(endAt: newDateTime);
    debugPrint("End at: ${state.endAt}");
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateLocation(Place place) {
    debugPrint("Updated place to ${place.name}");
    state = state.copyWith(location: place);
    debugPrint("Confirming: ${state.location?.displayName}");
  }

  void updateReminders(List<Duration> reminders) {
    state = state.copyWith(reminders: reminders);
  }

  Future<bool> addTravelActivity() async {
    debugPrint("Confirming PT 2: ${state.location}");

    final travelActivity = TravelActivity(
      startAt: state.startAt!,
      endAt: state.endAt!,
      title: state.title!,
      location: state.location ?? Place(displayName: 'Error', name: 'Error'),
      reminders: state.reminders!,
    );

    final travelPlan = ref.read(currentTravelPlanProvider)!;

    // Check if clashing time schedules
    for (final existingActivity in travelPlan.activities) {
      if (rangesOverlap(
        travelActivity.startAt,
        travelActivity.endAt,
        existingActivity.startAt,
        existingActivity.endAt,
      )) {
        // Conflict found
        return false;
      }
    }

    final result = await FirebaseFirestoreApi().addTravelActivity(
      travelPlan.id,
      travelActivity,
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
}

class TravelActivityState {
  TravelActivityState({
    this.startAt,
    this.endAt,
    this.title,
    this.location,
    this.reminders,
  });

  DateTime? startAt;
  DateTime? endAt;
  String? title;
  Place? location;
  List<Duration>? reminders;

  TravelActivityState copyWith({
    DateTime? startAt,
    DateTime? endAt,
    String? title,
    Place? location,
    List<Duration>? reminders,
  }) {
    return TravelActivityState(
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      title: title ?? this.title,
      location: location ?? this.location,
      reminders: reminders ?? this.reminders,
    );
  }
}
