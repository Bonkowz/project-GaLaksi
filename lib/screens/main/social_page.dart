import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/screens/socials/suggestions_tab.dart';

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
        body: const TabBarView(
          children: [
            SuggestionsTab(),
            Center(child: Text("Friends Content")),
            Center(child: Text("Friend Requests Content")),
          ],
        ),
      ),
    );
  }
}
