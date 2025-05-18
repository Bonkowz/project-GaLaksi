import 'package:galaksi/models/user/interest_model.dart';
import 'package:galaksi/models/user/travel_style_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.email,
    required this.emailCanonical,
    required this.uid,
    required this.interests,
    required this.travelStyles,
    this.image = '',
    this.biography = '',
    this.phoneNumber = '',
  });

  /// Factory constructor to instantiate object from a [DocumentSnapshot]
  factory User.fromDocument(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return User(
      // The uid is directly obtainable from the document id, since they match
      uid: doc.id,
      image: map['image'] ?? '',
      firstName: map['firstName'],
      lastName: map['lastName'],
      username: map['username'],
      email: map['email'],
      emailCanonical: map['emailCanonical'],
      interests:
          (List<String>.from(
            map['interests'],
          )).map((s) => Interest.values.firstWhere((i) => s == i.name)).toSet(),
      travelStyles:
          (List<String>.from(map['travelStyles']))
              .map((s) => TravelStyle.values.firstWhere((t) => s == t.name))
              .toSet(),
      biography: map['biography'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  String uid;
  String image;
  String firstName;
  String lastName;
  String username;
  String email;
  String emailCanonical;
  Set<Interest>? interests;
  Set<TravelStyle>? travelStyles;
  String biography;
  String phoneNumber;

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'emailCanonical': emailCanonical,
      'interests': interests?.map((i) => i.name).toList(),
      'travelStyles': travelStyles?.map((t) => t.name).toList(),
      'image': image,
      'biography':biography,
      'phoneNumber': phoneNumber
    };
  }

  User copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? emailCanonical,
    Set<Interest>? interests,
    Set<TravelStyle>? travelStyles,
    String? image,
    String? biography,
    String? phoneNumber
  }) {
    return User(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      email: email ?? this.email,
      emailCanonical: emailCanonical ?? this.emailCanonical,
      uid: uid,
      interests: interests ?? this.interests,
      travelStyles: travelStyles ?? this.travelStyles,
      image: image ?? this.image,
      biography: biography ?? this.biography,
      phoneNumber: phoneNumber ?? this.phoneNumber
    );
  }
}
