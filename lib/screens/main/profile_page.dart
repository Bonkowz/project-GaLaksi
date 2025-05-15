import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/providers/auth/auth_notifier.dart';
import 'package:galaksi/screens/overlays/edit_profile_page.dart';
import 'package:material_symbols_icons/symbols.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final double coverHeight = 150;
  final double profileHeight = 200;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).user;
    return Scaffold(
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [buildTop(), _profileInfo(), buildAbout()],
                ),
              ),
    );
  }

  Widget buildTop() {
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: kToolbarHeight,
          child: ColoredBox(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: bottom),
              child: buildCoverImage(),
            ),
            Positioned(top: top, child: _profileImage()),
          ],
        ),
      ],
    );
  }

  Widget buildCoverImage() => Stack(
    children: [
      Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        width: double.infinity,
        height: coverHeight,
        // fit: BoxFit.cover,
      ),
      Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
                icon: const Icon(Symbols.edit_rounded),
              ),
              IconButton(
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).signOut();
                },
                icon: const Icon(Symbols.logout_rounded),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _profileImage() {
    final innerRadius = (profileHeight / 2) - 8.0;
    final outerSize = profileHeight;

    return Container(
      width: outerSize,
      height: outerSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).scaffoldBackgroundColor,
          width: 8.0,
        ),
      ),
      child: CircleAvatar(
        radius: innerRadius,
        backgroundColor: Colors.grey.shade600,
      ),
    );
  }

  Widget _profileInfo() {
    final user = ref.watch(authNotifierProvider).user!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            "${user.firstName} ${user.lastName}",
            style: Theme.of(
              context,
            ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "@${user.username}",
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAbout() {
    final user = ref.watch(authNotifierProvider).user!;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _biography(),
          _interests(),
          _travelStyles(),
          Row(
            children: [
              Expanded(child: infoCard("Email", user.email)),
              Expanded(child: infoCard("Phone Number", "---")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _biography() {
    return Card.filled(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Biography",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              "According to all known laws of aviation, there is no way that a bee should be able to fly. Its wings are too small to get its fat little body off the ground. The bee, of course, flies anyway because bees don't care what humans think is impossible. Yellow, black. Yellow, black. Yellow, black. Yellow, black. Ooh, black and yellow!",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _interests() {
    final user = ref.watch(authNotifierProvider).user!;

    if (user.interests?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Card.filled(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Interests",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children:
                  user.interests!
                      .map(
                        (item) => Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          label: Text(item.title),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _travelStyles() {
    final user = ref.watch(authNotifierProvider).user!;

    if (user.travelStyles?.isEmpty ?? true) {
      return const SizedBox.shrink();
    }

    return Card.filled(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Travel Styles",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children:
                  user.travelStyles!
                      .map(
                        (item) => Chip(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                          label: Text(item.title),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget infoCard(String title, String content) => Card.filled(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          FittedBox(
            fit: BoxFit.contain,
            child: Text(content, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    ),
  );
}
