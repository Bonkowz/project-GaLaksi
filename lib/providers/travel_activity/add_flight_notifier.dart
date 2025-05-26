import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/flight_detail_model.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_flight_notifier.g.dart';

@riverpod
class CreateAddFlightDetailNotifier extends _$CreateAddFlightDetailNotifier {
  @override
  FlightDetailState build() {
    return FlightDetailState();
  }

  void updateFlightNumber(String flightNumber){
    state = state.copyWith(flightNumber: flightNumber);
  }

  void updateAirline(String airline) {
    state = state.copyWith(airline: airline);
  }

  void updateLocation(String place) {
    state = state.copyWith(location: place);
  }

  void updateDestination(String place) {
    state = state.copyWith(destination: place);
  }

  void updateDepartureAt(DateTime date, TimeOfDay time) {
    final clearedDate = DateTime(date.year, date.month, date.day);
    final newDateTime = clearedDate.add(
      Duration(hours: time.hour, minutes: time.minute),
    );
    state = state.copyWith(departureAt: newDateTime);
  }

  Future<bool> addFlightDetail({required String travelPlanId}) async {
    final travelPlan =
        ref.read(travelPlanStreamProvider(travelPlanId)).valueOrNull;
    if (travelPlan == null) {
      return false;
    }

    final flight = FlightDetail(
      flightNumber: state.flightNumber!,
      airline: state.airline!,
      location: state.location!,
      destination: state.destination!,
      departureAt: state.departureAt!,
    );

    final result = await FirebaseFirestoreApi().addFlight(
      travelPlan.id,
      flight,
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

class FlightDetailState {
  FlightDetailState({
    this.flightNumber,
    this.airline,
    this.location,
    this.destination,
    this.departureAt,
  });

  String? flightNumber;
  String? airline;
  String? location; 
  String? destination; 
  DateTime? departureAt;

  FlightDetailState copyWith({
    String? flightNumber,
    String? airline,
    String? location,
    String? destination,
    DateTime? departureAt,
  }) {
    return FlightDetailState(
      flightNumber: flightNumber ?? this.flightNumber,
      airline: airline ?? this.airline,
      location: location ?? this.location,
      destination: destination ?? this.destination,
      departureAt: departureAt ?? this.departureAt,
    );
  }
}
