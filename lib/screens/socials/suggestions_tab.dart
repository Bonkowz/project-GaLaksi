// SUGGESTIONS/FIND SIMILAR PEOPLE
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/friendship_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/user_profile/friendship_notifier.dart';
import 'package:galaksi/providers/user_profile/user_matching_provider.dart';
import 'package:galaksi/widgets/friend_request_bottom_sheet.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';

class SuggestionsTab extends ConsumerWidget {
  const SuggestionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMatchesAsync = ref.watch(userMatchingProvider);

    return userMatchesAsync.when(
      data: (matches) {
        if (matches.isEmpty) {
          // if list of matches with "interests" or "travel styles" is empty,
          return const Center(child: Text('No matching users found'));
        }

        // display profiles of matching users
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return _UserProfileCard(
              user: match.user,
              commonInterests: match.commonInterests,
              commonTravelStyles: match.commonTravelStyles,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

// USER PROFILE CARD CONTENTS
class _UserProfileCard extends ConsumerWidget {
  const _UserProfileCard({
    required this.user,
    required this.commonInterests,
    required this.commonTravelStyles,
  });

  final User user;
  final int commonInterests;
  final int commonTravelStyles;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendships = ref.watch(friendshipNotifierProvider);
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
                  // display interests if there is at least 1 common interest
                  if ((user.interests?.isNotEmpty ?? false) &&
                      commonInterests > 0) ...[
                    const SizedBox(height: 15.0),
                    Text(
                      "Interests:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.interests!
                          .map((interest) => interest.title)
                          .join(", "),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  // display travel styles if there is at least 1 common travel style
                  if ((user.travelStyles?.isNotEmpty ?? false) &&
                      commonTravelStyles > 0) ...[
                    const SizedBox(height: 15.0),
                    Text(
                      "Travel Styles:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.travelStyles!.map((style) => style.title).join(", "),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            // Refactored IconButton logic
            Consumer(
              builder: (context, ref, child) {
                // Find friendship from the watched state
                Friendship? friendship;
                for (final f in friendships) {
                  if (f.involves(currentUser.uid) && f.involves(user.uid)) {
                    friendship = f;
                    break;
                  }
                }

                IconData iconData;
                VoidCallback? onPressedAction;

                if (friendship != null &&
                    friendship.status == FriendshipStatus.friends) {
                  iconData = Symbols.person_check_rounded;
                  onPressedAction = () {
                    // TODO: Implement action for already friends (e.g., view profile or unfriend)
                  };
                } else if (friendship != null &&
                    friendship.status == FriendshipStatus.pending) {
                  iconData = Symbols.more_vert_rounded;
                  onPressedAction = () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder:
                          (bottomSheetContext) => FriendRequestBottomSheet(
                            user: user,
                            friendship: friendship!,
                            currentUser: currentUser,
                            isOutgoingRequest:
                                friendship.initiatorId == currentUser.uid,
                          ),
                    );
                  };
                } else {
                  iconData = Symbols.person_add_rounded;
                  onPressedAction = () {
                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder:
                          (bottomSheetContext) => _SendFriendRequestBottomSheet(
                            targetUser: user,
                            currentUser: currentUser,
                          ),
                    );
                  };
                }

                return IconButton(
                  icon: Icon(iconData),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: onPressedAction,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SendFriendRequestBottomSheet extends ConsumerWidget {
  const _SendFriendRequestBottomSheet({
    required this.targetUser,
    required this.currentUser,
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
          Text(
            "Send Friend Request?",
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Do you want to send a friend request to ${targetUser.firstName}?",
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    friendshipNotifier.requestFriendship(
                      requesterUserId: currentUser.uid,
                      userId: targetUser.uid,
                    );
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Symbols.send_rounded),
                  label: const Text("Send Request"),
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
