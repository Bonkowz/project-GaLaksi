import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/notifications/notification_service_provider.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationService = ref.read(notificationServiceProvider);
    return Center(child: NotificationsView());
  }
}

class NotificationsView extends ConsumerWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsyncValue = ref.watch(userNotificationsStreamProvider);

    return plansAsyncValue.when(
      data: (plans) {
        if (plans.isEmpty) {
          return Center(
            child: Text(
              "No plans... so far.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: plans.map((plan) => Text(plan.body)).toList(),
            ),
          ),
        );
      },
      loading:
          () => const SingleChildScrollView(child: Center(child: Text(""))),
      error: (err, stack) {
        debugPrint("$err");
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}
