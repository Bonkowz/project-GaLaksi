import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/friendship_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/user_profile/friendship_notifier.dart';
import 'package:galaksi/providers/user_profile/user_profile_notifier.dart';
import 'package:galaksi/utils/dummy_data.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FriendsTab extends ConsumerWidget {
  const FriendsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendships = ref.watch(friendshipNotifierProvider);
    final currentUser = ref.watch(authNotifierProvider).user!;

    final requests =
        friendships.where((friendship) {
          final isFriend = friendship.status == FriendshipStatus.friends;
          final involvesCurrentUser = friendship.involves(currentUser.uid);
          return isFriend && involvesCurrentUser;
        }).toList();

    if (requests.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text("No friends... so far."),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final friendship = requests[index];
        final otherUserId =
            friendship.userIdLower == currentUser.uid
                ? friendship.userIdHigher
                : friendship.userIdLower;

        return _FriendCard(userId: otherUserId);
      },
    );
  }
}

class _FriendCard extends ConsumerWidget {
  const _FriendCard({required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileStreamProvider(userId));

    return user.when(
      data: (user) => _FriendCardDetails(user: user),
      loading:
          () => Center(
            child: Skeletonizer(child: _FriendCardDetails(user: dummyUser)),
          ),
      error: (error, stackTrace) => const SizedBox.shrink(),
    );
  }
}

class _FriendCardDetails extends ConsumerWidget {
  const _FriendCardDetails({required this.user});

  final User user;

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
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Symbols.more_vert_rounded),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder:
                      (context) => FriendBottomSheet(
                        targetUser: user,
                        currentUser: currentUser,
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

class FriendBottomSheet extends ConsumerWidget {
  const FriendBottomSheet({
    required this.targetUser,
    required this.currentUser,
    super.key,
  });

  final User targetUser;
  final User currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendshipNotifier = ref.read(friendshipNotifierProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              UserAvatar(
                image: targetUser.image,
                firstName: targetUser.firstName,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${targetUser.firstName} ${targetUser.lastName}",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@${targetUser.username}",
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    friendshipNotifier.unfriend(
                      userId: currentUser.uid,
                      otherUserId: targetUser.uid,
                    );
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Symbols.person_remove_rounded),
                  label: const Text("Unfriend"),
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.errorContainer,
                    foregroundColor: colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
