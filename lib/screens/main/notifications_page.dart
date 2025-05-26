import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/notifications/notification_service_provider.dart';
import 'package:galaksi/widgets/notification_card.dart';
import 'package:material_symbols_icons/symbols.dart';

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
      data: (notifs) {
        final now = DateTime.now();

        final visibleNotifs =
            notifs.where((n) => now.isAfter(n.scheduledAt)).toList()
              ..sort((a, b) {
                if (a.isRead != b.isRead) {
                  return a.isRead ? 1 : -1;
                }

                return b.scheduledAt.compareTo(a.scheduledAt);
              });

        if (visibleNotifs.isEmpty) {
          return Center(
            child: Text(
              "No notifications... so far.",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {},
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              centerTitle: true,
              toolbarHeight: kToolbarHeight * 1.75,
              title: Text(
                "Your Notifications",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children:
                      visibleNotifs
                          .map(
                            (notif) => NotificationCard(
                              notification: notif,
                              leadingIcon: Icon(Symbols.alarm),
                              isRead: notif.isRead,
                            ),
                          )
                          .toList(),
                ),
              ),
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
