import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// MATCHING USERS
class UserMatch {
  final String userId;
  final String firstName;
  final String lastName;
  final String username;
  final List<String> interests;
  final List<String> travelStyles;
  final int commonInterests;
  final int commonTravelStyles;

  UserMatch({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.interests,
    required this.travelStyles,
    required this.commonInterests,
    required this.commonTravelStyles,
  });

  /// total number of commonalities (interests + travel styles)
  int get totalCommonalities => commonInterests + commonTravelStyles;
  
  // checker if there is at least one common interest or travel style
  bool get hasAnyCommonalities => commonInterests > 0 || commonTravelStyles > 0;
}

// RIVERPOD PROVIDER (find matching users)
final userMatchingProvider = StreamProvider<List<UserMatch>>((ref) {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .snapshots()
      .asyncMap((currentUserDoc) async {
    if (!currentUserDoc.exists) return [];

    // gets the current/logged in user's interests and travel styles
    final currentUserData = currentUserDoc.data()!;
    final currentUserInterests = List<String>.from(currentUserData['interests'] ?? []);
    final currentUserTravelStyles = List<String>.from(currentUserData['travelStyles'] ?? []);

    //retrieve all other users from firestore
    final allUsersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    
    return allUsersSnapshot.docs
        .where((doc) => doc.id != currentUser.uid)
        .map((doc) => _createUserMatch(
              doc,
              currentUserInterests,
              currentUserTravelStyles,
            ))
        // filter out users with no commonalities
        .where((match) => match.hasAnyCommonalities)
        // sort matches by total number of commonalities (descending)
        .toList()
      ..sort((a, b) => b.totalCommonalities.compareTo(a.totalCommonalities));
  });
});

// retrieve current/logged in user's interests and travel styles
UserMatch _createUserMatch(
  DocumentSnapshot doc,
  List<String> currentUserInterests,
  List<String> currentUserTravelStyles,
) {
  final userData = doc.data() as Map<String, dynamic>;
  final userInterests = List<String>.from(userData['interests'] ?? []);
  final userTravelStyles = List<String>.from(userData['travelStyles'] ?? []);

  final commonInterests = _countCommonItems(userInterests, currentUserInterests);
  final commonTravelStyles = _countCommonItems(userTravelStyles, currentUserTravelStyles);

  return UserMatch(
    userId: doc.id,
    firstName: userData['firstName'] ?? '',
    lastName: userData['lastName'] ?? '',
    username: userData['username'] ?? '',
    interests: userInterests,
    travelStyles: userTravelStyles,
    commonInterests: commonInterests,
    commonTravelStyles: commonTravelStyles,
  );
}

// count the number of common items between two lists (list1 and list2).
int _countCommonItems(List<String> list1, List<String> list2) {
  return list1.where((item) => list2.contains(item)).length;  /// return count of similar items in both lists.
} 