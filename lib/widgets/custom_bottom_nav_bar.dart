import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int selectedPage;
  final Function(int) onPageSelected;

  const CustomBottomNavBar({
    super.key,
    required this.items,
    required this.selectedPage,
    required this.onPageSelected,
  });

  List<Widget> _navigationButtons(
    BuildContext context,
    List<Map<String, dynamic>> items,
  ) {
    final theme = Theme.of(context);

    return items.map((item) {
      final isSelected = item['pageIndex'] == selectedPage;

      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => onPageSelected(item['pageIndex'] as int),
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
    return BottomAppBar(
      notchMargin: 8,
      elevation: 100, // Slight lift
      shadowColor: Colors.black,
      shape: const CircularNotchedRectangle(),
      color: Theme.of(context).colorScheme.surfaceContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left Side Navigation
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _navigationButtons(context, items.sublist(0, 2)),
            ),
          ),

          // Spacing Reserved for Notch
          const Expanded(flex: 1, child: Spacer()),

          // Right Side Navigation
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _navigationButtons(context, items.sublist(2, 4)),
            ),
          ),
        ],
      ),
    );
  }
}
