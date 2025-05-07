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

  List<Widget> _navigationButtons(
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    final theme = Theme.of(context);

    return items.map((item) {
      final isSelected = item['pageIndex'] == _selectedPage;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => _setPage(item['pageIndex'] as int),
            icon: Icon(
              item['icon'] as IconData,
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : theme.iconTheme.color,
            ),
          ),
          Text(
            item['label'] as String,
            style: theme.textTheme.labelSmall!.copyWith(
              color:
                  isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent, // Hide but reserve space
            ),
          ),
        ],
      );
    }).toList();
  }

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
      bottomNavigationBar: BottomAppBar(
        notchMargin: 8,
        elevation: 100, // Slight lift
        shadowColor: Colors.black,
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.surfaceContainer,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _navigationButtons(
                  context,
                  _navigationItems.sublist(0, 2),
                ),
              ),
            ),
            const Expanded(flex: 1, child: Spacer()),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _navigationButtons(
                  context,
                  _navigationItems.sublist(2, 4),
                ),
              ),
            ),
          ],
        ),
      ),
      body: _pages[_selectedPage],
    );
  }
}
