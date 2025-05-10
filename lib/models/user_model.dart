import 'package:galaksi/models/interest_model.dart';
import 'package:galaksi/models/travel_style_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.uid,
    required this.interests,
    required this.travelStyles,
  });

  /// Factory constructor to instantiate object from a [DocumentSnapshot]
  factory User.fromDocument(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return User(
      // The uid is directly obtainable from the document id, since they match
      uid: doc.id,
      firstName: map['firstName'],
      lastName: map['lastName'],
      username: map['username'],
      email: map['email'],
      interests: map['interests'],
      travelStyles: map['travelStyles'],
    );
  }

  String uid;
  String firstName;
  String lastName;
  String username;
  String email;
  Set<Interest>? interests;
  Set<TravelStyle>? travelStyles;

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'interests': interests?.map((i) => i.name).toList(),
      'travelStyles': travelStyles?.map((t) => t.name).toList(),
    };
  }
}
