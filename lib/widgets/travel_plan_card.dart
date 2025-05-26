import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:galaksi/screens/travel_details/travel_plan_details_page.dart';
import 'package:galaksi/utils/string_utils.dart';

class TravelPlanCard extends ConsumerWidget {
  const TravelPlanCard({required this.travelPlan, super.key});

  final TravelPlan travelPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 19,
                    child:
                        travelPlan.image.isNotEmpty
                            ? Image(
                              image: MemoryImage(
                                base64Decode(travelPlan.image),
                              ),
                              fit: BoxFit.cover,
                            )
                            : const Image(
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
                              overflow: TextOverflow.ellipsis,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(Symbols.alarm),
                            Flexible(
                              child: Text(
                                StringUtils.getTravelPlanStatusText(travelPlan),
                                overflow: TextOverflow.ellipsis,
                                style: textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(Symbols.calendar_month),
                            Expanded(
                              child: Text(
                                StringUtils.getTravelPlanDateRange(travelPlan),
                                style: textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(Symbols.map),
                            Expanded(
                              child: Text(
                                travelPlan.activities.isEmpty
                                    ? "No activities yet"
                                    : "${travelPlan.activities.length} activit${travelPlan.activities.length > 1 ? "ies" : "y"}",
                                style: textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
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
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) => TravelPlanDetailsPage(
                            travelPlanId: travelPlan.id,
                          ),
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
