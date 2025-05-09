import 'package:flutter/material.dart';
import 'package:galaksi/screens/main/find_people_page.dart';
import 'package:galaksi/screens/main/home_page.dart';
import 'package:galaksi/screens/main/my_friends_page.dart';
import 'package:galaksi/screens/main/profile_page.dart';

/// [BasePage] will act as a Parent of the following pages through a [CustomBottomNavBar]:
/// [HomePage], [FindPeoplePage], [ProfilePage], [MyFriendsPage]
class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedPage = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const FindPeoplePage(),
    const ProfilePage(),
    const MyFriendsPage(),
  ];

  final _navigationItems = [
    const NavigationDestination(
      selectedIcon: Icon(Icons.home),
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    const NavigationDestination(
      selectedIcon: Icon(Icons.person_search),
      icon: Icon(Icons.person_search_outlined),
      label: 'Find People',
    ),
    const NavigationDestination(
      selectedIcon: Icon(Icons.account_circle),
      icon: Icon(Icons.account_circle_outlined),
      label: 'Profile',
    ),
    const NavigationDestination(
      selectedIcon: Icon(Icons.notifications),
      icon: Icon(Icons.notifications_outlined),
      label: 'Notifications',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        onPressed: () {},
        child: const Icon(Icons.add_location_alt),
      ),
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
