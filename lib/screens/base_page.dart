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

  List<Widget> _navigationButtons(BuildContext context) {
    final icons = [
      {'pageIndex': 0, 'icon': Icons.home, 'label': "Home"},
      {'pageIndex': 1, 'icon': Icons.person_search, 'label': "Find People"},
      // Icons.person_search,
      // null,
      {'pageIndex': 2, 'icon': Icons.person, 'label': "Me"},
      {'pageIndex': 3, 'icon': Icons.people, 'label': "Friends"},
      // Icons.person,
      // Icons.people,
    ];

    final theme = Theme.of(context);

    return icons.map((item) {
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
          if (isSelected)
            Text(
              item['label'] as String,
              style: theme.textTheme.labelSmall!.copyWith(
                color: theme.colorScheme.primary,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _navigationButtons(context),
        ),
      ),
      body: _pages[_selectedPage],
    );
  }
}
