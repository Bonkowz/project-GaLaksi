import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/user/interest_model.dart';
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
                    MaterialPageRoute(
                      builder: (context) => const EditProfilePage(),
                    ),
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
    final user = ref.watch(authNotifierProvider).user!;
    final image = user.image;
    final s = user.firstName[0].toUpperCase();
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
      child:
          image.isEmpty
              ? CircleAvatar(
                radius: innerRadius,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  StringUtils.capitalize(s),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              )
              : CircleAvatar(
                radius: innerRadius,
                backgroundImage: MemoryImage(base64Decode(image)),
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Text(
                "@${user.username}",
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              if (user.isPrivate)
                Icon(
                  Symbols.visibility_off_rounded,
                  color: Theme.of(context).colorScheme.outline,
                ),
            ],
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
              user.phoneNumber.isNotEmpty
                  ? Expanded(child: infoCard("Phone Number", user.phoneNumber))
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _biography() {
    final user = ref.watch(authNotifierProvider).user!;

    if (user.biography.trim().isEmpty) {
      return const SizedBox.shrink();
    }

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
            Text(user.biography, style: Theme.of(context).textTheme.bodyMedium),
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
            ...Interest.categorized.entries.map((entry) {
              final category = entry.key;
              final interests =
                  entry.value
                      .where((e) => user.interests!.contains(e))
                      .toList();
              if (interests.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 18, bottom: 6),
                    child: Text(
                      StringUtils.capitalize(category.title),
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        interests.where((e) => user.interests!.contains(e)).map(
                          (e) {
                            return Chip(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              label: Text(e.title),
                            );
                          },
                        ).toList(),
                  ),
                ],
              );
            }),
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
