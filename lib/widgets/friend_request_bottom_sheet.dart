import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/friendship_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/user_profile/friendship_notifier.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';

class FriendRequestBottomSheet extends ConsumerWidget {
  const FriendRequestBottomSheet({
    required this.user,
    required this.friendship,
    required this.currentUser,
    required this.isOutgoingRequest,
    super.key,
  });

  final User user;
  final Friendship friendship;
  final User currentUser;
  final bool isOutgoingRequest;

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
              UserAvatar(image: user.image, firstName: user.firstName),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.firstName} ${user.lastName}",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "@${user.username}",
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

          Text(
            isOutgoingRequest ? "Cancel Friend Request?" : "Friend Request",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            isOutgoingRequest
                ? "You sent a friend request to ${user.firstName}."
                : "${user.firstName} wants to be your friend",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Action buttons
          if (isOutgoingRequest)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  // Current user is cancelling the request they sent to "user"
                  friendshipNotifier.rejectFriendship(
                    userId: currentUser.uid, // The one performing the action
                    requesterUserId:
                        user.uid, // The other user in the friendship
                  );
                  Navigator.of(context).pop();
                },
                icon: const Icon(Symbols.cancel_rounded),
                label: const Text("Cancel Request"),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Current user is rejecting a request from "user"
                      friendshipNotifier.rejectFriendship(
                        userId:
                            currentUser.uid, // The one performing the action
                        requesterUserId:
                            user.uid, // The one who sent the request
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Symbols.person_remove_rounded),
                    label: const Text("Reject"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                      side: BorderSide(color: colorScheme.error),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      friendshipNotifier.friend(
                        userId: currentUser.uid,
                        otherUserId: user.uid,
                      );
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Symbols.person_add_rounded),
                    label: const Text("Accept"),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
