import 'package:cloud_firestore/cloud_firestore.dart';

class Friendship {
  Friendship({
    required this.userIdLower,
    required this.userIdHigher,
    required this.status,
    required this.initiatorId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Factory constructor to instantiate object from [DocumentSnapshot]
  factory Friendship.fromDocument(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return Friendship(
      userIdLower: map['userIdLower'],
      userIdHigher: map['userIdHigher'],
      status: FriendshipStatus.values.firstWhere(
        (s) => s.name == map['status'],
      ),
      initiatorId: map['initiatorId'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Create a friendship between two users
  factory Friendship.between({
    required String userId1,
    required String userId2,
    required FriendshipStatus status,
    required String initiatorId,
  }) {
    // Always order lexicographically
    final ids = [userId1, userId2]..sort();
    return Friendship(
      userIdLower: ids[0],
      userIdHigher: ids[1],
      status: status,
      initiatorId: initiatorId,
      createdAt: DateTime.now(),
    );
  }

  factory Friendship.updateStatus({
    required Friendship friendship,
    required FriendshipStatus status,
  }) {
    if (status == FriendshipStatus.none) {
      throw ArgumentError("Cannot update friendship to 'none'");
    }

    return Friendship(
      userIdLower: friendship.userIdLower,
      userIdHigher: friendship.userIdHigher,
      createdAt: friendship.createdAt,
      initiatorId: friendship.initiatorId,
      status: status,
    );
  }

  final String userIdLower; // Always lexicographically smaller
  final String userIdHigher; // Always lexicographically larger
  final FriendshipStatus status;
  final String initiatorId;
  final DateTime createdAt;

  String get documentId => "$userIdLower-$userIdHigher";

  bool involves(String userId) {
    return userIdLower == userId || userIdHigher == userId;
  }

  Map<String, dynamic> toMap() {
    return {
      'userIdLower': userIdLower,
      'userIdHigher': userIdHigher,
      'status': status.name,
      'initiatorId': initiatorId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  @override
  String toString() => documentId;
}

enum FriendshipStatus { none, pending, friends }
