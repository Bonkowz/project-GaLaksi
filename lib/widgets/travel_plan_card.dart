import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/providers/travel_plan/current_travel_plan_provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:galaksi/screens/travel_details/travel_plan_details_page.dart';

class TravelPlanCard extends ConsumerWidget {
  const TravelPlanCard({required this.travelPlan, super.key});

  final TravelPlan travelPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTravelPlanNotifier = ref.read(
      currentTravelPlanProvider.notifier,
    );

    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 170,
      child: Stack(
        children: <Widget>[
          Card.outlined(
            margin: EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Image(
                      image: AssetImage(
                        'assets/images/galaksi-placeholder.jpg',
                      ),
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
                            const Icon(Symbols.alarm),
                            Text(
                              "Happening in 2 days",
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(Symbols.calendar_month),
                            Text(
                              "May 5 - June 3, 2025",
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(Symbols.map),
                            Text(
                              travelPlan.activities.isEmpty
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
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  currentTravelPlanNotifier.state = travelPlan;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TravelPlanDetailsPage(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
