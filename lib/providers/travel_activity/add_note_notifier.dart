import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/note_model.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_note_notifier.g.dart';

@riverpod
class AddNoteNotifier extends _$AddNoteNotifier {
  @override
  NoteState build() {
    return NoteState();
  }

  void updateAuthorID(String authorID) {
    state = state.copyWith(authorID: authorID);
  }

  void updateMessage(String message) {
    state = state.copyWith(message: message);
  }

  void updateCreatedAt(DateTime date, TimeOfDay time) {
    final clearedDate = DateTime(date.year, date.month, date.day);
    final newDateTime = clearedDate.add(
      Duration(hours: time.hour, minutes: time.minute),
    );
    state = state.copyWith(createdAt: newDateTime);
    debugPrint("Start at: ${state.createdAt}");
  }

  Future<bool> addNote({required String travelPlanId}) async {
    final travelPlan =
        ref.read(travelPlanStreamProvider(travelPlanId)).valueOrNull;
    if (travelPlan == null) {
      return false;
    }

    final note = Note(
      authorID: state.authorID!,
      message: state.message!,
      createdAt: state.createdAt!,
    );

    final result = await FirebaseFirestoreApi().addNote(
      travelPlan.id,
      note,
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

class NoteState {
  NoteState({
    this.authorID,
    this.message,
    this.createdAt,
  });

  String? authorID;
  String? message;
  DateTime? createdAt;

  NoteState copyWith({
  String? authorID,
  String? message,
  DateTime? createdAt,
  }) {
    return NoteState(
      authorID: authorID ?? this.authorID,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
