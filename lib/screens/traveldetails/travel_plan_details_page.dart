import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

final tabIndex = StateProvider<int>((ref) => 0); // 0 for Itinerary, 1 for Notes

class TravelPlanDetailsPage extends ConsumerStatefulWidget {
  const TravelPlanDetailsPage({super.key});

  @override
  ConsumerState<TravelPlanDetailsPage> createState() =>
      _TravelPlanDetailsPageState();
}

class _TravelPlanDetailsPageState extends ConsumerState<TravelPlanDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final double appBarHeight = 280;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(tabIndex.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTabIndex = ref.watch(tabIndex);
    _tabController.index = selectedTabIndex;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: const Icon(Symbols.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Symbols.ios_share),
                onPressed: () {
                  // TODO: Implement share
                },
              ),
              const SizedBox(width: 4.0),
              IconButton(
                icon: const Icon(Symbols.settings),
                onPressed: () {
                  // TODO: Implement more options
                },
              ),
            ],
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            expandedHeight: appBarHeight,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Everest Trek", // Title
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "May 5 - June 5, 2025", // Date range
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                  ],
                ),
              ),
              background: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [Tab(text: "Itinerary"), Tab(text: "Notes")],
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
                  Theme.of(context).colorScheme.onSurfaceVariant,
              indicatorColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [buildItineraryTab(), buildNotesTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItineraryTab() {
    final tempItineraryItems = <List<String>>[
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tempItineraryItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
    );
  }

  Widget buildNotesTab() {
    final noteItems = <List<String>>[
      [
        "William",
        "May 5, 2025 at 9:01 AM",
        "I just want to remind everyone to be careful when descending down the mountain. Anyways, food is on me when we get down. :) Happy hiking!",
      ],
      [
        "Claire",
        "May 8, 2025 at 2:12 PM",
        "Things to bring for Everest Summit: \n1. Hiking bag, \n2. Individual tents, \n3. Food and water not exceeding 25 kg",
      ],
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: noteItems.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Card(
            elevation: 0.5,
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 16.0),
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${noteItems[index][0]} added a note:"),
                          Text(noteItems[index][1]),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    noteItems[index][2], // Note content
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
