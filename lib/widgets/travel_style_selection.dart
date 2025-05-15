import 'package:flutter/material.dart';
import 'package:galaksi/models/user/travel_style_model.dart';

class TravelStyleSelection extends StatefulWidget {
  const TravelStyleSelection({super.key, required this.selectionMap});

  final Map<TravelStyle, bool> selectionMap;

  @override
  State<TravelStyleSelection> createState() => _TravelStyleSelectionState();
}

class _TravelStyleSelectionState extends State<TravelStyleSelection> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children:
          widget.selectionMap.keys.map((style) {
            return Card.outlined(
              clipBehavior: Clip.hardEdge,
              child: CheckboxListTile(
                title: Text(
                  style.title,
                  style: TextStyle(color: colorScheme.onPrimaryContainer),
                ),
                value: widget.selectionMap[style],
                onChanged: (value) {
                  setState(() {
                    widget.selectionMap[style] = value ?? false;
                  });
                },
              ),
            );
          }).toList(),
    );
  }
}
