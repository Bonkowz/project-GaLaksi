import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/apis/firebase_firestore_api.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/providers/travel_plan/get_travel_plan_provider.dart';
import 'package:galaksi/providers/user_profile/user_profile_notifier.dart';
import 'package:galaksi/utils/dummy_data.dart';
import 'package:galaksi/utils/input_decorations.dart';
import 'package:galaksi/widgets/error_card.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SharedUsersModal extends ConsumerStatefulWidget {
  const SharedUsersModal({required this.travelPlanId, super.key});
  final String travelPlanId;

  @override
  ConsumerState<SharedUsersModal> createState() => _SharedUsersModalState();
}

class _SharedUsersModalState extends ConsumerState<SharedUsersModal> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  String? error;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _addUserByUsername() async {
    try {
      final username = _usernameController.text.trim();
      if (username.isEmpty) return;
      setState(() => error = null);

      if (username == ref.watch(authNotifierProvider).user!.username) {
        setState(() => error = "You already own this travel plan");
        return;
      }

      setState(() => _isLoading = true);
      final doc =
          (await FirebaseFirestoreApi().getUserDocumentByUsername(
            username,
          )).valueOrNull;

      if (mounted && doc == null) {
        setState(() => error = "User @$username not found");
        return;
      }
      final user = User.fromDocument(doc!);

      final travelPlan =
          ref.watch(travelPlanStreamProvider(widget.travelPlanId)).value!;

      try {
        // Add current user UID to the travel plan's sharedWith list if not already present
        final updatedSharedWith = List<String>.from(travelPlan.sharedWith);
        if (!updatedSharedWith.contains(user.uid)) {
          updatedSharedWith.add(user.uid);
        } else {
          setState(() => error = "@$username already joined this travel plan.");
          return;
        }

        // Create a new TravelPlan object with updated sharedWith
        final updatedPlan = TravelPlan(
          id: travelPlan.id,
          title: travelPlan.title,
          description: travelPlan.description,
          creatorID: travelPlan.creatorID,
          sharedWith: updatedSharedWith,
          notes: travelPlan.notes,
          activities: travelPlan.activities,
          flightDetails: travelPlan.flightDetails,
          accommodations: travelPlan.accommodations,
        );

        // Update in Firestore
        final result = await FirebaseFirestoreApi().editTravelPlan(updatedPlan);
        result.when(
          onSuccess: (success) {
            if (success.data) {
              setState(() {
                error = null;
              });
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
      _usernameController.clear();
    } catch (e) {
      if (mounted) {
        setState(() => error = "Failed to add user.");
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final travelPlan =
        ref.watch(travelPlanStreamProvider(widget.travelPlanId)).value!;

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
                    'Shared people',
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
              if (error != null)
                Column(
                  children: [
                    const SizedBox(height: 8.0),
                    ErrorCard(error: error),
                    const SizedBox(height: 8.0),
                  ],
                ),
              const SizedBox(height: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _usernameController,
                    onTapOutside:
                        (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: InputDecorations.outlineBorder(
                      context: context,
                      prefixIcon: const Icon(Symbols.person_add_rounded),
                      labelText: "Add by username",
                      hintText: "Enter username",
                      borderColor: Theme.of(context).colorScheme.primary,
                      borderRadius: 12,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _isLoading ? null : _addUserByUsername,
                    label: const Text("Add user"),
                    icon:
                        _isLoading
                            ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                            : const Icon(Symbols.add_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              if (travelPlan.sharedWith.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "No users joined this travel plan yet.",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            "Shared to",
                            style: Theme.of(
                              context,
                            ).textTheme.labelMedium?.copyWith(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: travelPlan.sharedWith.length,
                      itemBuilder: (context, index) {
                        final userId = travelPlan.sharedWith[index];
                        final user = ref.watch(
                          userProfileStreamProvider(userId),
                        );

                        return user.when(
                          data: (user) {
                            return _UserTile(user: user);
                          },
                          error: (error, stackTrace) {
                            return ListTile(
                              leading: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                              title: const Text('Failed to load user'),
                              subtitle: Text(error.toString()),
                            );
                          },
                          loading: () {
                            return Skeletonizer(
                              child: _UserTile(user: dummyUser),
                            );
                          },
                        );
                      },
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

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: UserAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        textColor: Theme.of(context).colorScheme.onPrimaryContainer,
        firstName: user.firstName,
        image: user.image,
      ),
      title: Text(
        "${user.firstName} ${user.lastName}",
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(user.username),
      // TODO: add role validation
      // subtitle: Text(testSharedUser[index]['role']!),
      trailing: IconButton(
        icon: const Icon(Symbols.remove),
        onPressed: () {
          // TODO: add remove here
        },
      ),
    );
  }
}
