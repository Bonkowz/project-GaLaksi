import 'package:flutter/material.dart';
import 'package:galaksi/screens/overlays/create_travel_activity_page.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';

class ItineraryTab extends StatelessWidget {
  ItineraryTab({super.key});

  final tempItineraryItems = <List<String>>[
    [
      "7:15 AM to 8:15 AM",
      "Mount Everest Basecamp",
      "Quick camping and breakfast at basecamp",
    ],
    [
      "7:15 AM to 8:15 AM",
      "Mount Everest Basecamp",
      "Quick camping and breakfast at basecamp",
    ],
    [
      "7:15 AM to 8:15 AM",
      "Mount Everest Basecamp",
      "Quick camping and breakfast at basecamp",
    ],
    [
      "8:15 AM to 10:00 AM",
      "Mount Everest Camp IV",
      "Go to camp IV and prepare for summit",
    ],
    ["10:00 AM to 7:00 PM", "Mount Everest Summit", "Ideal push"],
    ["7:00 PM to 6:00 AM", "Mount Everest Summit", "Sleep"],
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
            itemCount: tempItineraryItems.length,
            itemBuilder: (context, index) {
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
                            tempItineraryItems[index][0], // Itinerary item text
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tempItineraryItems[index][1], // Itinerary item text
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            tempItineraryItems[index][2], // Itinerary item text
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
