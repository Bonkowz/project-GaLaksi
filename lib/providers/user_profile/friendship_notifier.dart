import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/user/friendship_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'friendship_notifier.g.dart';

@Riverpod(keepAlive: true)
class FriendshipNotifier extends _$FriendshipNotifier {
  @override
  List<Friendship> build() {
    ref.listen(friendshipStreamProvider, (prev, next) async {
      final friendships = next.value ?? [];
      state = friendships;
    }, fireImmediately: true);
    return [];
  }

  Friendship? checkFriendship(String userId, String otherUserId) {
    for (final friendship in state) {
      if (friendship.involves(userId) && friendship.involves(otherUserId)) {
        return friendship;
      }
    }
    return null;
  }

  Future<void> requestFriendship({
    required String requesterUserId,
    required String userId,
  }) async {
    final friendship = checkFriendship(requesterUserId, userId);
    if (friendship != null) {
      // Users are already friends
      if (friendship.status == FriendshipStatus.friends) return;

      // Requester already requested friendship
      if (friendship.status == FriendshipStatus.pending) return;
    }

    // Add the friendship as pending
    await FirebaseFirestoreApi().addFriendship(
      Friendship.between(
        userId1: requesterUserId,
        userId2: userId,
        status: FriendshipStatus.pending,
        initiatorId: requesterUserId,
      ),
    );
  }

  Future<void> rejectFriendship({
    required String userId,
    required String requesterUserId,
  }) async {
    final friendship = checkFriendship(userId, requesterUserId);

    // There is no pending friendship
    if (friendship == null) return;

    // Can't reject if friendship is not pending
    if (friendship.status != FriendshipStatus.pending) return;

    // Remove the pending friendship
    await FirebaseFirestoreApi().removeFriendship(friendship);
  }

  Future<void> friend({
    required String userId,
    required String otherUserId,
  }) async {
    final friendship = checkFriendship(userId, otherUserId);
    // Friendship is not yet requested
    if (friendship == null) return;

    // Users are already friends
    if (friendship.status != FriendshipStatus.pending) return;

    // Update the friendship status to friends
    await FirebaseFirestoreApi().updateFriendship(
      friendship,
      FriendshipStatus.friends,
    );
  }

  Future<void> unfriend({
    required String userId,
    required String otherUserId,
  }) async {
    final friendship = checkFriendship(userId, otherUserId);
    // Friendship is not yet requested
    if (friendship == null) return;

    // Users are not friends
    if (friendship.status != FriendshipStatus.friends) return;

    // Remove the friendship
    await FirebaseFirestoreApi().removeFriendship(friendship);
  }
}

@riverpod
Stream<List<Friendship>> friendshipStream(Ref ref) {
  final result = FirebaseFirestoreApi().fetchFriendships();

  return result.when(
    onSuccess: (success) {
      final stream = success.data;
      final list = stream.map(
        (snapshot) =>
            snapshot.docs
                .map((friendship) => Friendship.fromDocument(friendship))
                .toList(),
      );
      return list;
    },
    onFailure: (failure) {
      return Stream.error("Error accessing stream");
    },
  );
}
