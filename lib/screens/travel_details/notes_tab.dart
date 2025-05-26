import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_plan/note_model.dart';
import 'package:galaksi/providers/user_profile/user_profile_notifier.dart';
import 'package:galaksi/widgets/create_details_button.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:galaksi/screens/overlays/add_note_page.dart';

class NotesTab extends ConsumerWidget {
  const NotesTab({required this.travelPlanId, required this.notes, super.key});

  final String travelPlanId;
  final List<Note> notes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            final user =
                ref.watch(userProfileStreamProvider(note.authorID)).valueOrNull;
            if (user == null) {
              return const Card.outlined(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Text("Error decoding user"),
                ),
              );
            }

            return Card.outlined(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        UserAvatar(
                          image: user.image,
                          firstName: user.firstName,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          textColor:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 6.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        style:
                                            DefaultTextStyle.of(context).style,
                                        children: [
                                          TextSpan(
                                            text: user.firstName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: " added a note.",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text("$formattedDate at $formattedTime"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
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
