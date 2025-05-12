import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  Note({
    required this.authorID,
    required this.message,
    required this.createdAt,
  });

  /// Factory constructor to instantiate [Note] from [Map]
  factory Note.fromMap(Map<String, dynamic> json) {
    return Note(
      authorID: json['authorID'],
      message: json['message'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  String authorID;
  String message;
  DateTime createdAt;

  /// Method to convert [Note] to a [Map]
  Map<String, dynamic> toMap() {
    return {
      "authorID": authorID,
      "message": message,
      "createdAt": Timestamp.fromDate(createdAt),
    };
  }
}
