import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/providers/travel_plan/edit_travel_plan_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/screens/overlays/edit_travel_activity_page.dart';

class ModifyActivityModal extends ConsumerWidget {
  const ModifyActivityModal({
    required this.travelPlanId,
    required this.originalActivity,
    required this.indexAt,
    super.key,
  });

  final String travelPlanId;
  final TravelActivity originalActivity;
  final int indexAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modify Activity',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Edit activity or delete',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder:
                              (context) => EditTravelActivityPage(
                                travelPlanId: travelPlanId,
                                originalActivity: originalActivity,
                                indexAt: indexAt,
                              ),
                        ),
                      );
                    },
                    child: Text(
                      'Edit',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      final travelPlan =
                          ref
                              .watch(travelPlanStreamProvider(travelPlanId))
                              .valueOrNull;

                      final editTravelPlanNotifier = ref.read(
                        editTravelPlanNotifierProvider.notifier,
                      );

                      travelPlan!.activities.removeAt(indexAt);

                      editTravelPlanNotifier.setCurrentTravelPlan(travelPlan);

                      final result =
                          await editTravelPlanNotifier.editTravelPlan();
                    },
                    child: Text(
                      'Delete',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
