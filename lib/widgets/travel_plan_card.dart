import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';

class TravelPlanCard extends StatelessWidget {
  const TravelPlanCard(this.travelPlan, {super.key});

  final TravelPlan travelPlan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.zero +
          EdgeInsets.only(top: 8) +
          EdgeInsets.only(bottom: 8),
      height: 200,
      child: Card.outlined(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            Text(travelPlan.title),
            Text(travelPlan.description),
            Text("${travelPlan.activities.length} activities"),
          ],
        ),
      ),
    );
  }
}
