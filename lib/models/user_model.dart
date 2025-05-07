import 'dart:convert';

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.phoneNumber,
    required this.email,
    this.id,
    this.interests,
    this.travelStyles,
  });

  // Factory constructor to instantiate object from json format
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      userName: json['userName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      interests: json['interests'],
      travelStyles: json['travelStyles'],
    );
  }

  String? id;
  String firstName;
  String lastName;
  String userName;
  String phoneNumber;
  String email;
  List<String>? interests;
  List<String>? travelStyles;

  static List<User> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<User>((dynamic d) => User.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'userName': userName,
      'phoneNumber': phoneNumber,
      'email': email,
      'interests': interests,
      'travelStyles': travelStyles,
    };
  }
}
