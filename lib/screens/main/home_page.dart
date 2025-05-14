import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/widgets/travel_plan_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight * 1.75,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Hey, ${authState.user?.firstName ?? "traveler"}!"),
                  const Text("Where to?"),
                ],
              ),
              const Text("galaksi"),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Your trips")),
              Tab(child: Text("Shared with you")),
            ],
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: TabBarView(
            children: [
              TravelPlansView(),
              Center(child: Text("Shared with you")),
            ],
          ),
        ),
      ),
    );
  }
}

class TravelPlansView extends ConsumerWidget {
  const TravelPlansView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsyncValue = ref.watch(myTravelPlansStreamProvider);

    return plansAsyncValue.when(
      data: (plans) {
        if (plans.isEmpty) {
          return Center(
            child: Text(
              "No plans... so far.",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children:
                plans.map((plan) => TravelPlanCard(travelPlan: plan)).toList(),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error:
          (err, stack) => Center(
            child: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
    );
  }
}
