import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/auth_notifier.dart';

/// A test page to test out authentication
class SignOutPage extends ConsumerWidget {
  const SignOutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserStreamProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 16,
          children: [
            user.when(
              data:
                  (user) =>
                      user != null
                          ? Text(user.email!)
                          : const SizedBox.shrink(),
              error: (error, stackTrace) => const Text("Error fetching user"),
              loading: () => const CircularProgressIndicator(),
            ),
            FilledButton.icon(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).signOut();
              },
              label: const Text("Sign out"),
              icon: const Icon(Icons.logout_rounded),
            ),
            FilledButton.tonalIcon(
              onPressed: () {
                ref.read(authNotifierProvider.notifier).signOutAndDelete();
              },
              label: const Text("Delete account"),
              icon: const Icon(Icons.delete_forever_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
