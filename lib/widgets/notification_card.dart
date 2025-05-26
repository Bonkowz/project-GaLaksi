import 'package:flutter/material.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/notification_model.dart';
import 'package:galaksi/screens/travel_details/travel_plan_details_page.dart';
import 'package:galaksi/utils/string_utils.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    required this.notification,
    required this.leadingIcon,
    required this.isRead,
  });

  final UserNotification notification;
  final Icon leadingIcon;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: InkWell(
        onTap: () async {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      TravelPlanDetailsPage(travelPlanId: notification.planID),
            ),
          );
          FirebaseFirestoreApi().markNotificationAsRead(
            notification.notificationID,
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: leadingIcon,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight:
                              isRead ? FontWeight.w600 : FontWeight.w900,
                        ),
                      ),
                      Text(
                        notification.body,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.w900,
                        ),
                      ),
                      Text(
                        StringUtils.timeAgo(notification.scheduledAt),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium!.copyWith(
                          fontWeight:
                              isRead ? FontWeight.w600 : FontWeight.w900,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                isRead
                    ? const SizedBox(width: 24)
                    : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 10, // size
                        height: 10,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
