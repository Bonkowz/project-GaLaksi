import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class TravelPlanCard extends StatelessWidget {
  const TravelPlanCard({required this.travelPlan, super.key});

  final TravelPlan travelPlan;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin:
          EdgeInsets.zero +
          const EdgeInsets.only(top: 8) +
          const EdgeInsets.only(bottom: 8),
      height: 180,
      child: Card.outlined(
        margin: EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image(
                  image: AssetImage('assets/images/galaksi-placeholder.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        travelPlan.title,
                        style: textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.alarm),
                        Text(
                          "Happening in 2 days",
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.calendar_month),
                        Text(
                          "May 5 - June 3, 2025",
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.map),
                        Text(
                          travelPlan.activities.length == 0
                              ? "No activities yet"
                              : "${travelPlan.activities.length} activities",
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
