import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_travel_plan_provider.g.dart';

@Riverpod(keepAlive: true)
Stream<List<TravelPlan>> myTravelPlansStream(Ref ref) {
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

  final result = FirebaseFirestoreApi().fetchUserPlans(authUid);
  return result.when(
    onSuccess: (success) {
      return success.data.map(
        (qShot) =>
            qShot.docs.map((doc) => TravelPlan.fromDocument(doc)).toList(),
      );
    },
    onFailure: (failure) {
      debugPrint("Error fetching data: ${failure.message}");
      return const Stream.empty();
    },
  );
}

@Riverpod(keepAlive: true)
Stream<List<TravelPlan>> sharedTravelPlansStream(Ref ref) {
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

  final result = FirebaseFirestoreApi().fetchPlansSharedWithUser(authUid);
  return result.when(
    onSuccess: (success) {
      return success.data.map(
        (qShot) =>
            qShot.docs.map((doc) => TravelPlan.fromDocument(doc)).toList(),
      );
    },
    onFailure: (failure) {
      debugPrint("Error fetching data: ${failure.message}");
      return const Stream.empty();
    },
  );
}

@riverpod
Stream<TravelPlan?> travelPlanStream(Ref ref, String travelPlanId) {
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

  final result = FirebaseFirestoreApi().fetchTravelPlanStream(travelPlanId);

  return result.when(
    onSuccess: (success) {
      return success.data.map(
        (doc) => doc.exists ? TravelPlan.fromDocument(doc) : null,
      );
    },
    onFailure: (failure) {
      debugPrint("Error fetching data: ${failure.message}");
      return const Stream.empty();
    },
  );
}

@riverpod
Future<List<TravelPlan>> myTravelPlansSnapshot(Ref ref) async {
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
    return Future.value([]);
  }

  final result = await FirebaseFirestoreApi().fetchUserPlansSnapshot(authUid);

  return result.when(
    onSuccess:
        (success) =>
            success.data.docs
                .map((doc) => TravelPlan.fromDocument(doc))
                .toList(),
    onFailure: (error) {
      debugPrint("Error fetching my travel plans: ${error.message}");
      return Future.value([]);
    },
  );
}

@riverpod
Future<List<TravelPlan>> sharedTravelPlansSnapshot(Ref ref) async {
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
    return Future.value([]);
  }

  final result = await FirebaseFirestoreApi().fetchPlansSharedWithUserSnapshot(
    authUid,
  );

  return result.when(
    onSuccess:
        (success) =>
            success.data.docs
                .map((doc) => TravelPlan.fromDocument(doc))
                .toList(),
    onFailure: (error) {
      debugPrint("Error fetching shared travel plans: ${error.message}");
      return Future.value([]);
    },
  );
}

@riverpod
Future<List<TravelPlan>> allTravelPlansSnapshot(Ref ref) async {
  final userPlans = await ref.watch(myTravelPlansSnapshotProvider.future);
  final sharedPlans = await ref.watch(sharedTravelPlansSnapshotProvider.future);

  return [...userPlans, ...sharedPlans];
}
