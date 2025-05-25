import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/user_model.dart';
import 'package:galaksi/providers/user_profile/user_profile_notifier.dart';
import 'package:galaksi/utils/dummy_data.dart';
import 'package:galaksi/widgets/user_avatar.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SharedUsersModal extends ConsumerStatefulWidget {
  const SharedUsersModal({required this.users, super.key});
  final List<String> users;

  @override
  ConsumerState<SharedUsersModal> createState() => _SharedUsersModalState();
}

class _SharedUsersModalState extends ConsumerState<SharedUsersModal> {
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
              const SizedBox(height: 4.0),
              widget.users.isEmpty
                  ? const Center(child: Text("No shared users yet."))
                  : ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.users.length,
                    itemBuilder: (context, index) {
                      final userId = widget.users[index];
                      final user = ref.watch(userProfileStreamProvider(userId));

                      return user.when(
                        data: (user) {
                          return _UserTile(user: user);
                        },
                        error: (error, stackTrace) {
                          return ListTile(
                            leading: const Icon(Icons.error, color: Colors.red),
                            title: const Text('Failed to load user'),
                            subtitle: Text(error.toString()),
                          );
                        },
                        loading: () {
                          return Skeletonizer(
                            child: _UserTile(user: dummyUser),
                          );
                        },
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

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: UserAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        textColor: Theme.of(context).colorScheme.onPrimaryContainer,
        firstName: user.firstName,
        image: user.image,
      ),
      title: Text(
        "${user.firstName} ${user.lastName}",
        style: const TextStyle(fontWeight: FontWeight.bold),

        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(user.username),
      // TODO: add role validation
      // subtitle: Text(testSharedUser[index]['role']!),
      trailing: IconButton(
        icon: Icon(
          Symbols.remove_circle,
          color: Theme.of(context).colorScheme.error,
        ),
        onPressed: () {
          // TODO: add remove here
        },
      ),
    );
  }
}
