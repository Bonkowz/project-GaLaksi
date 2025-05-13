import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_travel_plan_provider.g.dart';

@riverpod
Stream<List<TravelPlan>> myTravelPlans(Ref ref) {
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

  // If the UID is null, we cannot create a profile
  if (authUid == null) {
    debugPrint("Error fetching travel plans");
    return const Stream.empty();
  }

  final stream = FirebaseFirestoreApi().fetchUserPlans(authUid);

  return stream.map(
    (qShot) => qShot.docs.map((doc) => TravelPlan.fromDocument(doc)).toList(),
  );
}
