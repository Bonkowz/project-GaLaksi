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
            final formattedDateHeader = DateFormat('MMM d,yyyy').format(date);
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
                        IconButton(
                          icon: const Icon(Symbols.edit, size: 24),
                          onPressed: () {
                            // TODO: Implement navigation to an edit page for the entire day's activities or add new activity for this day
                            debugPrint(
                              'Edit button pressed for date: $formattedDateHeader',
                            );
                          },
                          constraints: const BoxConstraints(),
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
                            (context, index) => IndicatorStyle.dot,
                        contentsBuilder: (context, index) {
                          final activity = activitiesForDay[index];
                          final startTime =
                              "${activity.startAt.toLocal().hour}:${activity.startAt.toLocal().minute.toString().padLeft(2, '0')}";
                          final endTime =
                              "${activity.endAt.toLocal().hour}:${activity.endAt.toLocal().minute.toString().padLeft(2, '0')}";
                          final timeRange = "$startTime to $endTime";

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timeRange,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                Text(
                                  activity.title,
                                  style: Theme.of(context).textTheme.bodyMedium,
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
      ],
    );
  }
}
