import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:galaksi/models/travel_style_model.dart';
import 'package:galaksi/providers/onboarding/onboarding_notifier.dart';
import 'package:material_symbols_icons/symbols.dart';

class Onboarding3Styles extends ConsumerStatefulWidget {
  const Onboarding3Styles({super.key});

  @override
  ConsumerState<Onboarding3Styles> createState() => _Onboarding3StylesState();
}

class _Onboarding3StylesState extends ConsumerState<Onboarding3Styles> {
  final selectionMap = <TravelStyle, bool>{
    for (final style in TravelStyle.values) style: false,
  };

  void _saveStyles() {
    final selectedStyles =
        selectionMap.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toSet();
    ref
        .read(onboardingNotifierProvider.notifier)
        .updateTravelStyles(selectedStyles);
  }

  void prevPage() {
    _saveStyles();
    ref.read(onboardingNotifierProvider.notifier).prevPage();
  }

  void nextPage() {
    _saveStyles();
    ref.read(onboardingNotifierProvider.notifier).nextPage();
  }

  @override
  void initState() {
    super.initState();
    for (final style in TravelStyle.values) {
      selectionMap[style] = ref
          .read(onboardingNotifierProvider)
          .travelStyles
          .contains(style);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

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
            "How do you like to travel?",
            style: textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children:
                    selectionMap.keys.map((style) {
                      return Card.outlined(
                        clipBehavior: Clip.hardEdge,
                        child: CheckboxListTile(
                          title: Text(
                            style.title,
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          value: selectionMap[style],
                          onChanged: (value) {
                            setState(() {
                              selectionMap[style] = value ?? false;
                            });
                          },
                        ),
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
                        onPressed:
                            selectionMap.containsValue(true)
                                ? () => nextPage()
                                : null,
                        label: const Text("Next"),
                        icon: const Icon(Symbols.arrow_forward_rounded),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    selectionMap.forEach(
                      (style, _) => selectionMap[style] = false,
                    );
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
