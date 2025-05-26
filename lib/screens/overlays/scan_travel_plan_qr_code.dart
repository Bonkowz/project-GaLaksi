import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart'; // Added import
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/travel_plan/travel_plan_users_provider.dart';
import 'package:galaksi/utils/snackbar.dart';
import 'package:galaksi/widgets/error_card.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ScanTravelPlanQrCode extends ConsumerStatefulWidget {
  const ScanTravelPlanQrCode({super.key});

  @override
  ConsumerState<ScanTravelPlanQrCode> createState() =>
      _ScanTravelPlanQrCodeState();
}

class _ScanTravelPlanQrCodeState extends ConsumerState<ScanTravelPlanQrCode> {
  late final MobileScannerController _controller;

  TravelPlan? _travelPlan;
  bool _joinable = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleScan(BarcodeCapture barcodes) async {
    setState(() {
      _joinable = false;
      _travelPlan = null;
    });

    if (barcodes.barcodes.isEmpty) return;
    await _controller.stop();

    // Fetch the decoded value from qr code
    final value = barcodes.barcodes.last.rawValue;

    // Check if the decoded value is a valid travel plan
    final result =
        FirebaseFirestoreApi().fetchTravelPlanStream(value!).valueOrNull;
    debugPrint("$result");
    if (mounted && result == null) {
      setState(() => error = "Invalid QR code!");
      return;
    }

    // Get the travel plan details
    final document = await result!.map((doc) => doc).first;
    setState(() => _travelPlan = TravelPlan.fromDocument(document));

    if (mounted && _travelPlan == null) {
      setState(() {
        error = "An unknown error occured.";
        _travelPlan = null;
      });
      return;
    }

    // Check if travel plan is owned by current user
    final user = ref.watch(authNotifierProvider).user!;
    if (mounted && user.uid == _travelPlan!.creatorID) {
      setState(() {
        error = "You already own this travel plan.";
      });
      return;
    }

    setState(() => _joinable = true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Join a travel plan", style: textTheme.bodyMedium),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final parentWidth = constraints.maxWidth;
                    final parentHeight = constraints.maxHeight;

                    final scanWindow = Rect.fromCenter(
                      center: Offset(parentWidth / 2, parentHeight / 2),
                      width: double.infinity,
                      height: double.infinity,
                    );
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          if (_travelPlan == null)
                            const Positioned.fill(
                              child: Skeletonizer(child: Card.filled()),
                            ),
                          if (_travelPlan != null)
                            TravelPlanSummary(travelPlan: _travelPlan!),
                          Positioned.fill(
                            child: MobileScanner(
                              controller: _controller,
                              onDetect: _handleScan,
                              scanWindow: scanWindow,
                            ),
                          ),
                          ScanWindowOverlay(
                            controller: _controller,
                            scanWindow: scanWindow,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (error != null) ErrorCard(error: error),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            OutlinedButton.icon(
              onPressed: () async {
                await _controller.start();
                setState(() => error = null);
              },
              label: const Text("Restart"),
              icon: const Icon(Symbols.restart_alt_rounded),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.icon(
                onPressed: _joinable ? _joinTravelPlan : null,
                label: const Text("Join Travel Plan"),
                icon: const Icon(Symbols.check_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _joinTravelPlan() async {
    if (_travelPlan == null) return;
    setState(() => error = null);
    final user = ref.read(authNotifierProvider).user;
    if (user == null) {
      setState(() => error = "You must be logged in to join a travel plan.");
      return;
    }
    try {
      // Add current user UID to the travel plan's sharedWith list if not already present
      final updatedSharedWith = List<String>.from(_travelPlan!.sharedWith);
      if (!updatedSharedWith.contains(user.uid)) {
        updatedSharedWith.add(user.uid);
      } else {
        setState(() => error = "You have already joined this travel plan.");
        return;
      }

      // Create a new TravelPlan object with updated sharedWith
      final updatedPlan = TravelPlan(
        id: _travelPlan!.id,
        title: _travelPlan!.title,
        description: _travelPlan!.description,
        creatorID: _travelPlan!.creatorID,
        sharedWith: updatedSharedWith,
        notes: _travelPlan!.notes,
        activities: _travelPlan!.activities,
        flightDetails: _travelPlan!.flightDetails,
        accommodations: _travelPlan!.accommodations,
      );

      // Update in Firestore
      final result = await FirebaseFirestoreApi().editTravelPlan(updatedPlan);
      result.when(
        onSuccess: (success) {
          if (success.data) {
            setState(() {
              _travelPlan = updatedPlan;
              _joinable = false;
              error = null;
            });
            showSnackbar(
              context: context,
              message: "Successfully joined the travel plan!",
            );
          } else {
            setState(() => error = "Failed to join the travel plan.");
          }
        },
        onFailure: (failure) {
          setState(() => error = failure.message);
        },
      );
    } catch (e) {
      setState(
        () => error = "An error occurred while joining the travel plan.",
      );
    }
  }
}

class TravelPlanSummary extends ConsumerWidget {
  const TravelPlanSummary({required this.travelPlan, super.key});

  final TravelPlan travelPlan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    final usersAsync = ref.watch(travelPlanUsersProvider(travelPlan));
    return usersAsync.when(
      data: (userMap) {
        if (userMap == null) {
          return const ErrorCard(error: "An unknown error occurred.");
        }

        final creator = userMap["creator"]!.first;
        final sharedWith = userMap["sharedWith"]!;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TravelPlanCreatorCard(creator: creator),
            TravelPlanDetailsCard(travelPlan: travelPlan),
            TravelPlanSharedWithCard(sharedWith: sharedWith),
          ],
        );
      },
      error: (error, stackTrace) {
        return const ErrorCard(error: "An unknown error occurred.");
      },
      loading:
          () => Skeletonizer(
            child: Card.outlined(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      BoneMock.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ...[
                      const SizedBox(height: 4),
                      Text(BoneMock.paragraph, style: textTheme.bodyMedium),
                    ],
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}

class TravelPlanCreatorCard extends StatelessWidget {
  const TravelPlanCreatorCard({required this.creator, super.key});

  final User creator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card.filled(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          spacing: 12,
          children: [
            UserAvatar(
              image: creator.image,
              firstName: creator.firstName,
              backgroundColor: colorScheme.primaryContainer,
              textColor: colorScheme.onPrimaryContainer,
              textStyle: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                "You have been invited by ${creator.firstName}!",
                style: textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TravelPlanSharedWithCard extends StatelessWidget {
  const TravelPlanSharedWithCard({required this.sharedWith, super.key});

  final List<User> sharedWith;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            sharedWith.isEmpty
                ? Text(
                  "You're the first to be invited!",
                  style: textTheme.bodyMedium,
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Also invited:",
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          sharedWith.map((user) {
                            return UserAvatar(
                              image: user.image,
                              firstName: user.firstName,
                              backgroundColor: colorScheme.primaryContainer,
                              textColor: colorScheme.onPrimaryContainer,
                              textStyle: textTheme.labelLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
      ),
    );
  }
}

class TravelPlanDetailsCard extends StatelessWidget {
  const TravelPlanDetailsCard({required this.travelPlan, super.key});

  final TravelPlan travelPlan;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              travelPlan.title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            if (travelPlan.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(travelPlan.description, style: textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
