import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/user_profile/friendship_notifier.dart';

void showLoadingDialog({
  required BuildContext context,
  String? message,
  bool barrierDismissible = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder:
        (context) => PopScope(
          canPop: barrierDismissible,
          onPopInvokedWithResult: (didPop, result) {},
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 16),
                  Text(message ?? "Loading..."),
                ],
              ),
            ),
          ),
        ),
  );
}

void showCustomDialog({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => child,
  );
}

void showUnfriendDialog({
  required BuildContext context,
  required String currentUserId,
  required User user,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Consumer(
        builder: (context, ref, child) {
          final friendshipNotifier = ref.read(
            friendshipNotifierProvider.notifier,
          );
          return AlertDialog(
            title: const Text("Remove friend"),
            content: Text(
              "Are you sure you want to unfriend ${user.firstName}?",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              FilledButton(
                onPressed: () {
                  friendshipNotifier.unfriend(
                    userId: currentUserId,
                    otherUserId: user.uid,
                  );
                  Navigator.of(context).pop();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                child: const Text("Unfriend"),
              ),
            ],
          );
        },
      );
    },
  );
}
