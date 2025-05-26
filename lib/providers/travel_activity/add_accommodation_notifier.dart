import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/accommodation_model.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_accommodation_notifier.g.dart';

@riverpod
class CreateAddAccommodationNotifier extends _$CreateAddAccommodationNotifier {
  @override
  AccommodationState build() {
    return AccommodationState();
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateLocation(String place) {
    state = state.copyWith(location: place);
  }

  void updateCheckIn(DateTime date, TimeOfDay time) {
    final clearedDate = DateTime(date.year, date.month, date.day);
    final newDateTime = clearedDate.add(
      Duration(hours: time.hour, minutes: time.minute),
    );
    state = state.copyWith(checkIn: newDateTime);
  }

  void updateCheckOut(DateTime date, TimeOfDay time) {
    final clearedDate = DateTime(date.year, date.month, date.day);
    final newDateTime = clearedDate.add(
      Duration(hours: time.hour, minutes: time.minute),
    );
    state = state.copyWith(checkOut: newDateTime);
  }
  
  Future<bool> addAccommodation({required String travelPlanId}) async {
    final travelPlan =
        ref.read(travelPlanStreamProvider(travelPlanId)).valueOrNull;
    if (travelPlan == null) {
      return false;
    }

    final accommodation = Accommodation(
      name: state.name!,
      location: state.location!,
      checkIn: state.checkIn!,
      checkOut: state.checkOut!,
    );

    final result = await FirebaseFirestoreApi().addAccommodation(
      travelPlan.id,
      accommodation,
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

class AccommodationState {
  AccommodationState({
    this.name,
    this.checkIn,
    this.checkOut,
    this.location,
  });

  String? name;
  DateTime? checkIn;
  DateTime? checkOut;
  String? location;

  AccommodationState copyWith({
    String? name,
    DateTime? checkIn,
    DateTime? checkOut,
    String? location,
  }) {
    return AccommodationState(
      name: name ?? this.name,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
      location: location ?? this.location,
    );
  }
}
