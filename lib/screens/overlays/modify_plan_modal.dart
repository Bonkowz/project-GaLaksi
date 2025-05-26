import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/travel_activity_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/notifications/notification_service_provider.dart';
import 'package:galaksi/providers/travel_plan/edit_travel_plan_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/screens/travel_details/edit_travel_plan_page.dart';

class ModifyPlanModal extends ConsumerWidget {
  const ModifyPlanModal({super.key, required this.travelPlanId});

  final String travelPlanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelPlan =
        ref.watch(travelPlanStreamProvider(travelPlanId)).valueOrNull;
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
                    'Modify Plan',
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
                'Edit travel plan or delete',
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
                              (context) =>
                                  EditTravelPlanPage(travelPlan: travelPlan!),
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
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 500), () {
                        FirebaseFirestoreApi().deleteTravelPlan(travelPlan!.id);
                      });
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
