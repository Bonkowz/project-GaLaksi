import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/interest_model.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:collection/collection.dart';
import 'package:material_symbols_icons/symbols.dart';

class Onboarding2Interests extends ConsumerStatefulWidget {
  const Onboarding2Interests({super.key});

  @override
  ConsumerState<Onboarding2Interests> createState() =>
      _Onboarding2InterestsState();
}

class _Onboarding2InterestsState extends ConsumerState<Onboarding2Interests> {
  final selection = <Interest>{};

  final categorizedInterests = Interest.values.groupListsBy(
    (interest) => interest.category,
  );

  void _saveInterests() {
    ref.read(onboardingNotifierProvider.notifier).updateInterests(selection);
  }

  void prevPage() {
    _saveInterests();
    ref.read(onboardingNotifierProvider.notifier).prevPage();
  }

  void nextPage() {
    _saveInterests();
    ref.read(onboardingNotifierProvider.notifier).nextPage();
  }

  @override
  void initState() {
    super.initState();
    selection.addAll(ref.read(onboardingNotifierProvider).interests);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Excited to travel? and subtitle
          Center(
            child: Column(
              children: [
                Text(
                  "Excited to travel?",
                  style: textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text("We'd like to personalize your experience."),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            "What are your interests?",
            style: textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                    categorizedInterests.entries.map((entry) {
                      final category = entry.key;
                      final interests = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 18, bottom: 6),
                            child: Text(
                              StringUtils.capitalize(category.title),
                              style: textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children:
                                interests.map((e) {
                                  return InputChip(
                                    label: Text(e.title),
                                    selected: selection.contains(e),
                                    onSelected: (selected) {
                                      setState(() {
                                        if (selected) {
                                          selection.add(e);
                                        } else {
                                          selection.remove(e);
                                        }
                                      });
                                    },
                                  );
                                }).toList(),
                          ),
                        ],
                      );
                    }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed:
                            ref.read(onboardingNotifierProvider).isLoading
                                ? null
                                : () => prevPage(),
                        label: const Text("Go back"),
                        icon: const Icon(Symbols.arrow_back_rounded),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: selection.isNotEmpty ? nextPage : null,
                        label: const Text("Next"),
                        icon: const Icon(Symbols.arrow_forward_rounded),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    selection.clear();
                    nextPage();
                  },
                  child: const Text("Skip for now"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
