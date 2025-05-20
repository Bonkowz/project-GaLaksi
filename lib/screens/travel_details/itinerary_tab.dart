import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/screens/overlays/create_travel_activity_page.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';

class ItineraryTab extends StatelessWidget {
  ItineraryTab({required this.activities, super.key});
  List<TravelActivity> activities;
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
            itemCount: activities.length,
            itemBuilder: (context, index) {
              // TODO: add documentation here
              final activity = activities[index];
              final startTime =
                  "${activity.startAt.toLocal().hour}:${activity.startAt.toLocal().minute.toString().padLeft(2, '0')}";
              final endTime =
                  "${activity.endAt.toLocal().hour}:${activity.endAt.toLocal().minute.toString().padLeft(2, '0')}";
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
