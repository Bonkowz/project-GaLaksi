import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/widgets/travel_plan_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myTravelPlans = ref.watch(myTravelPlansStreamProvider);
    final user = ref.watch(currentUserStreamProvider);

    final myTravelPlansView = myTravelPlans.when(
      data:
          (plans) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                plans.map((plan) => TravelPlanCard(travelPlan: plan)).toList(),
          ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (err, stack) => Center(
            child: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
    );

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 1.75,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Hey, Steve!"), Text("Where to?")],
              ),
              Text("galaksi"),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Your trips")),
              Tab(child: Text("Shared with you")),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: TabBarView(
            children: [
              SingleChildScrollView(child: myTravelPlansView),
              Center(child: Text("Shared with you")),
            ],
          ),
        ),
      ),
    );
  }
}
