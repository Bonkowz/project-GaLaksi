import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/user_profile/friendship_notifier.dart';
import 'package:galaksi/widgets/public_profile.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';

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
              UserAvatar(user: targetUser),
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
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => PublicProfile(user: targetUser),
                      showDragHandle: true,
                      useSafeArea: true,
                      isScrollControlled: true,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    );
                  },
                  icon: const Icon(Symbols.person_rounded),
                  label: const Text("View Profile"),
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
