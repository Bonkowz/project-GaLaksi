import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import '../../providers/user_matching_provider.dart';
import '../../models/user/interest_model.dart';
import '../../models/user/travel_style_model.dart';

// TODOS:
// "add friends" functionality
// "friends" tab contents
// "friend requests" tab contents
class FindPeoplePage extends ConsumerWidget {
  const FindPeoplePage({super.key});

  // TABS
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Social"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Suggestions"),
              Tab(text: "Friends"),
              Tab(text: "Friend Requests"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _SuggestionsTab(),
            const Center(child: Text("Friends Content")),
            const Center(child: Text("Friend Requests Content")),
          ],
        ),
      ),
    );
  }
}

// SUGGESTIONS/FIND SIMILAR PEOPLE
class _SuggestionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMatchesAsync = ref.watch(userMatchingProvider);

    return userMatchesAsync.when(
      data: (matches) {
        if (matches.isEmpty) {
          // if list of matches with "interests" or "travel styles" is empty,
          return const Center(child: Text('No matching users found'));
        }

        // display profiles of matching users
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return _UserProfileCard(
              name: '${match.firstName} ${match.lastName}',
              username: '@${match.username}',
              image: match.image,
              interests: match.interests,
              travelStyles: match.travelStyles,
              commonInterests: match.commonInterests,
              commonTravelStyles: match.commonTravelStyles,
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

// USER PROFILE CARD CONTENTS
class _UserProfileCard extends StatelessWidget {
  const _UserProfileCard({
    required this.name,
    required this.username,
    required this.image,
    required this.interests,
    required this.travelStyles,
    required this.commonInterests,
    required this.commonTravelStyles,
  });

  final String name;
  final String username;
  final String image;
  final List<String> interests;
  final List<String> travelStyles;
  final int commonInterests;

  // number of commonalities/matches (interests + travel styles)
  final int commonTravelStyles;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(image: image, firstName: name),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    username,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  ),
                  // display interests if there is at least 1 common interest
                  if (interests.isNotEmpty && commonInterests > 0) ...[
                    const SizedBox(height: 15.0),
                    Text(
                      "Interests:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      interests
                          .map(
                            (interest) =>
                                Interest.values
                                    .firstWhere((i) => i.name == interest)
                                    .title,
                          )
                          .join(", "),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  // display travel styles if there is at least 1 common travel style
                  if (travelStyles.isNotEmpty && commonTravelStyles > 0) ...[
                    const SizedBox(height: 15.0),
                    Text(
                      "Travel Styles:",
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      travelStyles
                          .map(
                            (style) =>
                                TravelStyle.values
                                    .firstWhere((t) => t.name == style)
                                    .title,
                          )
                          .join(", "),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                // TODO: Implement add friend functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
