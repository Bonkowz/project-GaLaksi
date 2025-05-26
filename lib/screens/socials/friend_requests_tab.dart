import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/friendship_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/user_profile/friendship_notifier.dart';
import 'package:galaksi/providers/user_profile/user_profile_notifier.dart';
import 'package:galaksi/utils/dummy_data.dart';
import 'package:galaksi/widgets/friend_request_bottom_sheet.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FriendRequestsTab extends ConsumerWidget {
  const FriendRequestsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).user;

    if (currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            tabs: const [Tab(text: "Incoming"), Tab(text: "Outgoing")],
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: TabBarView(
              children: [
                _FriendRequestListView(
                  isIncoming: true,
                  currentUserUid: currentUser.uid,
                ),
                _FriendRequestListView(
                  isIncoming: false,
                  currentUserUid: currentUser.uid,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendRequestListView extends ConsumerWidget {
  const _FriendRequestListView({
    required this.isIncoming,
    required this.currentUserUid,
  });

  final bool isIncoming;
  final String currentUserUid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendships = ref.watch(friendshipNotifierProvider);

    final requests =
        friendships.where((friendship) {
          final isPending = friendship.status == FriendshipStatus.pending;
          final involvesCurrentUser = friendship.involves(currentUserUid);
          final isInitiator = friendship.initiatorId == currentUserUid;
          if (isIncoming) {
            return isPending && involvesCurrentUser && !isInitiator;
          } else {
            return isPending && involvesCurrentUser && isInitiator;
          }
        }).toList();

    if (requests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "No ${isIncoming ? "incoming" : "outgoing"} friend requests",
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final friendship = requests[index];
        final otherUserId =
            friendship.userIdLower == currentUserUid
                ? friendship.userIdHigher
                : friendship.userIdLower;

        return _FriendRequestCard(userId: otherUserId, friendship: friendship);
      },
    );
  }
}

class _FriendRequestCard extends ConsumerWidget {
  const _FriendRequestCard({required this.userId, required this.friendship});

  final String userId;
  final Friendship friendship;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileStreamProvider(userId));

    return userAsync.when(
      data:
          (user) =>
              _FriendRequestCardDetails(user: user, friendship: friendship),
      loading:
          () => Skeletonizer(
            child: _FriendRequestCardDetails(
              user: dummyUser,
              friendship: friendship,
            ),
          ),
      error:
          (error, stack) => Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text("Error loading user: $error"),
            ),
          ),
    );
  }
}

class _FriendRequestCardDetails extends ConsumerWidget {
  const _FriendRequestCardDetails({
    required this.user,
    required this.friendship,
  });

  final User user;
  final Friendship friendship;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authNotifierProvider).user!;

    return Card.outlined(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(image: user.image, firstName: user.firstName),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${user.firstName} ${user.lastName}",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    user.username,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  if (user.biography.isNotEmpty) ...[
                    const SizedBox(height: 8.0),
                    Text(
                      user.biography,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Symbols.more_vert_rounded),
              onPressed: () {
                final isOutgoingRequest =
                    friendship.initiatorId == currentUser.uid;
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  builder:
                      (context) => FriendRequestBottomSheet(
                        user: user,
                        friendship: friendship,
                        currentUser: currentUser,
                        isOutgoingRequest: isOutgoingRequest,
                      ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
