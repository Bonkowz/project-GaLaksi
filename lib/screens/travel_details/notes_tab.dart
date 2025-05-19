import 'package:flutter/material.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';

class NotesTab extends StatelessWidget {
  NotesTab({super.key});

  final noteItems = <List<String>>[
    [
      "William",
      "May 5, 2025 at 9:01 AM",
      "I just want to remind everyone to be careful when descending down the mountain. Anyways, food is on me when we get down. :) Happy hiking!",
    ],
    [
      "Claire",
      "May 8, 2025 at 2:12 PM",
      "Things to bring for Everest Summit: \n1. Hiking bag, \n2. Individual tents, \n3. Food and water not exceeding 25 kg",
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CreateDetailsButton(
          text: "Add a note...",
          leadingIcon: const Icon(
            Symbols.add,
          ), // TODO: Convert to profile image...
          trailingIcon: const Icon(Symbols.edit),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: noteItems.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Card(
                elevation: 0.5,
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                width: 16.0,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${noteItems[index][0]} added a note:"),
                              Text(noteItems[index][1]),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        noteItems[index][2], // Note content
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
