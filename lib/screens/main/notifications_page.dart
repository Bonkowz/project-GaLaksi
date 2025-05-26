import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/providers/notifications/notification_service_provider.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/widgets/notification_card.dart';
import 'package:material_symbols_icons/symbols.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            centerTitle: true,
            toolbarHeight: kToolbarHeight * 1.75,
            title: Text(
              "Your Notifications",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              final mergedPlans = await ref.refresh(
                allTravelPlansSnapshotProvider.future,
              );
              ref
                  .watch(notificationSyncServiceProvider)
                  .syncCloudNotifications(plans: mergedPlans);
            },
            child:
                visibleNotifs.isEmpty
                    ? ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      children: [
                        Center(child: Text("No notifications so far")),
                      ],
                    )
                    : ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: visibleNotifs.length,
                      itemBuilder: (context, index) {
                        final notif = visibleNotifs[index];

                        return Padding(
                          padding: const EdgeInsets.only(
                            bottom: 4,
                          ), // spacing between cards
                          child: NotificationCard(
                            notification: notif,
                            leadingIcon: Icon(Symbols.alarm),
                            isRead: notif.isRead,
                          ),
                        );
                      },
                    ),
          ),
        );
      },
      loading:
          () => const SingleChildScrollView(
            child: Center(child: CircularProgressIndicator()),
          ),
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
