import 'package:flutter/material.dart';
import 'package:galaksi/models/travel_plan/travel_plan_model.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:material_symbols_icons/symbols.dart';

class SharedUsersModal extends StatefulWidget {
  const SharedUsersModal({required this.users, super.key});
  final List<String> users;

  @override
  State<SharedUsersModal> createState() => _SharedUsersModalState();
}

class _SharedUsersModalState extends State<SharedUsersModal> {
 @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8, 
      child: Material( 
        borderRadius: const BorderRadius.all(Radius.circular(16.0)), 
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shared people',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  final username = widget.users[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Symbols.person)
                        ),
                        title: Text(username),
                        // TODO: add role validation
                        // subtitle: Text(testSharedUser[index]['role']!),
                        trailing: IconButton(
                          icon: const Icon(Symbols.remove),
                          onPressed: () {
                            // TODO: add remove here
                          },
                        )
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}