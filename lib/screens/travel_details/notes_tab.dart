import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/note_model.dart';
import 'package:galaksi/screens/overlays/create_travel_activity_page.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';

class NotesTab extends StatelessWidget {
  NotesTab({required this.travelPlanId, required this.notes, super.key});

  final String travelPlanId;
  final List<Note> notes;
  final List<Note> notesTemp = [
    Note(
      authorID: "William",
      message:
          "I just want to remind everyone to be careful when descending down the mountain. Anyways, food is on me when we get down. :) Happy hiking!",
      createdAt: DateTime(2025, 5, 5, 9, 1),
    ),
    Note(
      authorID: "Claire",
      message:
          "Things to bring for Everest Summit: \n1. Hiking bag, \n2. Individual tents, \n3. Food and water not exceeding 25 kg",
      createdAt: DateTime(2025, 5, 8, 14, 12),
    ),
    Note(
      authorID: "David",
      message:
          "Don't forget the extra batteries for headlamps! It gets dark quickly up there.",
      createdAt: DateTime(2025, 5, 6, 18, 30),
    ),
    Note(
      authorID: "Sarah",
      message:
          "I've packed some high-energy snacks. Let me know if anyone has dietary restrictions.",
      createdAt: DateTime(2025, 5, 7, 10, 0),
    ),
    Note(
      authorID: "Michael",
      message:
          "Confirming the satellite phone is fully charged and tested. Safety first!",
      createdAt: DateTime(2025, 5, 4, 22, 0),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CreateDetailsButton(
            text: "Add a note...",
            leadingIcon: const Icon(Symbols.add),
            trailingIcon: const Icon(Symbols.edit),
            navigateTo: CreateTravelActivityPage(travelPlanId: travelPlanId),
          ),
        ),
        SliverList.builder(
          itemCount: notesTemp.length,
          itemBuilder: (context, index) {
            final note = notesTemp[index];
            final formattedDate =
                "${note.createdAt.toLocal().month}/${note.createdAt.toLocal().day}/${note.createdAt.toLocal().year}";
            final formattedTime =
                "${note.createdAt.toLocal().hour}:${note.createdAt.toLocal().minute.toString().padLeft(2, '0')}";

            return Card.outlined(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
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
                            border: Border.all(color: Colors.grey, width: 16.0),
                          ),
                        ),
                        const SizedBox(width: 6.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  note.authorID,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(" added a note: "),
                              ],
                            ),
                            Text("$formattedDate at $formattedTime"),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      note.message,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
