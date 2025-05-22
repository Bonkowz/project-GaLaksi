import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/screens/overlays/create_travel_activity_page.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:intl/intl.dart';
import 'package:timelines_plus/timelines_plus.dart';

class ItineraryTab extends StatelessWidget {
  const ItineraryTab({
    required this.travelPlanId,
    required this.activities,
    super.key,
  });

  final String travelPlanId;
  final List<TravelActivity> activities;
  // List<TravelActivity> activitiesTemp = [
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 5, 7, 15),
  //     endAt: DateTime(2025, 5, 5, 8, 15),
  //     title: "Quick camping and breakfast",
  //     location: "Mount Everest Basecamp",
  //     reminders: [Duration(minutes: 60)],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 5, 8, 15),
  //     endAt: DateTime(2025, 5, 5, 10, 0),
  //     title: "Prepare for summit push",
  //     location: "Mount Everest Camp IV",
  //     reminders: [Duration(minutes: 30)],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 5, 10, 0),
  //     endAt: DateTime(2025, 5, 5, 19, 0),
  //     title: "Summit Push",
  //     location: "Mount Everest Summit",
  //     reminders: [],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 5, 19, 0),
  //     endAt: DateTime(2025, 6, 6, 6, 0),
  //     title: "Sleep",
  //     location: "Mount Everest Summit",
  //     reminders: [],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 6, 7, 0),
  //     endAt: DateTime(2025, 5, 6, 12, 0),
  //     title: "Descent to Camp IV",
  //     location: "Mount Everest Camp IV",
  //     reminders: [Duration(minutes: 120)],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 1, 9, 0), // Earlier date
  //     endAt: DateTime(2025, 5, 1, 17, 0),
  //     title: "Arrival and acclimatization",
  //     location: "Kathmandu, Nepal",
  //     reminders: [],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 7, 13, 0), // Date between existing ones
  //     endAt: DateTime(2025, 5, 7, 16, 0),
  //     title: "Basecamp debriefing",
  //     location: "Mount Everest Basecamp",
  //     reminders: [Duration(minutes: 60)],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 6, 10, 10, 0), // Later date
  //     endAt: DateTime(2025, 6, 10, 14, 0),
  //     title: "Return flight preparation",
  //     location: "Kathmandu Hotel",
  //     reminders: [Duration(hours: 24)],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 2, 8, 30), // Another earlier date
  //     endAt: DateTime(2025, 5, 2, 10, 0),
  //     title: "Gear check and packing",
  //     location: "Kathmandu Outfitter",
  //     reminders: [],
  //   ),
  //   TravelActivity(
  //     startAt: DateTime(2025, 5, 7, 8, 0),
  //     endAt: DateTime(2025, 5, 7, 12, 0),
  //     title: "Medical check-up",
  //     location: "Basecamp Clinic",
  //     reminders: [Duration(minutes: 15)],
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    activities.sort((a, b) => a.startAt.compareTo(b.startAt));

    final groupedActivities = <DateTime, List<TravelActivity>>{};
    for (final activity in activities) {
      final dateKey = DateTime(
        activity.startAt.year,
        activity.startAt.month,
        activity.startAt.day,
      );
      if (!groupedActivities.containsKey(dateKey)) {
        groupedActivities[dateKey] = [];
      }
      groupedActivities[dateKey]!.add(activity);
    }

    final sortedGroupedEntries =
        groupedActivities.entries.toList()
          ..sort((a, b) => a.key.compareTo(b.key));

    return Column(
      children: [
        CreateDetailsButton(
          text: "Add an activity...",
          leadingIcon: const Icon(Symbols.add),
          trailingIcon: const Icon(Symbols.map),
          navigateTo: CreateTravelActivityPage(travelPlanId: travelPlanId),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: sortedGroupedEntries.length,
            itemBuilder: (context, dateIndex) {
              final date = sortedGroupedEntries[dateIndex].key;
              final activitiesForDay = sortedGroupedEntries[dateIndex].value;

              final formattedDateHeader = DateFormat('MMM d,yyyy').format(date);

              return Card.outlined(
                color: Theme.of(context).colorScheme.onPrimary,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              formattedDateHeader,
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Symbols.edit, size: 24),
                            onPressed: () {
                              // TODO: Implement navigation to an edit page for the entire day's activities or add new activity for this day
                              debugPrint(
                                'Edit button pressed for date: $formattedDateHeader',
                              );
                            },
                            visualDensity: VisualDensity.compact,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 10, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FixedTimeline.tileBuilder(
                        theme: TimelineTheme.of(
                          context,
                        ).copyWith(nodePosition: 0),
                        builder: TimelineTileBuilder.fromStyle(
                          contentsAlign: ContentsAlign.basic,
                          oppositeContentsBuilder:
                              (context, index) => const SizedBox.shrink(),
                          contentsBuilder: (context, index) {
                            final activity = activitiesForDay[index];
                            final startTime =
                                "${activity.startAt.toLocal().hour}:${activity.startAt.toLocal().minute.toString().padLeft(2, '0')}";
                            final endTime =
                                "${activity.endAt.toLocal().hour}:${activity.endAt.toLocal().minute.toString().padLeft(2, '0')}";
                            final timeRange = "$startTime to $endTime";

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    timeRange,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.right,
                                  ),
                                  Text(
                                    activity.title,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    activity.location.displayName,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: activitiesForDay.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
