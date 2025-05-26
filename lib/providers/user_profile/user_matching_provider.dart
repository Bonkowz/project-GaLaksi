import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_matching_provider.g.dart';

// MATCHING USERS
class UserMatch {
  UserMatch({
    required this.user,
    required this.commonInterests,
    required this.commonTravelStyles,
  });

  final User user;
  final int commonInterests;
  final int commonTravelStyles;

  /// total number of commonalities (interests + travel styles)
  int get totalCommonalities => commonInterests + commonTravelStyles;

  // checker if there is at least one common interest or travel style
  bool get hasAnyCommonalities => commonInterests > 0 || commonTravelStyles > 0;
}

// RIVERPOD PROVIDER (find matching users)
@Riverpod(keepAlive: true)
Stream<List<UserMatch>> userMatching(Ref ref) {
  final currentUser = ref.watch(authNotifierProvider).user!;
  final currentUserInterests =
      currentUser.interests?.map((i) => i.name).toList() ?? [];
  final currentUserTravelStyles =
      currentUser.travelStyles?.map((ts) => ts.name).toList() ?? [];

  return FirebaseFirestore.instance
      .collection('users')
      .where('isPrivate', isEqualTo: false)
      .snapshots()
      .where((snapshot) => !snapshot.metadata.isFromCache)
      .asyncMap((allUsersSnapshot) async {
        return allUsersSnapshot.docs
            .where((doc) => doc.id != currentUser.uid)
            .map(
              (doc) => _createUserMatch(
                doc,
                currentUserInterests,
                currentUserTravelStyles,
              ),
            )
            // filter out users with no commonalities
            .where((match) => match.hasAnyCommonalities)
            // sort matches by total number of commonalities (descending)
            .toList()
          ..sort(
            (a, b) => b.totalCommonalities.compareTo(a.totalCommonalities),
          );
      });
}

// retrieve current/logged in user's interests and travel styles
UserMatch _createUserMatch(
  DocumentSnapshot doc,
  List<String> currentUserInterests,
  List<String> currentUserTravelStyles,
) {
  final userData = doc.data() as Map<String, dynamic>;
  final userInterests = List<String>.from(userData['interests'] ?? []);
  final userTravelStyles = List<String>.from(userData['travelStyles'] ?? []);

  final commonInterests = _countCommonItems(
    userInterests,
    currentUserInterests,
  );
  final commonTravelStyles = _countCommonItems(
    userTravelStyles,
    currentUserTravelStyles,
  );

  final user = User.fromDocument(doc);

  return UserMatch(
    user: user,
    commonInterests: commonInterests,
    commonTravelStyles: commonTravelStyles,
  );
}

// count the number of common items between two lists (list1 and list2).
int _countCommonItems(List<String> list1, List<String> list2) {
  return list1.where((item) => list2.contains(item)).length;

  /// return count of similar items in both lists.
}
