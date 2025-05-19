import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/models/user/user_model.dart';

class FirebaseFirestoreApi {
  FirebaseFirestoreApi() {
    // Turn off disk caching.
    db.settings = const Settings(persistenceEnabled: false);
  }

  /// An instance of the database
  static final db = FirebaseFirestore.instance;

  /// Returns a [DocumentSnapshot] of an existing user in the database given its username
  Future<FirestoreResult<DocumentSnapshot<Map<String, dynamic>>>>
  getUserDocumentByUsername(String username) async {
    final query =
        await db
            .collection("users")
            .where("username", isEqualTo: username)
            .get();

    if (query.metadata.isFromCache && query.docs.isEmpty) {
      return const FirestoreFailure(
        message: "You are offline.",
        error: FirestoreFailureError.networkError,
      );
    } else if (query.docs.isEmpty) {
      return const FirestoreFailure(
        message: "User not found.",
        error: FirestoreFailureError.notFound,
      );
    } else {
      return FirestoreSuccess(message: "User found.", data: query.docs.first);
    }
  }

  /// Returns a [DocumentSnapshot] of an existing user in the database given its canonical email
  Future<FirestoreResult<DocumentSnapshot<Map<String, dynamic>>>>
  getUserDocumentByCanonicalEmail(String canonicalEmail) async {
    final query =
        await db
            .collection("users")
            .where("emailCanonical", isEqualTo: canonicalEmail)
            .get();

    if (query.metadata.isFromCache && query.docs.isEmpty) {
      return const FirestoreFailure(
        message: "You are offline.",
        error: FirestoreFailureError.networkError,
      );
    } else if (query.docs.isEmpty) {
      return const FirestoreFailure(
        message: "User not found.",
        error: FirestoreFailureError.notFound,
      );
    } else {
      return FirestoreSuccess(message: "User found.", data: query.docs.first);
    }
  }

  /// Returns a [DocumentSnapshot] of an existing user in the database given its uid
  Future<FirestoreResult<DocumentSnapshot<Map<String, dynamic>>>>
  getUserDocumentByUid(String uid) async {
    final doc = await db.collection("users").doc(uid).get();

    if (doc.metadata.isFromCache && !doc.exists) {
      return const FirestoreFailure(
        message: "You are offline.",
        error: FirestoreFailureError.networkError,
      );
    } else {
      return FirestoreSuccess(message: "User found.", data: doc);
    }
  }

  /// Returns a [Stream] of an existing user given its uid
  FirestoreResult<Stream<DocumentSnapshot>> getUserStream(String uid) {
    try {
      return FirestoreSuccess(
        message: "Fetched user's travel plans successfully.",
        data: db.collection("users").doc(uid).snapshots(),
      );
    } catch (e) {
      return const FirestoreFailure(
        message: "An unknown error occurred.",
        error: FirestoreFailureError.unknown,
      );
    }
  }

  /// Adds a [User] to the users collection
  Future<FirestoreResult<bool>> addUser(User user) async {
    try {
      // Explicitly set the id of the document to match the uid of the auth user
      await db
          .collection("users")
          .doc(user.uid)
          .set(user.toMap())
          .timeout(const Duration(seconds: 10));
      return const FirestoreSuccess(
        message: "User added successfully.",
        data: true,
      );
    } on TimeoutException catch (_) {
      return const FirestoreFailure(
        message: "Request timed out. Please check your internet connection.",
        error: FirestoreFailureError.networkError,
      );
    } catch (e) {
      debugPrint("Error adding user profile: $e");
      return const FirestoreFailure(
        message: "An unknown error occurred.",
        error: FirestoreFailureError.unknown,
      );
    }
  }

  /// Updates a [User] in the users collection
  Future<FirestoreResult<bool>> updateUser(User user, User newUser) async {
    try {
      await db
          .collection("users")
          .doc(user.uid)
          .update(newUser.toMap())
          .timeout(const Duration(seconds: 10));
      return const FirestoreSuccess(
        message: "User updated successfuly.",
        data: true,
      );
    } on TimeoutException catch (_) {
      return const FirestoreFailure(
        message: "Request timed out. Please check your internet connection.",
        error: FirestoreFailureError.networkError,
      );
    } catch (e) {
      debugPrint("Error updating user profile: $e");
      return const FirestoreFailure(
        message: "An unknown error occurred.",
        error: FirestoreFailureError.unknown,
      );
    }
  }

  /// Deletes a [User] in the users collection given its uid
  Future<FirestoreResult<bool>> deleteUser(String uid) async {
    try {
      await db
          .collection("users")
          .doc(uid)
          .delete()
          .timeout(const Duration(seconds: 10));
      return const FirestoreSuccess(
        message: "User deleted successfully",
        data: true,
      );
    } on TimeoutException catch (_) {
      return const FirestoreFailure(
        message: "Request timed out. Please check your internet connection.",
        error: FirestoreFailureError.networkError,
      );
    } catch (e) {
      debugPrint("Error updating user profile: $e");
      return const FirestoreFailure(
        message: "An unknown error occurred.",
        error: FirestoreFailureError.unknown,
      );
    }
  }

  /// Creates a new [TravelPlan] in the `plans` collection
  Future<FirestoreResult<bool>> createTravelPlan(TravelPlan travelPlan) async {
    try {
      await db
          .collection("plans")
          .add(travelPlan.toMap())
          .timeout(const Duration(seconds: 10));
      return const FirestoreSuccess(
        message: "Plan added succesfully.",
        data: true,
      );
    } on TimeoutException catch (_) {
      return const FirestoreFailure(
        message: "Request timed out. Please check your internet connection.",
        error: FirestoreFailureError.networkError,
      );
    } catch (e) {
      debugPrint("Error creating travel plan: $e");
      return const FirestoreFailure(
        message: "An unknown error occurred.",
        error: FirestoreFailureError.unknown,
      );
    }
  }

  Future<FirestoreResult<bool>> editTravelPlan(TravelPlan travelPlan) async {
    try {
      await db
          .collection("plans")
          .doc(travelPlan.id)
          .update({
            "title": travelPlan.title,
            "description": travelPlan.description,
          })
          .timeout(const Duration(seconds: 10));
      return const FirestoreSuccess(
        message: "Plan edited succesfully.",
        data: true,
      );
    } on TimeoutException catch (_) {
      return const FirestoreFailure(
        message: "Request timed out. Please check your internet connection.",
        error: FirestoreFailureError.networkError,
      );
    } catch (e) {
      debugPrint("Error creating travel plan: $e");
      return const FirestoreFailure(
        message: "An unknown error occurred.",
        error: FirestoreFailureError.unknown,
      );
    }
  }

  FirestoreResult<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchUserPlans(
    String uid,
  ) {
    try {
      return FirestoreSuccess(
        message: "Fetched user's travel plans successfully.",
        data:
            db
                .collection("plans")
                .where('creatorID', isEqualTo: uid)
                .snapshots(),
      );
    } catch (e) {
      return const FirestoreFailure(
        message: "An unknown error occurred.",
        error: FirestoreFailureError.unknown,
      );
    }
  }

  FirestoreResult<Stream<QuerySnapshot<Map<String, dynamic>>>>
  fetchPlansSharedWithUser(String uid) {
    try {
      return FirestoreSuccess(
        message: "Fetched shared travel plans successfully.",
        data:
            db
                .collection("plans")
                .where('sharedWith', arrayContains: uid)
                .snapshots(),
      );
    } catch (e) {
      return const FirestoreFailure(
        message: "An unknown error occurred.",
        error: FirestoreFailureError.unknown,
      );
    }
  }
}

/// Represents a result of an attempted database access
abstract class FirestoreResult<T extends Object> {
  const FirestoreResult({required this.message});

  /// A message that explains the result of the authentication attempt
  final String message;

  /// Performs an action based on the result of FirestoreResult
  ///
  /// Inspired by Flutter Riverpod's Async Value:
  /// https://pub.dev/documentation/flutter_riverpod/latest/flutter_riverpod/AsyncValueX/when.html
  R when<R>({
    required R Function(FirestoreSuccess<T> success) onSuccess,
    required R Function(FirestoreFailure<T> failure) onFailure,
  }) {
    if (this is FirestoreSuccess<T>) {
      return onSuccess(this as FirestoreSuccess<T>);
    } else if (this is FirestoreFailure<T>) {
      return onFailure(this as FirestoreFailure<T>);
    } else {
      throw StateError("Invalid firestore result.");
    }
  }
}

/// Represents a successful database access where data exists.
class FirestoreSuccess<T extends Object> extends FirestoreResult<T> {
  const FirestoreSuccess({required super.message, required this.data});

  final T data;
}

/// Represents a unsuccessful database access.
class FirestoreFailure<T extends Object> extends FirestoreResult<T> {
  const FirestoreFailure({required super.message, required this.error});

  final FirestoreFailureError error;
}

/// Represents the different causes of a FirestoreFailure.
enum FirestoreFailureError { notFound, networkError, unknown }
