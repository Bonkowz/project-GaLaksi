import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/models/user/user_model.dart';

class FirebaseFirestoreApi {
  /// An instance of the database
  static final db = FirebaseFirestore.instance;

  /// Returns a [DocumentSnapshot] of an existing user in the database given its username
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDocumentByUsername(
    String username,
  ) async {
    try {
      final query =
          await db
              .collection("users")
              .where("username", isEqualTo: username)
              .get();

      return query.docs.first;
    } catch (e) {
      debugPrint("Error getting user: $e");
      return null;
    }
  }

  /// Returns a [DocumentSnapshot] of an existing user in the database given its canonical email
  Future<DocumentSnapshot<Map<String, dynamic>>?>
  getUserDocumentByCanonicalEmail(String canonicalEmail) async {
    try {
      final query =
          await db
              .collection("users")
              .where("emailCanonical", isEqualTo: canonicalEmail)
              .get();

      return query.docs.isNotEmpty ? query.docs.first : null;
    } catch (e) {
      debugPrint("Error getting user: $e");
      return null;
    }
  }

  /// Returns a [DocumentSnapshot] of an existing user in the database given its uid
  Future<DocumentSnapshot<Map<String, dynamic>>?> getUserDocumentByUid(
    String uid,
  ) async {
    try {
      final doc = await db.collection("users").doc(uid).get();
      return doc;
    } catch (e) {
      debugPrint("Error getting user: $e");
      return null;
    }
  }

  /// Returns a [Stream] of an existing user given its uid
  Stream<DocumentSnapshot> getUserStream(String uid) {
    return db.collection("users").doc(uid).snapshots();
  }

  /// Adds a [User] to the users collection
  Future<bool> addUser(User user) async {
    try {
      // Explicitly set the id of the document to match the uid of the auth user
      await db.collection("users").doc(user.uid).set(user.toMap());
      return true;
    } catch (e) {
      debugPrint("Error adding user profile: $e");
      return false;
    }
  }

  /// Updates a [User] in the users collection
  Future<bool> updateUser(User user, User newUser) async {
    try {
      await db.collection("users").doc(user.uid).update(newUser.toMap());
      return true;
    } catch (e) {
      debugPrint("Error updating user profile: $e");
      return false;
    }
  }

  /// Deletes a [User] in the users collection given its uid
  Future<bool> deleteUser(String uid) async {
    try {
      await db.collection("users").doc(uid).delete();
      return true;
    } catch (e) {
      debugPrint("Error updating user profile: $e");
      return false;
    }
  }

  /// Creates a new [TravelPlan] in the `plans` collection
  Future<bool> createTravelPlan(TravelPlan travelPlan) async {
    try {
      await db.collection("plans").add(travelPlan.toMap());
      return true;
    } catch (e) {
      debugPrint("Error creating travel plan: $e");
      return false;
    }
  }
}
