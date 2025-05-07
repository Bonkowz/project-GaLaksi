import 'package:flutter/material.dart';
import 'package:galaksi/screens/main/find_people_page.dart';
import 'package:galaksi/screens/main/home_page.dart';
import 'package:galaksi/screens/main/my_friends_page.dart';
import 'package:galaksi/screens/main/profile_page.dart';
import 'package:galaksi/widgets/custom_bottom_nav_bar.dart';

/// [BasePage] will act as a Parent of the following pages through a [CustomBottomNavBar]:
/// [HomePage], [FindPeoplePage], [ProfilePage], [MyFriendsPage]
class BasePage extends StatefulWidget {
  const BasePage({super.key});

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  int _selectedPage = 0;

  void _setPage(int index) {
    setState(() {
      _selectedPage = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const FindPeoplePage(),
    const ProfilePage(),
    const MyFriendsPage(),
  ];

  final _navigationItems = [
    {'pageIndex': 0, 'icon': Icons.home, 'label': "Home"},
    {'pageIndex': 1, 'icon': Icons.person_search, 'label': "Find People"},
    {'pageIndex': 2, 'icon': Icons.person, 'label': "Me"},
    {'pageIndex': 3, 'icon': Icons.people, 'label': "Friends"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        enableFeedback: true,
        onPressed: () {},
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        shape: const CircleBorder(),
        child: Icon(
          Icons.add_location_alt,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        items: _navigationItems,
        selectedPage: _selectedPage,
        onPageSelected: _setPage,
      ),
      body: _pages[_selectedPage],
    );
  }
}
