import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/friendship_model.dart';
import 'package:galaksi/models/user/interest_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/user_profile/friendship_notifier.dart';
import 'package:galaksi/utils/dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

class PublicProfile extends ConsumerStatefulWidget {
  const PublicProfile({required this.user, super.key});

  final User user;

  @override
  ConsumerState<PublicProfile> createState() => _PublicProfileState();
}

class _PublicProfileState extends ConsumerState<PublicProfile> {
  final double coverHeight = 150;
  final double profileHeight = 200;
  late final user = widget.user;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              buildTop(),
              _profileInfo(),
              _canViewPrivateDetails()
                  ? buildAbout()
                  : _buildPrivateProfileMessage(),
            ],
          ),
        );
      },
    );
  }

  bool _canViewPrivateDetails() {
    final currentUser = ref.watch(authNotifierProvider).user!;

    // If the profile is not private, allow access
    if (!user.isPrivate) {
      return true;
    }

    // If profile is private, check friendship status
    final friendships = ref.watch(friendshipNotifierProvider);
    for (final friendship in friendships) {
      if (friendship.involves(currentUser.uid) &&
          friendship.involves(user.uid) &&
          friendship.status == FriendshipStatus.friends) {
        return true;
      }
    }

    return false;
  }

  Widget _buildPrivateProfileMessage() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Symbols.lock_rounded,
            size: 64,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            "Private Profile",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "This user's profile is private. Send a friend request to view their details.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTop() {
    return Column(children: [const SizedBox(height: 32), _profileImage()]);
  }

  Widget _profileImage() {
    final image = user.image;
    final s = user.firstName[0].toUpperCase();
    final innerRadius = (profileHeight / 2) - 8.0;
    final outerSize = profileHeight;

    return Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 8.0,
        ),
      ),
      child:
          image.isEmpty
              ? CircleAvatar(
                radius: innerRadius,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  StringUtils.capitalize(s),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              )
              : CircleAvatar(
                radius: innerRadius,
                backgroundImage: MemoryImage(base64Decode(image)),
              ),
    );
  }

  Widget _profileInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            "${user.firstName} ${user.lastName}",
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "@${user.username}",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildFriendButton(),
        ],
      ),
    );
  }

  Widget buildAbout() {
    // Only show detailed information if user can view private details
    if (!_canViewPrivateDetails()) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _biography(),
          _interests(),
          _travelStyles(),
          Row(
            children: [
              Expanded(child: infoCard("Email", user.email)),
              user.phoneNumber.isNotEmpty
                  ? Expanded(child: infoCard("Phone Number", user.phoneNumber))
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _biography() {
    if (user.biography.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Card.filled(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biography",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(user.biography, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _interests() {
    if (user.interests?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Card.filled(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Interests",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...Interest.categorized.entries.map((entry) {
              final category = entry.key;
              final interests =
                  entry.value
                      .where((e) => user.interests!.contains(e))
                      .toList();
              if (interests.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 6),
                    child: Text(
                      StringUtils.capitalize(category.title),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        interests.where((e) => user.interests!.contains(e)).map(
                          (e) {
                            return Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              label: Text(e.title),
                            );
                          },
                        ).toList(),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _travelStyles() {
    if (user.travelStyles?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Card.filled(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Travel Styles",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children:
                  user.travelStyles!
                      .map(
                        (item) => Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          label: Text(item.title),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String title, String content) => Card.filled(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    ),
  );

  Widget _buildFriendButton() {
    final currentUser = ref.watch(authNotifierProvider).user;
    final friendships = ref.watch(friendshipNotifierProvider);
    final friendshipNotifier = ref.read(friendshipNotifierProvider.notifier);

    // Don't show friend button for current user
    if (currentUser == null || currentUser.uid == user.uid) {
      return const SizedBox.shrink();
    }

    // Find friendship status between current user and profile user
    Friendship? friendship;
    for (final f in friendships) {
      if (f.involves(currentUser.uid) && f.involves(user.uid)) {
        friendship = f;
        break;
      }
    }

    Widget button;
    if (friendship == null) {
      // No friendship exists
      button = FilledButton.icon(
        onPressed: () {
          friendshipNotifier.requestFriendship(
            requesterUserId: currentUser.uid,
            userId: user.uid,
          );
        },
        icon: const Icon(Symbols.person_add_rounded),
        label: const Text("Add Friend"),
      );
    } else if (friendship.status == FriendshipStatus.pending) {
      if (friendship.initiatorId == currentUser.uid) {
        // Current user sent the friend request
        button = OutlinedButton.icon(
          onPressed: () {
            friendshipNotifier.rejectFriendship(
              userId: currentUser.uid,
              requesterUserId: user.uid,
            );
          },
          icon: const Icon(Symbols.cancel_rounded),
          label: const Text("Cancel Request"),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
            side: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
        );
      } else {
        // Other user sent the request
        button = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                friendshipNotifier.rejectFriendship(
                  userId: currentUser.uid,
                  requesterUserId: user.uid,
                );
              },
              icon: const Icon(Symbols.person_remove_rounded),
              label: const Text("Reject"),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () {
                friendshipNotifier.friend(
                  userId: currentUser.uid,
                  otherUserId: user.uid,
                );
              },
              icon: const Icon(Symbols.person_add_rounded),
              label: const Text("Accept"),
            ),
          ],
        );
      }
    } else if (friendship.status == FriendshipStatus.friends) {
      // Already friends
      button = OutlinedButton.icon(
        onPressed: () {
          showUnfriendDialog(
            context: context,
            currentUserId: currentUser.uid,
            user: user,
          );
        },
        icon: const Icon(Symbols.person_check_rounded),
        label: const Text("Friends"),
        style: OutlinedButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.primary,
          side: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }

    return button;
  }
}
