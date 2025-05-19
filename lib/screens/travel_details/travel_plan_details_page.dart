import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/screens/travel_details/itinerary_tab.dart';
import 'package:galaksi/screens/travel_details/notes_tab.dart';
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
              children: [ItineraryTab(), NotesTab()],
            ),
          ),
        ],
      ),
    );
  }
}
