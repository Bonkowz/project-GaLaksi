import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/widgets/home_loading_page.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/widgets/travel_plan_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

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
                  Row(
                    children: [
                      Text(
                        "Hey, ",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: Durations.medium4,
                        child: Text(
                          authState.user != null
                              ? "${authState.user!.firstName}!"
                              : "traveler!",
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          key: ValueKey(
                            authState.user?.firstName ?? "traveler",
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text("Where to?", style: textTheme.titleMedium),
                ],
              ),
              RichText(
                text: TextSpan(
                  text: "gala",
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: "ksi",
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(child: Text("Your trips")),
              Tab(child: Text("Shared with you")),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [TravelPlansView(), Center(child: Text("Shared with you"))],
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:
                  plans
                      .map((plan) => TravelPlanCard(travelPlan: plan))
                      .toList(),
            ),
          ),
        );
      },
      loading: () => const SingleChildScrollView(child: HomeLoadingPage()),
      error: (err, stack) {
        debugPrint("$err");
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Error: $err',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }
}
