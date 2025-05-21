import 'package:flutter/material.dart';
import 'package:galaksi/screens/main/find_people_page.dart';
import 'package:galaksi/screens/main/home_page.dart';
import 'package:galaksi/screens/main/my_friends_page.dart';
import 'package:galaksi/screens/main/profile_page.dart';
import 'package:galaksi/screens/overlays/create_travel_plan_page.dart';
import 'package:material_symbols_icons/symbols.dart';

/// [BasePage] will act as a Parent of the following pages through a [NavigationBar]:
/// [HomePage], [FindPeoplePage], [ProfilePage], [MyFriendsPage]
class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedPage = 0;

  final List<Widget> _pages =
      [
        const HomePage(),
        const FindPeoplePage(),
        const ProfilePage(),
        const MyFriendsPage(),
      ].map((page) {
        return AnimatedSwitcher(duration: Durations.short3, child: page);
      }).toList();

  final _navigationItems = [
    const NavigationDestination(
      selectedIcon: Icon(Symbols.home),
      icon: Icon(Symbols.home),
      label: 'Home',
    ),
    const NavigationDestination(
      selectedIcon: Icon(Symbols.person_search),
      icon: Icon(Symbols.person_search),
      label: 'Find People',
    ),
    const NavigationDestination(
      selectedIcon: Icon(Symbols.account_circle),
      icon: Icon(Symbols.account_circle),
      label: 'Profile',
    ),
    const NavigationDestination(
      selectedIcon: Icon(Symbols.notifications),
      icon: Icon(Symbols.notifications),
      label: 'Notifications',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          _selectedPage == 0
              ? FloatingActionButton(
                enableFeedback: true,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const CreateTravelPlanPage(),
                    ),
                  );
                },
                child: const Icon(Symbols.add_location_alt),
              )
              : null,
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: _navigationItems,
        selectedIndex: _selectedPage,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
      body: _pages[_selectedPage],
    );
  }
}
