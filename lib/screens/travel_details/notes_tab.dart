import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/note_model.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:galaksi/screens/overlays/add_note_page.dart';

class NotesTab extends StatelessWidget {
  NotesTab({required this.travelPlanId, required this.notes, super.key});

  final String travelPlanId;
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CreateDetailsButton(
            text: "Add a note...",
            leadingIcon: const Icon(Symbols.add),
            trailingIcon: const Icon(Symbols.edit),
            navigateTo: AddNotePage(travelPlanId: travelPlanId),
          ),
        ),
        SliverList.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
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
