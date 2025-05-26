import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/screens/overlays/modify_plan_modal.dart';
import 'package:galaksi/screens/travel_details/edit_travel_plan_page.dart';
import 'package:galaksi/screens/travel_details/itinerary_tab.dart';
import 'package:galaksi/screens/travel_details/notes_tab.dart';
import 'package:galaksi/utils/string_utils.dart';
import 'package:galaksi/utils/dialog.dart';
import 'package:galaksi/widgets/travel_plan_qr_code.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:galaksi/screens/overlays/shared_users_modal.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:galaksi/screens/travel_details/accomodations_tab.dart';
import 'package:galaksi/screens/travel_details/flights_tab.dart';

final tabIndex = StateProvider<int>((ref) => 0); // 0 for Itinerary, 1 for Notes

class TravelPlanDetailsPage extends ConsumerStatefulWidget {
  const TravelPlanDetailsPage({required this.travelPlanId, super.key});

  final String travelPlanId;

  @override
  ConsumerState<TravelPlanDetailsPage> createState() =>
      _TravelPlanDetailsPageState();
}

class _TravelPlanDetailsPageState extends ConsumerState<TravelPlanDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final double appBarHeight = 280;
  void _showSharedUsersDialog(BuildContext context, TravelPlan plan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(child: SharedUsersModal(travelPlanId: plan.id));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

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

  Widget buildTravelPlan(TravelPlan plan) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder:
            (context, innerBoxIsScrolled) => [
              SliverAppBar(
                leading: IconButton(
                  icon: const Icon(Symbols.arrow_back),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Symbols.qr_code_rounded),
                    onPressed:
                        () => showCustomDialog(
                          context: context,
                          child: TravelPlanQrCode(travelPlan: plan),
                        ),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    icon: const Icon(Symbols.people_rounded),
                    onPressed: () {
                      _showSharedUsersDialog(context, plan);
                    },
                  ),
                  const SizedBox(width: 4.0),
                  user?.uid == plan.creatorID
                      ? IconButton(
                        icon: const Icon(Symbols.settings),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: ModifyPlanModal(travelPlanId: plan.id),
                              );
                            },
                          );

                          // debugPrint("Pressed");
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder:
                          //         (context) =>
                          //             EditTravelPlanPage(travelPlan: plan),
                          //   ),
                          // );
                        },
                      )
                      : const SizedBox.shrink(),
                ],
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                expandedHeight: appBarHeight,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: Container(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          bottom: 64.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.title,
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              StringUtils.getTravelPlanDateRange(plan),
                              style: Theme.of(
                                context,
                              ).textTheme.titleSmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: "Itinerary"),
                    Tab(text: "Notes"),
                    Tab(text: "Flights"),
                    Tab(text: "Lodge"),
                  ],
                  labelColor: Theme.of(context).colorScheme.primary,
                  unselectedLabelColor:
                      Theme.of(context).colorScheme.onSurfaceVariant,
                  indicatorColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              ItineraryTab(
                travelPlanId: widget.travelPlanId,
                activities: plan.activities,
              ),
              NotesTab(travelPlanId: widget.travelPlanId, notes: plan.notes),
              FlightsTab(
                travelPlanId: widget.travelPlanId,
                flights: plan.flightDetails,
              ),
              AccommodationsTab(
                travelPlanId: widget.travelPlanId,
                accommodations: plan.accommodations,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedTabIndex = ref.watch(tabIndex);
    _tabController.index = selectedTabIndex;
    final travelPlan = ref.watch(travelPlanStreamProvider(widget.travelPlanId));

    return travelPlan.when(
      data: (data) => buildTravelPlan(data!),
      loading:
          () => Skeletonizer(
            enabled: true,
            child: buildTravelPlan(
              TravelPlan(
                id: "id",
                title: "title",
                description: "description",
                creatorID: "creatorID",
                sharedWith: [],
                notes: [],
                activities: [],
                flightDetails: [],
                accommodations: [],
              ),
            ),
          ),
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
