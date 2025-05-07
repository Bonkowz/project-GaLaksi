import 'package:flutter/material.dart';
import 'package:galaksi/screens/main/find_people_page.dart';
import 'package:galaksi/screens/main/home_page.dart';
import 'package:galaksi/screens/main/my_friends_page.dart';
import 'package:galaksi/screens/main/profile_page.dart';

/// [BasePage] will act as a Parent of the following pages through a [BottomNavigationBar]:
/// [HomePage], [FindPeoplePage], [ProfilePage], [MyFriendsPage]
class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  final List<Widget> _pages = [
    const HomePage(),
    const FindPeoplePage(),
    const ProfilePage(),
    const MyFriendsPage(),
  ];

  final List<Widget> _navigationButtons = [
    IconButton(onPressed: () => {}, icon: const Icon(Icons.home)),
    IconButton(onPressed: () => {}, icon: const Icon(Icons.person_search)),
    const SizedBox(width: 50), // Spacing
    IconButton(onPressed: () => {}, icon: const Icon(Icons.person)),
    IconButton(onPressed: () => {}, icon: const Icon(Icons.people)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        child: Icon(
          Icons.add_location_alt,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: const CircleBorder(),
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        elevation: 100, // Slight lift
        shadowColor: Colors.black,
        shape: CircularNotchedRectangle(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _navigationButtons,
        ),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Center(child: Text("Base Page")),
    );
  }
}
