import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/screens/overlays/create_travel_activity_page.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';

class ItineraryTab extends StatelessWidget {
  ItineraryTab({required this.activities, super.key});
  List<TravelActivity> activities;
  List <TravelActivity> activitiesTemp = [
    TravelActivity(
      startAt: DateTime(2025, 5, 5, 7, 15),
      endAt: DateTime(2025, 5, 5, 8, 15),
      title: "Quick camping and breakfast",
      location: "Mount Everest Basecamp",
      reminders: [Duration(minutes: 60)],
    ),
    TravelActivity(
      startAt: DateTime(2025, 5, 5, 8, 15),
      endAt: DateTime(2025, 5, 5, 10, 0),
      title: "Prepare for summit push",
      location: "Mount Everest Camp IV",
      reminders: [Duration(minutes: 30)],
    ),
    TravelActivity(
      startAt: DateTime(2025, 5, 5, 10, 0),
      endAt: DateTime(2025, 5, 5, 19, 0),
      title: "Summit Push",
      location: "Mount Everest Summit",
      reminders: [],
    ),
    TravelActivity(
      startAt: DateTime(2025, 5, 5, 19, 0),
      endAt: DateTime(2025, 6, 6, 6, 0),
      title: "Sleep",
      location: "Mount Everest Summit",
      reminders: [],
    ),
    TravelActivity(
      startAt: DateTime(2025, 5, 6, 7, 0),
      endAt: DateTime(2025, 5, 6, 12, 0),
      title: "Descent to Camp IV",
      location: "Mount Everest Camp IV",
      reminders: [Duration(minutes: 120)],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateDetailsButton(
          text: "Add an activity...",
          leadingIcon: const Icon(Symbols.add),
          trailingIcon: const Icon(Symbols.map),
          navigateTo: CreateTravelActivityPage(),
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activitiesTemp.length,
            itemBuilder: (context, index) {
              // TODO: add documentation here
              final activity = activitiesTemp[index];
              final startTime = "${activity.startAt.toLocal().hour}:${activity.startAt.toLocal().minute.toString().padLeft(2, '0')}";
              final endTime = "${activity.endAt.toLocal().hour}:${activity.endAt.toLocal().minute.toString().padLeft(2, '0')}";
              final timeRange = "$startTime to $endTime";

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            timeRange,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            activity.title,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            activity.location,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
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
