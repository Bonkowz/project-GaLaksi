import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/screens/overlays/create_travel_activity_page.dart';
import 'package:galaksi/screens/overlays/edit_travel_activity_page.dart';
import 'package:galaksi/utils/string_utils.dart';
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

  bool isFuture(DateTime time) {
    return time.isAfter(DateTime.now());
  }

  int findActivityIndex({
    required List<TravelActivity> originalActivities,
    required TravelActivity activityToFind,
  }) {
    return originalActivities.indexWhere((a) => a == activityToFind);
  }

  @override
  Widget build(BuildContext context) {
    final originalActivities = [...activities];
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

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CreateDetailsButton(
            text: "Add an activity...",
            leadingIcon: const Icon(Symbols.add),
            trailingIcon: const Icon(Symbols.map),
            navigateTo: CreateTravelActivityPage(travelPlanId: travelPlanId),
          ),
        ),
        SliverList.builder(
          itemCount: sortedGroupedEntries.length,
          itemBuilder: (context, index) {
            final date = sortedGroupedEntries[index].key;
            final activitiesForDay = sortedGroupedEntries[index].value;
            final formattedDateHeader = DateFormat('MMM d, yyyy').format(date);
            return Card.outlined(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            formattedDateHeader,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 10, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: FixedTimeline.tileBuilder(
                      theme: TimelineTheme.of(context).copyWith(
                        nodePosition: 0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      builder: TimelineTileBuilder.connectedFromStyle(
                        connectorStyleBuilder:
                            (context, index) => ConnectorStyle.solidLine,
                        firstConnectorStyle: ConnectorStyle.transparent,
                        lastConnectorStyle: ConnectorStyle.transparent,
                        contentsAlign: ContentsAlign.basic,
                        indicatorStyleBuilder:
                            (context, index) =>
                                isFuture(activitiesForDay[index].startAt)
                                    ? IndicatorStyle.outlined
                                    : IndicatorStyle.dot,
                        contentsBuilder: (context, index) {
                          final activity = activitiesForDay[index];

                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => EditTravelActivityPage(
                                        travelPlanId: travelPlanId,
                                        originalActivity: activity,
                                        indexAt: findActivityIndex(
                                          originalActivities:
                                              originalActivities,
                                          activityToFind: activity,
                                        ),
                                      ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    StringUtils.getActivityTimeRange(activity),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    activity.title,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  Text(
                                    activity.location.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
      ],
    );
  }
}
